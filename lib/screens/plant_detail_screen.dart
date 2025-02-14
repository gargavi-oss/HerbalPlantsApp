import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/plant.dart';
import '../services/wikipedia_service.dart';

class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({Key? key}) : super(key: key);

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late Future<Plant> _plantDetailsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final plant = ModalRoute.of(context)!.settings.arguments as Plant;
    _plantDetailsFuture = WikipediaService.getPlantDetails(plant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Plant>(
        future: _plantDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final plant = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(plant.name),
                    background: plant.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: plant.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                        : const Icon(Icons.image, size: 100),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (plant.scientificName.isNotEmpty)
                          Text(
                            plant.scientificName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Description:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(plant.description),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Open the Wikipedia page in a web view or external browser
                          },
                          child: const Text('View Full Wikipedia Article'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

