part of 'prompt_bloc.dart';

@freezed
class PromptState with _$PromptState {
  const factory PromptState.initial() = Initial;
  const factory PromptState.fetching() = Fetching;
  const factory PromptState.textResponse({required String content}) =
      TextResponse;
  const factory PromptState.imageResponse({required String imageUrl}) =
      ImageResponse;
  const factory PromptState.promptFailure({required String message}) =
      PromptFailure;
}
