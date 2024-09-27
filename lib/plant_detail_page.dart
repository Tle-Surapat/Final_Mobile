import 'package:flutter/material.dart';
import 'database_helper.dart';

class PlantDetailPage extends StatefulWidget {
  final int plantId;

  PlantDetailPage({required this.plantId});

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, dynamic>? _plantDetails;
  List<Map<String, dynamic>> _components = [];
  List<Map<String, dynamic>> _landUses = [];

  @override
  void initState() {
    super.initState();
    _fetchPlantDetails();
  }

  Future<void> _fetchPlantDetails() async {
    final plantDetails = await _dbHelper.getPlantById(widget.plantId);
    final components = await _dbHelper.getComponentsByPlantId(widget.plantId);
    final landUses = await _dbHelper.getLandUsesByPlantId(widget.plantId);

    setState(() {
      _plantDetails = plantDetails;
      _components = components;
      _landUses = landUses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_plantDetails?['plantName'] ?? 'Loading...'),
      ),
      body: _plantDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(_plantDetails!['plantImage']),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _plantDetails!['plantName'],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Scientific Name: ${_plantDetails!['plantScientific']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  _buildComponentsSection(),
                  _buildLandUseSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildComponentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Components:', style: TextStyle(fontSize: 20)),
        ),
        ..._components.map((component) {
          return ListTile(
            leading: Image.asset(component['componentIcon']),
            title: Text(component['componentName']),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLandUseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Land Uses:', style: TextStyle(fontSize: 20)),
        ),
        ..._landUses.map((use) {
          return ListTile(
            title: Text(use['LandUseTypeName']),
            subtitle: Text(use['LandUseDescription']),
          );
        }).toList(),
      ],
    );
  }
}
