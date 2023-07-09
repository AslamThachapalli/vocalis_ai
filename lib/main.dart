import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocalis_ai/application/prompt/prompt_bloc.dart';
import 'package:vocalis_ai/injection_container.dart';
import 'package:vocalis_ai/presentation/home_page/home_page.dart';

void main() {
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PromptBloc>(),
      child: MaterialApp(
        title: 'Vocalis AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
