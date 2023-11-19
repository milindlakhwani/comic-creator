import 'dart:typed_data';

import 'package:comic_creator/core/constants/image_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, List<Uint8List>>(
  (ref) => HomeController(),
);

// Home controller stores the images in a list and has functions to update the frames.
// State of this provider is a List of images as List<Uint8List>

class HomeController extends StateNotifier<List<Uint8List>> {
  // Initializing with a empty list
  HomeController() : super(List.empty(growable: true));

  List<Uint8List> get getState => state;

  void insertImage() {
    state = [...state, blankImage];
  }

  void updateImage(Uint8List image, int frameIndex) {
    List<Uint8List> updatedState = List.from(state);
    updatedState[frameIndex] = image;
    state = updatedState;
  }

  void deleteImage(int frameIndex) {
    List<Uint8List> updatedState = List.from(state);
    updatedState.removeAt(frameIndex);
    state = updatedState;
  }
}
