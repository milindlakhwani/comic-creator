import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_list/toggle_list.dart';

import 'package:comic_creator/core/globals/my_colors.dart';
import 'package:comic_creator/core/globals/my_fonts.dart';
import 'package:comic_creator/core/globals/my_spaces.dart';
import 'package:comic_creator/core/globals/size_config.dart';
import 'package:comic_creator/core/utils.dart';
import 'package:comic_creator/features/home/controller/prompt_controller.dart';
import 'package:comic_creator/features/home/widgets/blank_prompt_screen.dart';

// Widget that accepts prompt as input
class PromptForm extends ConsumerWidget {
  PromptForm({super.key});

  // Controllers for two inputs
  final queryTextController = TextEditingController();
  final speechTextController = TextEditingController();

  // Generalised toggle list item
  ToggleListItem toggleListItem({
    required BuildContext context,
    required String title,
    required int selectedTileValue,
    required Widget form,
  }) {
    return ToggleListItem(
      isInitiallyExpanded: true,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalBlockSize * 2,
          vertical: SizeConfig.verticalBlockSize * 1.5,
        ),
        child: Text(
          title,
          style: MyFonts.bold
              .setColor(iconColor)
              .size(SizeConfig.horizontalBlockSize * 1.2),
        ),
      ),
      divider: Divider(
        color: Theme.of(context).dividerColor,
        height: 1,
        thickness: 1,
      ),
      content: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalBlockSize * 2,
            vertical: SizeConfig.verticalBlockSize * 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(SizeConfig.horizontalBlockSize),
          ),
          color: Theme.of(context).canvasColor,
        ),
        child: selectedTileValue == -1 ? const BlankPromptScreen() : form,
      ),
      headerDecoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius:
            BorderRadius.all(Radius.circular(SizeConfig.horizontalBlockSize)),
      ),
      expandedHeaderDecoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConfig.horizontalBlockSize),
        ),
      ),
    );
  }

  // Clear the textbox and remove the focus, when the user is done editing
  void clearEntries(WidgetRef ref) {
    queryTextController.text = "";
    ref.read(promptViewEnabled.notifier).update((state) => -1);
  }

  // Button to mark editing done and clear entries
  Widget doneButton(WidgetRef ref) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        decoration: BoxDecoration(
          color: kBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          highlightColor: kBlue,
          onPressed: () => clearEntries(ref),
          icon: const Icon(
            Icons.done,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  // Initiate the image generation process, sends prompt to the api
  void genImage(WidgetRef ref) {
    String query = queryTextController.text;
    String speech = speechTextController.text;
    String prompt = query;
    bool flag = true;
    if (speech.isNotEmpty) {
      prompt += 'along with speech bubble having text $speech';
    }
    if (prompt.isEmpty) {
      showToast("Please enter text!");
      flag = false;
    }
    if (flag) ref.read(promptController.notifier).genImageFromQuery(prompt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(promptController);
    final promptViewController = ref.watch(promptViewEnabled);
    return ToggleList(
      toggleAnimationDuration: const Duration(milliseconds: 150),
      divider: const SizedBox(height: 10),
      scrollPosition: AutoScrollPosition.begin,
      trailing: Padding(
        padding: EdgeInsets.all(SizeConfig.horizontalBlockSize),
        child: const Icon(
          Icons.expand_more,
          color: kWhite,
        ),
      ),
      children: [
        toggleListItem(
          context: context,
          title: "Generate Image",
          selectedTileValue: promptViewController,
          form: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Frame : ${promptViewController + 1}",
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: MyFonts.bold
                          .setColor(textColor)
                          .size(SizeConfig.horizontalBlockSize * 1.2),
                    ),
                    doneButton(ref),
                  ],
                ),
                MySpaces.vGapInBetween,
                Text(
                  "Prompt",
                  style: MyFonts.bold
                      .setColor(textColor)
                      .size(SizeConfig.horizontalBlockSize * 0.7),
                ),
                MySpaces.vSmallestGapInBetween,
                SizedBox(
                  height: SizeConfig.verticalBlockSize * 5,
                  child: TextField(
                    controller: queryTextController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Describe the image you want to generate',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: iconColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: iconColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintStyle: MyFonts.light
                          .setColor(textColor.withOpacity(0.7))
                          .size(15),
                      fillColor: const Color.fromRGBO(39, 41, 45, 1),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    ),
                  ),
                ),
                MySpaces.vSmallGapInBetween,
                Text(
                  "Generative Speech Bubble (Experimental)",
                  style: MyFonts.bold
                      .setColor(textColor)
                      .size(SizeConfig.horizontalBlockSize * 0.8),
                ),
                MySpaces.vSmallestGapInBetween,
                SizedBox(
                  height: SizeConfig.verticalBlockSize * 5,
                  child: TextField(
                    controller: speechTextController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Add speech text',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: iconColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: iconColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintStyle: MyFonts.light
                          .setColor(textColor.withOpacity(0.8))
                          .size(15),
                      fillColor: const Color.fromRGBO(39, 41, 45, 1),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    ),
                  ),
                ),
                MySpaces.vSmallGapInBetween,
                SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(39, 41, 45, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () => genImage(ref),
                          child: Text(
                            "Generate",
                            style: MyFonts.light.setColor(textColor).size(17),
                          ),
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
