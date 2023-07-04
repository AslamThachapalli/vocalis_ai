import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vocalis_ai/domain/prompt/i_prompt_repo.dart';
import 'package:vocalis_ai/domain/prompt/prompt.dart';
import 'package:vocalis_ai/domain/prompt/prompt_failures.dart' as failure;
import 'package:vocalis_ai/domain/prompt/response.dart';

part 'prompt_bloc.freezed.dart';
part 'prompt_event.dart';
part 'prompt_state.dart';

const String networkErrorMessage = "network error";
const String serverErrorMessage = "server error";

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  final IPromptRepo _promptRepo;

  PromptBloc(this._promptRepo) : super(const PromptState.initial()) {
    on<Prompted>((event, emit) async {
      emit(const Fetching());

      final typeResponse =
          await _promptRepo.identifyPrompt(prompt: Prompt(query: event.query));

      typeResponse.fold(
        (failure) => _mapFailures(failure, emit),
        (type) {
          late final Either<failure.PromptFailure, Response> promptResponse;

          type.map(
            text: (_) async {
              promptResponse = await _promptRepo.promptForText(
                  prompt: Prompt(query: event.query));
            },
            image: (_) async {
              promptResponse = await _promptRepo.promptForImage(
                  prompt: Prompt(query: event.query));
            },
          );

          promptResponse.fold(
            (failure) => _mapFailures(failure, emit),
            (response) {
              if (response.textResponse.isNotEmpty) {
                emit(TextResponse(content: response.textResponse));
              } else if (response.imageUrl.isNotEmpty) {
                emit(ImageResponse(imageUrl: response.imageUrl));
              }
            },
          );
        },
      );
    });
  }

  _mapFailures(failure.PromptFailure failure, Emitter<PromptState> emit) {
    failure.map(
      networkError: (_) =>
          emit(const PromptFailure(message: networkErrorMessage)),
      serverError: (_) =>
          emit(const PromptFailure(message: serverErrorMessage)),
    );
  }
}
