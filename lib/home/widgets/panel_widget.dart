// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:comic_creator/core/globals/my_colors.dart';
import 'package:comic_creator/core/globals/my_fonts.dart';
import 'package:comic_creator/core/globals/size_config.dart';
import 'package:comic_creator/core/models/panel.dart';

class PanelWidget extends StatelessWidget {
  final Panel panel;
  final double height;
  const PanelWidget({
    Key? key,
    required this.panel,
    this.height = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.memory(
          panel.image,
          width: SizeConfig.horizontalBlockSize * 29,
          height: height != 0 ? height : SizeConfig.verticalBlockSize * 60,
          fit: BoxFit.cover,
        ),
        if (panel.speechText.isNotEmpty)
          Positioned(
            bottom: 0,
            child: Container(
              width: SizeConfig.horizontalBlockSize * 29,
              color: kWhite,
              child: Text(
                panel.speechText,
                style: MyFonts.comic.setColor(kBlack),
                softWrap: true,
              ),
            ),
          ),
      ],
    );
  }
}
