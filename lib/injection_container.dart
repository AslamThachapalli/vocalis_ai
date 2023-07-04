import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:vocalis_ai/application/prompt/prompt_bloc.dart';
import 'package:vocalis_ai/domain/prompt/i_prompt_repo.dart';
import 'package:vocalis_ai/infrastructure/prompt/prompt_repository.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerFactory(() => PromptBloc(getIt()));

  getIt.registerLazySingleton<IPromptRepo>(() => PromptRepository(getIt()));

  getIt.registerLazySingleton(() => http.Client());
}
