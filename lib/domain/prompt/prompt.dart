import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt.freezed.dart';

@freezed
class Prompt with _$Prompt {
  const factory Prompt({required String query}) = _Prompt;
}
