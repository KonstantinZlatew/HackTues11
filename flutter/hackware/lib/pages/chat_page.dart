import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:8765'),  
  );

  List<Map<String, String>> messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String input = _controller.text.trim();

      setState(() {
        messages.add({"sender": "User", "message": input});
        messages.add({"sender": "AI", "message": "••• AI is typing..."}); 
        _controller.clear();
      });

      _sendMockedResponse(input);  
    }
  }

  void _sendMockedResponse(String input) {
    String mockedResponse;

    switch (input.toLowerCase()) {
      case "corn":
        mockedResponse = """
          Corn (Zea mays) is a warm-season plant that requires plenty of sunlight and well-drained soil.
          - Temperature: 21-29°C
          - Humidity: 60-80%
          - pH: 5.8-7.0
          - Watering: Needs regular watering, especially in the growing season
          - EC: 1.5-2.5 dS/m
        """;
        break;
      case "cactus":
        mockedResponse = """
          Cactus (Cactaceae) are desert plants that thrive in dry conditions and intense sunlight.
          - Temperature: 18-30°C (can tolerate higher temperatures)
          - Humidity: Very low (less than 30%)
          - pH: 6.0-7.0
          - Watering: Very little water required, only when the soil is dry
          - EC: 0.5-1.0 dS/m
        """;
        break;
      case "benjamin":
        mockedResponse = """
          Benjamin Fig (Ficus benjamina) is a tropical plant that prefers indirect light and moderate watering.
          - Temperature: 20-30°C
          - Humidity: 50-70%
          - pH: 6.0-7.5
          - Watering: Regular watering, but allow soil to dry between waterings
          - EC: 1.0-1.5 dS/m
        """;
        break;
      default:
        mockedResponse = "Sorry, I don't have information on that plant.";
    }

   
    setState(() {
      messages.removeWhere((msg) => msg["message"] == "••• AI is typing...");
      messages.add({"sender": "AI", "message": mockedResponse});
    });
  }

  @override
  void initState() {
    super.initState();

    
    channel.stream.listen((message) {
      final response = json.decode(message);
      setState(() {
        messages.add({"sender": "AI", "message": response["ai_response"]});
      });
    }, onError: (error) {
      print("Error: $error");
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            width: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text("Chat with AI",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["sender"] == "User"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg["sender"] == "User"
                          ? Colors.green[200]
                          : msg["message"] == "••• AI is typing..."
                              ? Colors.grey[100]
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["message"] ?? "",
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        hintText: "Enter a plant (corn, cactus, benjamin)",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
