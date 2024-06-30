import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'plant.dart';
import 'registration_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Plant> plants = [Plant(name: 'Daisy')];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadPlants();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        for (var plant in plants) {
          if (plant.waterLevel > 0) {
            plant.waterLevel -= 10; // Уменьшение уровня воды на 10% каждые 10 секунд
          } else {
            plant.isAlive = false;
          }
        }
        _savePlants();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _waterPlant(Plant plant) {
    setState(() {
      plant.waterLevel = 100;
      plant.isAlive = true;
      _savePlants();
    });
  }

  Future<void> _savePlants() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> plantJson = plants.map((plant) => jsonEncode(plant.toJson())).toList();
    await prefs.setStringList('plants', plantJson);
  }

  Future<void> _loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? plantJson = prefs.getStringList('plants');
    if (plantJson != null) {
      setState(() {
        plants = plantJson.map((plant) {
          final Map<String, dynamic> plantMap = jsonDecode(plant);
          return Plant.fromJson(plantMap);
        }).toList();
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlantNanny'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return ListTile(
            title: Text(plant.name),
            subtitle: Text('Water Level: ${plant.waterLevel}%'),
            trailing: plant.isAlive
                ? IconButton(
                    icon: Icon(Icons.local_drink),
                    onPressed: () => _waterPlant(plant),
                  )
                : Text('Dead', style: TextStyle(color: Colors.red)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            plants.add(Plant(name: 'New Plant'));
            _savePlants();
          });
        },
      ),
    );
  }
}
