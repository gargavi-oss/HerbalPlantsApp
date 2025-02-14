import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../models/plant.dart';

class WikipediaService {
  static const String baseUrl = 'https://en.wikipedia.org/w/api.php';

  static Future<List<Plant>> searchPlants(String query) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?action=opensearch&search=$query&limit=10&namespace=0&format=json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<String> titles = List<String>.from(data[1]);
      final List<String> descriptions = List<String>.from(data[2]);
      final List<String> urls = List<String>.from(data[3]);

      return List.generate(
        titles.length,
            (index) => Plant(
          id: titles[index],
          name: titles[index],
          scientificName: '',
          imageUrl: '',
          description: descriptions[index],
          wikiUrl: urls[index],
        ),
      );
    } else {
      throw Exception('Failed to search plants');
    }
  }

  static Future<Plant> getPlantDetails(Plant plant) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?action=parse&page=${plant.name}&prop=text|images&format=json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String htmlContent = data['parse']['text']['*'];
      final document = parse(htmlContent);

      // Extract scientific name
      final scientificNameElement = document.querySelector('i');
      final scientificName = scientificNameElement?.text ?? '';

      // Extract description
      final paragraphs = document.querySelectorAll('p');
      String description = '';
      for (var p in paragraphs) {
        if (p.text.trim().isNotEmpty) {
          description = p.text.trim();
          break;
        }
      }

      // Extract image URL
      String imageUrl = '';
      if (data['parse']['images'].isNotEmpty) {
        final imageName = data['parse']['images'][0];
        final imageResponse = await http.get(Uri.parse(
            '$baseUrl?action=query&titles=File:$imageName&prop=imageinfo&iiprop=url&format=json'));
        if (imageResponse.statusCode == 200) {
          final imageData = json.decode(imageResponse.body);
          final pages = imageData['query']['pages'];
          imageUrl = pages[pages.keys.first]['imageinfo'][0]['url'];
        }
      }

      return Plant(
        id: plant.id,
        name: plant.name,
        scientificName: scientificName,
        imageUrl: imageUrl,
        description: description,
        wikiUrl: plant.wikiUrl,
      );
    } else {
      throw Exception('Failed to get plant details');
    }
  }
}

