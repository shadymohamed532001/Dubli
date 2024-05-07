import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dubli/core/networking/api_services.dart';
import 'package:dubli/core/networking/end_boint.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/chat/data/models/chat_model.dart';
import 'package:dubli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final _user = ChatUser(id: '1', firstName: 'user-data');
  final _bot = ChatUser(
    id: '2',
    firstName: 'Dubli',
    profileImage: 'assets/images/logo.png',
  );
  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Dubli Ai Chat",
          style: TextStyle(
            color: ColorManager.whiteColor,
          ),
        ),
        backgroundColor: ColorManager.primaryColor,
        leading: IconButton(
          onPressed: () {
            BlocProvider.of<LayoutCubit>(context)
                .changeBottomNavToHome(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: DashChat(
        currentUser: _user,
        onSend: onSend,
        messages: messages,
        messageOptions: const MessageOptions(
          currentUserTextColor: ColorManager.whiteColor,
          currentUserContainerColor: ColorManager.darkyellowColor,
        ),
        inputOptions: InputOptions(
          inputTextStyle: const TextStyle(
            color: ColorManager.blackColor,
          ),
          sendButtonBuilder: (send) {
            return IconButton(
              onPressed: send,
              icon: const Icon(
                Icons.send,
                color: ColorManager.darkyellowColor,
              ),
            );
          },
        ),
      ),
    );
  }

  void onSend(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
    });

    List<Map<String, dynamic>> messagesHistory =
        messages.reversed.map((message) {
      if (message.user == _user) {
        return {'role': 'user', 'content': message.text};
      } else {
        return {'role': 'assistant', 'content': message.text};
      }
    }).toList();

    // Make request to generate response
    var response = await makeRequest(messagesHistory);

    // Update chat UI with response
    if (response != null) {
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            text: response,
            user: _bot,
            createdAt: DateTime.now(),
          ),
        );
      });
    }
  }

  Future<String?> makeRequest(
      List<Map<String, dynamic>> messagesHistory) async {
    try {
      List<String> texts = messagesHistory
          .map<String>((message) => message['content'].toString())
          .toList();

      String concatenatedText = texts.join(' ');

      var response = await ApiServices.postData(
        endpoint: chatendpoint,
        data: {'user_input': concatenatedText},
      );

      ChatbotResponse data = ChatbotResponse.fromJson(response);
      return data.message;
    } catch (e) {
      return e.toString();
    }
  }
}
