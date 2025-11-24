import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../services/message_service.dart';
import '../../models/message.dart';

class ChatSupplierScreen extends StatefulWidget {
  const ChatSupplierScreen({super.key});

  @override
  State<ChatSupplierScreen> createState() => _ChatSupplierScreenState();
}

class _ChatSupplierScreenState extends State<ChatSupplierScreen> {
  final _messageController = TextEditingController();
  List<Message> _messages = [];
  String? _selectedConsumer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // TODO: Load list of consumers to chat with
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages(String consumerLogin) async {
    setState(() {
      _selectedConsumer = consumerLogin;
      _loading = true;
    });
    
    try {
      final app = context.read<AppState>();
      final messageService = MessageService(app.http);
      final supplierLogin = app.userLogin ?? '';
      
      final spec = GetMessage(
        consumerLogin: consumerLogin,
        supplierLogin: supplierLogin,
        loadingUser: supplierLogin,
      );
      
      final res = await messageService.loadMessages(spec);
      if (res.ok && res.data != null) {
        setState(() {
          _messages = res.data!;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _selectedConsumer == null) return;

    final app = context.read<AppState>();
    final messageService = MessageService(app.http);
    final supplierLogin = app.userLogin ?? '';

    final message = SendMessage(
      consumerLogin: _selectedConsumer!,
      supplierLogin: supplierLogin,
      senderLogin: supplierLogin,
      userMessage: _messageController.text.trim(),
    );

    final res = await messageService.sendMessage(message);
    if (res.ok) {
      _messageController.clear();
      _loadMessages(_selectedConsumer!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3722)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FreshMart Inc.',
              style: TextStyle(
                color: Color(0xFF4A3722),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Verified Consumer',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF768C4A),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Order banner
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order #SCP-12345',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3722),
                      ),
                    ),
                    const Text(
                      'Status: In Progress',
                      style: TextStyle(
                        color: Color(0xFF4A3722),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    foregroundColor: const Color(0xFF768C4A),
                  ),
                  child: const Text('View Order'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Today',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          // Messages
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final supplierLogin = context.read<AppState>().userLogin ?? '';
                      final isMe = message.senderLogin == supplierLogin;
                      return _buildMessageBubble(message, isMe);
                    },
                  ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF768C4A),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF768C4A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.userMessage,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF4A3722),
              ),
            ),
            if (isMe)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.done_all, size: 12, color: Colors.white70),
                    SizedBox(width: 4),
                    Text(
                      '10:32 AM',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

