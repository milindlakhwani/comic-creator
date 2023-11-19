import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import 'package:comic_creator/core/globals/my_colors.dart';
import 'package:comic_creator/core/globals/my_fonts.dart';
import 'package:comic_creator/core/globals/my_spaces.dart';
import 'package:comic_creator/core/globals/size_config.dart';
import 'package:comic_creator/core/utils.dart';
import 'package:comic_creator/features/home/controller/home_controller.dart';
import 'package:comic_creator/features/home/controller/save_controller.dart';

class CustomDialogBox extends ConsumerStatefulWidget {
  const CustomDialogBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomDialogBoxState();
}

class _CustomDialogBoxState extends ConsumerState<CustomDialogBox> {
  late int _size, _rows, _cols;
  final _formKey = GlobalKey<FormState>();

  // initializing different controllers for different fields
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController rowsController = TextEditingController();
  final TextEditingController colsController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController dimController = TextEditingController();

  // save the form and return any validation error
  bool saveForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    _formKey.currentState!.save();
    return true;
  }

  // Starts downloading the image
  void downloadImage() async {
    if (!saveForm()) return;

    final saveHandler = ref.read(saveController);
    await saveHandler.downloadImage(
      screenshotController,
      context,
      _rows,
      _cols,
      _size.toDouble(),
    );
  }

  // Generalised widgett having text field and the corresponding form field
  Widget formInput(String text, TextFormField txtField, {bool small = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            "$text : ",
            style: MyFonts.bold
                .setColor(textColor)
                .size(SizeConfig.horizontalBlockSize * (small ? 0.9 : 1.15)),
          ),
          MySpaces.hGapInBetween,
          Expanded(
            flex: 1,
            child: SizedBox(
              height: SizeConfig.verticalBlockSize * 5,
              child: txtField,
            ),
          ),
        ],
      ),
    );
  }

  // Initially set the defaults size to 512
  @override
  void initState() {
    sizeController.text = "512";
    super.initState();
  }

  // Function that generates dimensions of the output image based on the size of image, cols and rows
  String getDimensions(int totalLen) {
    int? size = int.tryParse(sizeController.text);
    int? col = int.tryParse(colsController.text);
    int? row = int.tryParse(rowsController.text);
    // If anything is not defined, retuns empty
    if (size == null ||
        col == null ||
        row == null ||
        col > totalLen ||
        row > totalLen) return "";

    // width of all the images + margins and padding by images + margins of page + border size
    int width = ((size * col) +
            (4 * col * (size / (SizeConfig.horizontalBlockSize * 4))) +
            2 * (size / (SizeConfig.horizontalBlockSize * 4)) +
            3 * 2 * col)
        .toInt();
    // length of all the images + margins and padding by images + margins of page + border size
    int height = ((size * row) +
            (4 * row * (size / (SizeConfig.verticalBlockSize * 6))) +
            2 * (size / (SizeConfig.verticalBlockSize * 6)) +
            3 * 2 * row)
        .toInt();

    return "$width x $height";
  }

  @override
  Widget build(BuildContext context) {
    final totalLen = ref.read(homeControllerProvider).length;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.horizontalBlockSize * 2,
              vertical: SizeConfig.verticalBlockSize * 4,
            ),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.horizontalBlockSize),
              child: SizedBox(
                width: SizeConfig.horizontalBlockSize * 20,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Total Frames : $totalLen",
                          style: MyFonts.medium
                              .setColor(textColor)
                              .size(SizeConfig.horizontalBlockSize * 1.15),
                        ),
                      ),
                      MySpaces.vSmallestGapInBetween,
                      formInput(
                        "Image Size (px)",
                        TextFormField(
                          controller: sizeController,
                          onSaved: (val) {
                            _size = int.parse(val!);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Size cannot be Empty";
                            }
                            if (int.tryParse(value) == null) {
                              return "Enter a number";
                            }

                            return null;
                          },
                          onChanged: (val) {
                            dimController.text = getDimensions(totalLen);
                          },
                          // initialValue: "512",
                          decoration: textboxDecoration("Enter size of image"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: formInput(
                              "Rows",
                              TextFormField(
                                controller: rowsController,
                                validator: (val) {
                                  if (val == null) {
                                    showToast("Rows cannot be empty");
                                    return "";
                                  }
                                  if (int.tryParse(val) == null) {
                                    showToast("Enter a number for rows");
                                    return "";
                                  }
                                  if (int.parse(val) == 0) {
                                    showToast("Rows cannot be 0");
                                    return "";
                                  }
                                  if (int.parse(val) > totalLen) {
                                    showToast("Rows cannot exceed frames");
                                    return "";
                                  }

                                  return null;
                                },
                                onSaved: (val) {
                                  _rows = int.parse(val!);
                                },
                                onChanged: (val) {
                                  int? r = int.tryParse(val);
                                  if (r != null) {
                                    if (totalLen % r == 0) {
                                      colsController.text = ("${totalLen / r}");
                                    } else {
                                      colsController.text =
                                          ("${(totalLen ~/ r) + 1}");
                                    }
                                  }
                                  dimController.text = getDimensions(totalLen);
                                },
                                decoration: textboxDecoration(
                                  "",
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: formInput(
                              "Cols",
                              TextFormField(
                                controller: colsController,
                                validator: (val) {
                                  if (val == null) {
                                    showToast("Columns cannot be empty");
                                    return "";
                                  }
                                  if (int.tryParse(val) == null) {
                                    showToast("Enter a number for columns");
                                    return "";
                                  }
                                  if (int.parse(val) == 0) {
                                    showToast("Columns cannot be 0");
                                    return "";
                                  }
                                  if (int.parse(val) > totalLen) {
                                    showToast("Cols cannot exceed frames");
                                    return "";
                                  }

                                  return null;
                                },
                                onSaved: (val) {
                                  _cols = int.parse(val!);
                                },
                                onChanged: (val) {
                                  int? c = int.tryParse(val);
                                  if (c != null) {
                                    if (totalLen % c == 0) {
                                      rowsController.text = ("${totalLen / c}");
                                    } else {
                                      rowsController.text =
                                          ("${(totalLen ~/ c) + 1}");
                                    }
                                    dimController.text =
                                        getDimensions(totalLen);
                                  }
                                },
                                decoration: textboxDecoration(
                                  "",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      MySpaces.vGapInBetween,
                      formInput(
                        "Image Dimensions(px)",
                        TextFormField(
                          controller: dimController,
                          enabled: false,
                        ),
                        small: true,
                      ),
                      MySpaces.vGapInBetween,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: downloadImage,
                          child: Text(
                            "Generate",
                            style: MyFonts.medium.setColor(textColor).size(17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
