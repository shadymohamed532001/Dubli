import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/chat/logic/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatHistoryBody extends StatefulWidget {
  const ChatHistoryBody({super.key});

  @override
  State<ChatHistoryBody> createState() => _ChatHistoryBodyState();
}

class _ChatHistoryBodyState extends State<ChatHistoryBody> {
  @override
  void initState() {
    context.read<ChatCubit>().getChatss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is GetChatsDataLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorManager.darkyellowColor,
            ),
          );
        } else if (state is GetChatsDataSuccessState) {
          if (state.chats.isEmpty || state.chats[0].messages.isEmpty) {
            return Center(
              child: Text(
                "No chat history available.",
                style: AppStyle.font22Whiteregular,
              ),
            );
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.chats[0].messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE5E5E5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.chats[0].messages[index].user,
                                            style: AppStyle.font14Primarysemibold,
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${DateTime.now().day.toString().padLeft(2, '0')} ${_getMonth(DateTime.now().month)} ${DateTime.now().year}',
                                            style: AppStyle.font14blackmedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        state.chats[0].messages[index].assistant,
                                        style: AppStyle.font14blackmedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        } else if (state is GetChatsDataErrorState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Chat history not established.",
                  style: AppStyle.font22Whiteregular,
                ),
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorManager.darkGreyColor,
            ),
          );
        }
      },
    );
  }
}

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}
