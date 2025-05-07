import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.onSurface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildReceiverMessage("Hello John, How can I help you?", colorScheme),
                _buildSenderMessage("Sample message 1", colorScheme),
                _buildReceiverMessage("Sample message 2", colorScheme),
                _buildReceiverMessage("Sample message 3", colorScheme),
                _buildSenderMessage("Sample message 1", colorScheme),
                _buildReceiverMessage("Sample message 2", colorScheme),
                _buildReceiverMessage("Sample message 3", colorScheme),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      fillColor: colorScheme.surface,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Handle send
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderMessage(String message, ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReceiverMessage(String message, ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
