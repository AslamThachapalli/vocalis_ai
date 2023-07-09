import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vocalis_ai/presentation/core/constants/colors.dart';
import 'package:vocalis_ai/presentation/home_page/widgets/chat_bubbles/bubble_triangle.dart';

class OutBubble extends StatelessWidget {
  final String message;
  final bool isListening;
  const OutBubble(this.message, {required this.isListening, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 8, left: 20),
            decoration: const BoxDecoration(
              color: AppColors.outBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            child: isListening
                ? const SizedBox(
                    width: 30,
                    child: SpinKitThreeBounce(
                      color: AppColors.textColor,
                      size: 20,
                    ),
                  )
                : Text(
                    message,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
        CustomPaint(
          painter: Triangle(
            backgroundColor: AppColors.outBubbleColor,
          ),
        )
      ],
    );
  }
}
