import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:comic_creator/core/providers/api_provider.dart';
import 'package:comic_creator/core/utils.dart';
import 'package:comic_creator/home/controller/home_controller.dart';

final promptController = StateNotifierProvider<PromptController, bool>(
  (ref) {
    final api = ref.read(apiProvider);
    final homeController = ref.read(homeControllerProvider.notifier);
    return PromptController(
        apiProvider: api, homeControllerProvider: homeController, ref: ref);
  },
);

// Provider whose state is the index of current frame selected for editing
final promptViewEnabled = StateProvider<int>((ref) => -1);

// provider for prompt input, has function to call api.
// State of this provider is a boolean which is set true when api is being called
class PromptController extends StateNotifier<bool> {
  final ApiProvider _apiProvider;
  final HomeController _homeControllerProvider;
  final Ref _ref;
  PromptController({
    required ApiProvider apiProvider,
    required HomeController homeControllerProvider,
    required Ref ref,
  })  : _apiProvider = apiProvider,
        _homeControllerProvider = homeControllerProvider,
        _ref = ref,
        super(false);

  // Checks the response for failure and success
  void genImageFromQuery(String query, String speechText) async {
    state = true;
    final res = await _apiProvider.getImageFromPrompt(query);
    res.fold((l) => showToast(l.message), (r) {
      _homeControllerProvider.updateImage(
          r, _ref.read(promptViewEnabled), query, speechText);
    });
    state = false;
  }
}
