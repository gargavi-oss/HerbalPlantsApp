import 'package:flutter/material.dart';
import '../widgets/plant_grid_item.dart';
import '../models/plant.dart';
import '../services/wikipedia_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Plant> _plants = [];
  bool _isLoading = false;
  String _searchQuery = '';

  Future<void> _searchPlants(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final plants = await WikipediaService.searchPlants(query);
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching plants: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herbal Plants Encyclopedia'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for herbal plants...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                if (value.length > 2) {
                  _searchPlants(value);
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _plants.isEmpty
                ? const Center(child: Text('No plants found'))
                : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _plants.length,
              itemBuilder: (context, index) {
                return PlantGridItem(plant: _plants[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

