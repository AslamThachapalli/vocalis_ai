import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vocalis_ai/presentation/core/constants/colors.dart';
import 'package:vocalis_ai/presentation/home_page/widgets/chat_bubbles/bubble_triangle.dart';

class InBubble extends StatelessWidget {
  final String message;
  const InBubble(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            painter: Triangle(
              backgroundColor: AppColors.inBubbleColor,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 8, right: 20),
            decoration: const BoxDecoration(
              color: AppColors.inBubbleColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
