import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  Map<String, dynamic>? sensorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
  }

  Future<void> _fetchSensorData() async {
    setState(() {
      isLoading = true;
    });

    if (!mounted) return;

    try {
      // Simulating data fetch from a local JSON file (or from an API)
      String _jsonStringPath =
          await rootBundle.loadString("assets/config/fake_data.json");
      Map<String, dynamic> data = jsonDecode(_jsonStringPath);

      await Future.delayed(Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        sensorData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching sensor data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : sensorData != null
              ? _buildDataTable()
              : Center(child: Text("No data available")),
    );
  }

  Widget _buildDataTable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          heightFactor: 2,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
              onPressed: _fetchSensorData,
              icon: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.refresh,
                  color: Colors.green,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 200,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text("Soil Sensor Data",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
        ),
        SizedBox(height: 50),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Table(
            children: [
              if (sensorData != null)
                _buildTableRow(
                    "Recommended Crop", sensorData!["Suggested Crop"]),
              if (sensorData != null)
                _buildTableRow("Nitrogen (N)", sensorData!["Nitrogen (N)"]),
              if (sensorData != null)
                _buildTableRow("Phosphorus (P)", sensorData!["Phosphorus (P)"]),
              if (sensorData != null)
                _buildTableRow("Potassium (K)", sensorData!["Potassium (K)"]),
              if (sensorData != null)
                _buildTableRow("pH Level", sensorData!["pH Level"]),
              if (sensorData != null)
                _buildTableRow("Electrical Conductivity \n(EC)",
                    sensorData!["Electrical Conductivity (EC)"]),
              if (sensorData != null)
                _buildTableRow("Temperature", sensorData!["temperature"]),
              if (sensorData != null)
                _buildTableRow("Humidity", sensorData!["humidity"]),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String key, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          key,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 50),
        child: Text(
          value,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
    ]);
  }
}
