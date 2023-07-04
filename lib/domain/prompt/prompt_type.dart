import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_type.freezed.dart';

@freezed
class PromptType with _$PromptType {
  const factory PromptType.text() = _Text;
  const factory PromptType.image() = _Image;
}
