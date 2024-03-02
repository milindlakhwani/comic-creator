import 'dart:convert';

import 'package:comic_creator/core/constants/api_constants.dart';
import 'package:comic_creator/core/failure.dart';
import 'package:comic_creator/core/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:comic_creator/core/type_defs.dart';
import 'package:fpdart/fpdart.dart';

// Getting instance of dio
final dioProvider = Provider((ref) => Dio());

final apiProvider = Provider((ref) => ApiProvider(dio: ref.read(dioProvider)));

class ApiProvider {
  final Dio _dio;
  ApiProvider({required Dio dio}) : _dio = dio;

  // If query is success then returns the image, else throws the error.
  FutureEither<Uint8List> getImageFromPrompt(String query) async {
    try {
      // final res = await _dio.post(
      //   ApiConstants.url,
      //   data: jsonEncode(<String, String>{
      //     'inputs': query,
      //   }),
      //   options: Options(
      //     headers: {
      //       'Accept': 'image/png',
      //       'Authorization': 'Bearer ${ApiConstants.key}',
      //     },
      //     contentType: 'application/json',
      //     responseType: ResponseType.bytes,
      //     receiveTimeout: const Duration(minutes: 5),
      //   ),
      // );
      // uint8 = Uint8List.fromList(res.data);

      Uint8List uint8;
      final res = await _dio.post(
        ApiConstants.url,
        data: jsonEncode(<String, String>{
          'inputs': query,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.key}',
          },
          contentType: 'application/json',
          responseType: ResponseType.bytes,
        ),
      );
      uint8 = Uint8List.fromList(res.data);

      return right(uint8);
    } on DioException catch (e) {
      if (e.response!.statusCode == 503) {
        showToast("Server Busy! Please try again after some time.");
      }
      return left(Failure(e.toString()));
    }
  }
}
