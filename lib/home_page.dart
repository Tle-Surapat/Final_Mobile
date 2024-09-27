import 'package:flutter/material.dart';
import 'plant_detail_page.dart';
import 'database_helper.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _plants = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    await _dbHelper.initDatabase();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    final plants = await _dbHelper.getPlants();
    setState(() {
      _plants = plants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Database'),
      ),
      body: _plants.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _plants.length,
              itemBuilder: (context, index) {
                final plant = _plants[index];
                return ListTile(
                  leading: Image.asset(plant['plantImage']), // Display plant image
                  title: Text(plant['plantName']),
                  subtitle: Text(plant['plantScientific']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailPage(plantId: plant['plantID']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
