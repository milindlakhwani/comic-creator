import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:screenshot/screenshot.dart';

import 'package:comic_creator/core/failure.dart';
import 'package:comic_creator/core/globals/my_colors.dart';
import 'package:comic_creator/core/globals/size_config.dart';
import 'package:comic_creator/core/type_defs.dart';
import 'package:comic_creator/core/utils.dart';
import 'package:comic_creator/home/controller/home_controller.dart';

final saveController = Provider((ref) {
  return SaveController(ref: ref);
});

// Provider that has functions to generate the comic strip widget, convert it to image and then download it.
// generating widget and image functions are private
class SaveController {
  // taking ref to call other providers.
  final Ref _ref;
  SaveController({required Ref ref}) : _ref = ref;

  // Saves the image to the local memory
  Future<void> downloadImage(ScreenshotController screenshotController,
      BuildContext context, int rows, int cols, double height) async {
    final res =
        await _genImage(screenshotController, context, rows, cols, height);

    Uint8List? image;
    res.fold(
      (l) {
        showToast("Error downloading image. Please try again!");
        return;
      },
      (r) => image = r,
    );

    await WebImageDownloader.downloadImageFromUInt8List(
      uInt8List: image!,
      name: "Comic.png",
    );
  }

  // converts the widget to image
  FutureEither<Uint8List> _genImage(ScreenshotController screenshotController,
      BuildContext context, int rows, int cols, double height) async {
    try {
      final res = await screenshotController.captureFromLongWidget(
        InheritedTheme.captureAll(
          context,
          Material(
            color: kWhite,
            child: _genComicStrip(rows, cols, height),
          ),
        ),
        delay: const Duration(milliseconds: 100),
        context: context,
      );

      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // creates a comic strip grid
  // Since the screenshot package does not takes scrollable items, so a gridView is manually generated
  Widget _genComicStrip(int rows, int cols, double height) {
    final comicFrames = _ref.read(homeControllerProvider);
    int totalCnt = comicFrames.length;

    // common margins and padding,
    // When image height is reduced padding shifts correspondingly
    final EdgeInsets spaces = EdgeInsets.symmetric(
      vertical: height / (SizeConfig.verticalBlockSize * 6),
      horizontal: height / (SizeConfig.horizontalBlockSize * 4),
    );

    // Builder function that returns the grid type widget
    return Builder(builder: (context) {
      return Padding(
        padding: spaces,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < rows; i++)
                  Row(
                    children: [
                      for (int j = 0;
                          j < cols && (i * cols + j) < totalCnt;
                          j++)
                        Container(
                          margin: spaces,
                          padding: spaces,
                          height: height,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kBlack,
                              width: 3,
                            ),
                          ),
                          child: Image.memory(
                            comicFrames[(i * cols) + j],
                            fit: BoxFit.contain,
                            height: height,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
