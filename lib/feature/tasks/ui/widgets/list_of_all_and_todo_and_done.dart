import 'package:dupli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ListOfAllAndTodoAndDone extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ListOfAllAndTodoAndDone({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () {
                    onTap(index);
                  },
                  child: Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? ColorManager.darkyellowColor
                          : ColorManager.darkGreyColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        ['All', 'Todo', 'Done'][index],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
        ],
      ),
    );
  }
}
