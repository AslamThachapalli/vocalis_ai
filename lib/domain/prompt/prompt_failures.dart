import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_failures.freezed.dart';

@freezed
class PromptFailure with _$PromptFailure {
  const factory PromptFailure.networkError() = _NetworkError;
  const factory PromptFailure.serverError() = _ServerError;
}
