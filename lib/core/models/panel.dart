// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Panel {
  String prompt;
  String speechText;
  Uint8List image;
  Panel({
    required this.prompt,
    required this.speechText,
    required this.image,
  });

  Panel copyWith({
    String? prompt,
    String? speechText,
    Uint8List? image,
  }) {
    return Panel(
      prompt: prompt ?? this.prompt,
      speechText: speechText ?? this.speechText,
      image: image ?? this.image,
    );
  }
}
