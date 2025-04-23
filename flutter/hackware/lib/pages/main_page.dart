import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WebSocketChannel channel;
  Map<String, dynamic>? sensorData;
  String? aiSuggestion;

  @override
  void initState() {
    super.initState();

    
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8765'),
    );

    channel.stream.listen((message) {
      final decoded = json.decode(message);
      setState(() {
        if (decoded is Map && decoded.containsKey("ai_suggestion")) {
          aiSuggestion = decoded["ai_suggestion"];
        } else {
          sensorData = decoded;
        }
      });
    }, onError: (error) {
      print("WebSocket error: $error");
    });
  }

  void requestAISuggestion() {
    channel.sink.add("GET_AI_SUGGESTION");
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Widget buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? "N/A",
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 82, 89, 87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF64DD17)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "🌱 Soil Sensor Readings",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 2,
                offset: Offset(1, 1),
                color: Colors.black45,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 151, 224, 158), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: sensorData == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        color: Colors.green[50], 
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRow("Humidity", sensorData!["humidity"]),
                              buildRow("EC", sensorData!["Electrical Conductivity (EC)"]),
                              buildRow("PH", sensorData!["pH Level"]),
                              buildRow("Nitrogen", sensorData!["Nitrogen (N)"]),
                              buildRow("Phosphorous", sensorData!["Phosphorus (P)"]),
                              buildRow("Potassium", sensorData!["Potassium (K)"]),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 20),

                        Center(
                          child: ElevatedButton.icon(
                            onPressed: requestAISuggestion,
                            icon: const Icon(Icons.lightbulb_outline),
                            label: const Text("💡 Get AI Suggestion"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                      if (aiSuggestion != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "AI Suggestion:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                aiSuggestion!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "• Important Conditions:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "• Watering: Regular, especially in the growing season\n"
                                "• Temperature: Ideal range: 21-29°C\n"
                                "• Humidity: Keep it above 60%",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
