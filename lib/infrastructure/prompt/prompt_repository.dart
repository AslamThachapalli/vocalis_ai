import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:vocalis_ai/domain/prompt/i_prompt_repo.dart';
import 'package:vocalis_ai/domain/prompt/prompt.dart';
import 'package:vocalis_ai/domain/prompt/prompt_failures.dart';
import 'package:vocalis_ai/domain/prompt/prompt_type.dart';
import 'package:vocalis_ai/domain/prompt/response.dart';
import 'package:vocalis_ai/infrastructure/core/api_key.dart';
import 'package:vocalis_ai/infrastructure/prompt/response_dto.dart';

class PromptRepository implements IPromptRepo {
  final http.Client _client;
  PromptRepository(this._client);

  final List<Map<String, String>> messages = [];

  @override
  Future<Either<PromptFailure, PromptType>> identifyPrompt(
      {required Prompt prompt}) async {
    try {
      final res = await _client.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content':
                  "Please indicate if the following prompt is intended for generating an image or text: Prompt: '${prompt.query}' "
                      "Reply with either 'image' or 'text' to specify the intended output.",
            }
          ],
        }),
      );

      if (res.statusCode == 200) {
        final typeResponse = ResponseDto.fromTextResponse(jsonDecode(res.body))
            .textResponse
            .toLowerCase();

        log(typeResponse, name: "Prompt type");
        if (typeResponse.contains('image')) {
          return right(const PromptType.image());
        } else {
          return right(const PromptType.text());
        }
      } else {
        log(res.body + res.statusCode.toString(), name: "Gpt error");
        return left(const PromptFailure.serverError());
      }
    } on SocketException catch (_) {
      return left(const PromptFailure.networkError());
    }
  }

  @override
  Future<Either<PromptFailure, Response>> promptForImage(
      {required Prompt prompt}) async {
    messages.add({
      'role': 'user',
      'content': prompt.query,
    });

    try {
      final res = await _client.post(
        Uri.parse("https://api.openai.com/v1/images/generations"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey"
        },
        body: jsonEncode({
          'prompt': prompt.query,
        }),
      );

      if (res.statusCode == 200) {
        final imageResponse =
            ResponseDto.fromImageResponse(jsonDecode(res.body)).toDomain();

        messages.add({
          'role': 'assistant',
          'content': imageResponse.imageUrl,
        });

        return right(imageResponse);
      } else {
        log(res.body + res.statusCode.toString(), name: "Dall-E error");
        return left(const PromptFailure.serverError());
      }
    } on SocketException catch (_) {
      return left(const PromptFailure.networkError());
    }
  }

  @override
  Future<Either<PromptFailure, Response>> promptForText(
      {required Prompt prompt}) async {
    messages.add({
      'role': 'user',
      'content': prompt.query,
    });

    try {
      final res = await _client.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        final textResponse =
            ResponseDto.fromTextResponse(jsonDecode(res.body)).toDomain();

        messages.add({
          'role': 'assistant',
          'content': textResponse.textResponse,
        });

        return right(textResponse);
      } else {
        log(res.body + res.statusCode.toString(), name: "Gpt error");
        return left(const PromptFailure.serverError());
      }
    } on SocketException catch (_) {
      return left(const PromptFailure.networkError());
    }
  }
}
