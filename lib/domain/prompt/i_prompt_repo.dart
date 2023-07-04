import 'package:dartz/dartz.dart';
import 'package:vocalis_ai/domain/prompt/prompt.dart';
import 'package:vocalis_ai/domain/prompt/prompt_failures.dart';
import 'package:vocalis_ai/domain/prompt/prompt_type.dart';
import 'package:vocalis_ai/domain/prompt/response.dart';

abstract class IPromptRepo {
  Future<Either<PromptFailure, PromptType>> identifyPrompt(
      {required Prompt prompt});
  Future<Either<PromptFailure, Response>> promptForText(
      {required Prompt prompt});
  Future<Either<PromptFailure, Response>> promptForImage(
      {required Prompt prompt});
}
