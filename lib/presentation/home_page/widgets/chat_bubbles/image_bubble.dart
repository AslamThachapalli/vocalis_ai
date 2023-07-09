import 'package:flutter/material.dart';
import 'package:vocalis_ai/presentation/core/constants/colors.dart';

class ImageBubble extends StatelessWidget {
  final String imageUrl;
  const ImageBubble(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        child: Image.network(
          imageUrl,
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 300,
              height: 300,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: AppColors.accentColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
