part of 'prompt_bloc.dart';

@freezed
class PromptEvent with _$PromptEvent {
  const factory PromptEvent.prompted({required String query}) = Prompted;
}
