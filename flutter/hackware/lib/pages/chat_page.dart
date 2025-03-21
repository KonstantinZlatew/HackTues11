import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = []; // Stores chat history

  final String webSocketUrl =
      'ws://192.168.100.106:8081'; //Home URL

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse(webSocketUrl));

    channel.stream.listen(
      (data) {
        setState(() {
          messages.add({"sender": "AI", "message": data});
        });
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket connection closed");
      },
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String vegetable = _controller.text.trim();

      // Send vegetable name to AI server
      channel.sink.add(jsonEncode({"vegetable": vegetable}));

      setState(() {
        messages.add({"sender": "User", "message": vegetable});
        _controller.clear();
      });
    }
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
          SizedBox(
            height: 15,
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
            child: Text("Chat with AI",
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
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg["sender"] == "User"
                          ? Colors.green[200]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["message"] ?? ""),
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        hintText: "Enter a vegetable...",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
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
