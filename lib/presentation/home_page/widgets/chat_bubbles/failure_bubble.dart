import 'package:flutter/material.dart';
import 'package:vocalis_ai/presentation/core/constants/colors.dart';

class FailureBubble extends StatelessWidget {
  final String failure;
  const FailureBubble({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8, right: 20),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                border: Border.all(color: AppColors.errorColor)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.errorColor,
                ),
                const SizedBox(width: 4),
                Text(
                  failure,
                  style: const TextStyle(
                    color: AppColors.errorColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
