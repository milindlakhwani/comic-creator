import 'dart:typed_data';

import 'package:comic_creator/core/constants/image_constants.dart';
import 'package:comic_creator/core/models/panel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, List<Panel>>(
  (ref) => HomeController(),
);

// Home controller stores the images in a list and has functions to update the frames.
// State of this provider is a List of images as List<Uint8List>

class HomeController extends StateNotifier<List<Panel>> {
  // Initializing with a empty list
  HomeController() : super(List.empty(growable: true));

  List<Panel> get getState => state;

  int insertImage() {
    state = [...state, newPanel];
    return state.length;
  }

  void addPromtAndSpeech(String prompt, String speechText, int frameIndex) {
    List<Panel> updatedState = List.from(state);
    updatedState[frameIndex] = updatedState[frameIndex]
        .copyWith(prompt: prompt, speechText: speechText);
    state = updatedState;
  }

  void updateImage(
      Uint8List image, int frameIndex, String query, String speechText) {
    List<Panel> updatedState = List.from(state);
    updatedState[frameIndex] =
        Panel(prompt: query, speechText: speechText, image: image);
    state = updatedState;
  }

  void deleteImage(int frameIndex) {
    List<Panel> updatedState = List.from(state);
    updatedState.removeAt(frameIndex);
    state = updatedState;
  }
}
