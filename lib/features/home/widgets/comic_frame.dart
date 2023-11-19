import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:comic_creator/core/globals/my_colors.dart';

import 'package:comic_creator/core/globals/my_fonts.dart';
import 'package:comic_creator/core/globals/my_spaces.dart';
import 'package:comic_creator/core/utils.dart';
import 'package:comic_creator/features/home/controller/home_controller.dart';
import 'package:comic_creator/features/home/controller/prompt_controller.dart';

class ComicFrame extends ConsumerWidget {
  // Takes the image and the index to perform operations like edit and delete
  const ComicFrame({
    super.key,
    required this.image,
    required this.index,
  });
  final Uint8List image;
  final int index;

  // Function that opens the prompt screen for this frame
  void enablePromptScreen(WidgetRef ref) {
    // If a request is already being prrocessed return
    if (ref.read(promptController)) {
      showToast("Please wait for current process to finish");
      return;
    }
    ref.read(promptViewEnabled.notifier).update((state) => index);
  }

  // delete the frame
  void deleteImage(WidgetRef ref) {
    // Update the state of promptView, which shows the current opened frame.
    // This moves the focus of prompt screen to the frame just above it
    ref.read(promptViewEnabled.notifier).update((state) {
      if (state >= 0) {
        return ref.read(promptViewEnabled) - 1;
      } else {
        return state;
      }
    });
    ref.read(homeControllerProvider.notifier).deleteImage(index);
  }

  // Fitted box is used in places to add responsiveness, so that widgets scale themselves accordingly
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${index + 1}.",
              style: MyFonts.bold.size(20),
            ),
            MySpaces.hGapInBetween,
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: kWhite, borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  image,
                ),
              ),
            ),
            MySpaces.hGapInBetween,
            Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: buttonColorDark,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: iconColor,
                    ),
                    onPressed: () => enablePromptScreen(ref),
                  ),
                ),
                MySpaces.vGapInBetween,
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: kWhite,
                    ),
                    onPressed: () => deleteImage(ref),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
