import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/plant_detail_screen.dart';

void main() {
  runApp(const HerbalPlantsApp());
}

class HerbalPlantsApp extends StatelessWidget {
  const HerbalPlantsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herbal Plants Encyclopedia',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
      routes: {
        '/plant_detail': (context) => const PlantDetailScreen(),
      },
    );
  }
}

