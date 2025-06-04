import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': text});
    });

    _controller.clear();

    final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    final apiKey = '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';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': 'llama3-8b-8192',
      'messages': [
        {
          'role': 'system',
          'content':
              'Kamu adalah chatbot khusus Damkar wilayah Jember yang menangani kebakaran dan beberapa hal yaitu penyelamatan, penanggulangan bencana, hewan buas dan masalah dalam kehidupan sehari hari. Jika pertanyaannya tidak berhubungan dengan pemadam kebakaran, tolak untuk menjawab dan beri tahu bahwa kamu hanya menjawab pertanyaan seputar damkar. Kantor Damkar berada di Jl. Danau Toba No.16, Lingkungan Panji, Tegalgede, Kec. Sumbersari, Jember. Selalu jawab dengan menyebutkan lokasi ini jika ada yang bertanya tentang lokasi Damkar.'
        },
        {'role': 'user', 'content': text},
      ],
      'temperature': 0.7
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final answer = responseData['choices'][0]['message']['content'];

        setState(() {
          _messages.add({'sender': 'masyarakat', 'message': answer});
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'masyarakat',
            'message': 'Terjadi kesalahan. Coba lagi nanti.'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
            {'sender': 'masyarakat', 'message': 'Gagal menghubungi server.'});
      });
    }
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.redAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg['message'] ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanya Damkar'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.redAccent),
                    onPressed: _sendMessage,
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
