import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/networking/api_services.dart';
import 'package:dubli/core/networking/end_boint.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/chat/data/models/chat_model.dart';
import 'package:dubli/feature/chat/ui/widgets/add_task_bottom_sheet.dart';
import 'package:dubli/feature/chat/ui/widgets/chat_text_filed.dart';
import 'package:dubli/feature/chat/ui/widgets/messages_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  String formatTimestamp(DateTime timestamp) {
    return DateFormat.jm().format(timestamp);
  }

  Future<String> sendMessage(String message) async {
    try {
      var timestamp = DateTime.now();

      setState(() {
        messages.add({
          "sender": "user",
          "message": message,
          "timestamp": formatTimestamp(timestamp)
        });
      });

      if (message.toLowerCase().contains('tasks') ||
          message.toLowerCase().contains('task') ||
          message.toLowerCase().contains('taski') ||
          message.toLowerCase().contains('i want to make task') ||
          message.toLowerCase().contains('make to me task')) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return AddTaskBottomSheet(
              onTaskAdded: (task) {
               
              },
            );
          },
        );
        return 'Task bottom sheet shown';
      }

      var response = await ApiServices.postData(
        endpoint: chatendpoint,
        data: {
          'message': message,
          'user_id': '3',
        },
      );

      var data = ChatbotResponse.fromJson(response);
      timestamp = DateTime.now();
      setState(() {
        messages.add({
          "sender": "bot",
          "message": data.message,
          "timestamp": formatTimestamp(timestamp)
        });
      });

      return data.message;
    } catch (e) {
      return 'Error: Failed to send message';
    }
  }

  List<String> suggestionQuestions = [
    "How can I help you today?",
    "What are your operating hours?",
    "Do you provide support for product X?",
    "Can I return a product I bought?",
    "How can I track my order?",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dupli Chat Bot'),
        leading: GestureDetector(
            onTap: () {
              context.navigateTo(routeName: Routes.chatHistoryViewsRoute);
            },
            child: const Icon(Icons.history)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return MessagesWidget(
                      sender: message['sender'],
                      message: message['message'],
                      timestamp: message['timestamp'],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ChatTextFiled(
                        controller: _controller,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: ColorManager.darkyellowColor,
                      ),
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (suggestionQuestions.isNotEmpty)
            Positioned(
              bottom: 65, // Adjust based on your input field height
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: suggestionQuestions.map((question) {
                    return GestureDetector(
                      onTap: () {
                        sendMessage(question);
                        suggestionQuestions = [];
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: ColorManager.darkyellowColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          question,
                          style:
                              const TextStyle(color: ColorManager.whiteColor),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
