import 'package:flutter/material.dart';
import '../models/plant.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plant = ModalRoute.of(context)!.settings.arguments as Plant;

    return Scaffold(
      appBar: AppBar(
        title: Text('${plant.name} Distribution'),
      ),
      body: const Center(
        child: Text('Map view will be implemented here'),
      ),
    );
  }
}

