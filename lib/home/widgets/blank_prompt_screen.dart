import 'package:flutter/material.dart';

import 'package:comic_creator/core/globals/my_fonts.dart';
import 'package:comic_creator/core/globals/size_config.dart';

class BlankPromptScreen extends StatelessWidget {
  const BlankPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Select a frame to begin editing!",
        style: MyFonts.light.setColor(Colors.white).letterSpace(0.9).size(
            SizeConfig.screenWidth > 900 || SizeConfig.screenWidth < 600
                ? SizeConfig.textScaleFactor * 15
                : SizeConfig.textScaleFactor * 10),
      ),
    );
  }
}
