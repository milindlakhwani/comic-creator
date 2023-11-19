import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:comic_creator/core/globals/my_colors.dart';
import 'package:comic_creator/core/globals/my_fonts.dart';
import 'package:comic_creator/core/globals/size_config.dart';
import 'package:comic_creator/core/utils.dart';
import 'package:comic_creator/features/home/controller/editor_controller.dart';
import 'package:comic_creator/features/home/controller/home_controller.dart';
import 'package:comic_creator/features/home/widgets/save_dialog.dart';
import 'package:comic_creator/features/home/widgets/promt_form.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Funtion to add a new blank image
  bool insertBlankImage(WidgetRef ref) {
    if (ref.read(homeControllerProvider).length == 10) {
      showToast("Max 10 panels allowed");
      return false;
    }
    final homeController = ref.read(homeControllerProvider.notifier);
    homeController.insertImage();
    return true;
  }

  // Funtion to scroll to the top of editor
  void scrollToBottom(WidgetRef ref) {
    final editorController = ref.read(editorControllerProvider.notifier);
    editorController.scrollToBottom();
  }

  // Funtion to scroll to bottom of page on adding new image
  void scrollToTop(WidgetRef ref) {
    final editorController = ref.read(editorControllerProvider.notifier);
    editorController.scrollToTop();
  }

  // Funtion to show dialog box for saving
  void initiateSave(WidgetRef ref, BuildContext context) async {
    final comicFrames = ref.watch(homeControllerProvider);
    int totalCount = comicFrames.length;
    if (totalCount <= 0) {
      showToast("Please generate images.");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomDialogBox();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initializing Sizeconfig class
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "StoryCanvas - Comic Creator",
          style: MyFonts.medium.setColor(textColor.withOpacity(0.8)).size(
                SizeConfig.textScaleFactor * 20,
              ),
        ),
        titleSpacing: SizeConfig.horizontalBlockSize * 2,
        shadowColor: kWhite.withOpacity(0.5),
        elevation: 3,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.verticalBlockSize * 1,
                horizontal: SizeConfig.horizontalBlockSize * 4),
            child: GlowButton(
              width: SizeConfig.horizontalBlockSize * 15,
              onPressed: () => initiateSave(ref, context),
              color: buttonColorBlue,
              child: Text(
                'Save and Export',
                style: MyFonts.bold.setColor(textColor).size(
                      SizeConfig.horizontalBlockSize * 1.2,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizeConfig.screenWidth > 600
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: SizeConfig.horizontalBlockSize * 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlowButton(
                          onPressed: () => scrollToTop(ref),
                          padding: const EdgeInsets.all(0),
                          width: SizeConfig.horizontalBlockSize * 3.5,
                          height: SizeConfig.verticalBlockSize * 6.5,
                          color: buttonColorDark,
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: iconColor,
                            size: SizeConfig.horizontalBlockSize * 2,
                          ),
                        ),
                        GlowButton(
                          borderRadius: BorderRadius.circular(10),
                          onPressed: () => scrollToBottom(ref),
                          padding: const EdgeInsets.all(0),
                          width: SizeConfig.horizontalBlockSize * 3.5,
                          height: SizeConfig.verticalBlockSize * 6.5,
                          color: buttonColorDark,
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: iconColor,
                            size: SizeConfig.horizontalBlockSize * 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.horizontalBlockSize * 60,
                    child: ref.read(editorControllerProvider),
                  ),
                  SizedBox(
                    width: SizeConfig.horizontalBlockSize * 5,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ElevatedButton(
                        onPressed: () {
                          scrollToBottom(ref);
                          bool flag = insertBlankImage(ref);
                          if (flag) scrollToBottom(ref);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColorDark,
                          shape: const CircleBorder(),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              SizeConfig.horizontalBlockSize * 0.8),
                          child: Icon(
                            Icons.add,
                            color: kWhite,
                            size: (SizeConfig.horizontalBlockSize * 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.horizontalBlockSize * 25,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.horizontalBlockSize),
                      child: PromptForm(),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: SizeConfig.verticalBlockSize * 25,
                    child: PromptForm(),
                  ),
                  SizedBox(
                    height: SizeConfig.verticalBlockSize * 55,
                    child: ref.read(editorControllerProvider),
                  ),
                ],
              ),
      ),
      floatingActionButton: SizeConfig.screenWidth < 600
          ? FloatingActionButton(
              onPressed: () {
                scrollToBottom(ref);
                bool flag = insertBlankImage(ref);
                if (flag) scrollToBottom(ref);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
