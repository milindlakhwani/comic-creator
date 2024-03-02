import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:comic_creator/home/controller/home_controller.dart';
import 'package:comic_creator/home/widgets/comic_frame.dart';

// Defining the provider whose state is a consumer widget
final editorControllerProvider =
    StateNotifierProvider<EditorController, ConsumerWidget>(
  (ref) => EditorController(),
);

class EditorController extends StateNotifier<ConsumerWidget> {
  EditorController() : super(const ComicStrip());
  ConsumerWidget get getState => state;

  // Scrolling functions
  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }
}

// Initializing the controller
final ScrollController _scrollController = ScrollController();

// Consumer widget containing all coming frames, takes the items from home controller and creates a dynamic list of ComicFrame Widget
class ComicStrip extends ConsumerWidget {
  const ComicStrip({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comicFrames = ref.watch(homeControllerProvider);
    return ListView.builder(
      controller: _scrollController,
      itemCount: comicFrames.length,
      itemBuilder: (BuildContext context, int index) {
        return ComicFrame(panel: comicFrames[index], index: index);
      },
    );
  }
}
