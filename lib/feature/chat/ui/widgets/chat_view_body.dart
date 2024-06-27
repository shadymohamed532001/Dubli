import 'package:dubli/feature/chat/ui/widgets/add_event_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/chat/logic/cubit/chat_cubit.dart';
import 'package:dubli/feature/chat/ui/widgets/chat_text_filed.dart';
import 'package:dubli/feature/chat/ui/widgets/messages_widget.dart';
import 'package:dubli/feature/chat/ui/widgets/add_task_bottom_sheet.dart'; // Import the AddTaskBottomSheet widget

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        ChatCubit cubit = BlocProvider.of<ChatCubit>(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Dupli Chat Bot'),
            leading: GestureDetector(
              onTap: () {
                context.navigateTo(routeName: Routes.chatHistoryViewsRoute);
              },
              child: const Icon(Icons.history),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.messages.length,
                      itemBuilder: (context, index) {
                        var message = cubit.messages[index];
                        return MessagesWidget(
                          sender: message['sender'],
                          message: message['message'],
                          timestamp: message['timestamp'],
                        );
                      },
                    ),
                  ),
                  if (state is SendUserMassMessageLoading)
                    const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 30.0,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ChatTextFiled(
                            controller: cubit.chatController,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: ColorManager.darkyellowColor,
                          ),
                          onPressed: () {
                            if (cubit.chatController.text.isNotEmpty) {
                              String userMessage = cubit.chatController.text.toLowerCase();
                              bool containsTaskKeyword = userMessage.contains('tasks') ||
                                  userMessage.contains('make a task') ||
                                  userMessage.contains('generate task') ||
                                  userMessage.contains('task');
                              bool containsEventKeyword = userMessage.contains('event') ||
                                  userMessage.contains('create event') ||
                                  userMessage.contains('schedule event');

                              if (!containsTaskKeyword && !containsEventKeyword) {
                                cubit.sendMessage(userMessage);
                              }
                              
                              cubit.chatController.clear();

                              if (containsTaskKeyword) {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AddTaskBottomSheet();
                                  },
                                );
                              } else if (containsEventKeyword) {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AddEventBottomSheet();
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (cubit.suggestionQuestions.isNotEmpty)
                Positioned(
                  bottom: 65,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: cubit.suggestionQuestions.map((question) {
                        return GestureDetector(
                          onTap: () {
                            cubit.sendMessage(question);
                            cubit.suggestionQuestions = [];
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
                              style: const TextStyle(
                                color: ColorManager.whiteColor,
                              ),
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
      },
    );
  }
}
