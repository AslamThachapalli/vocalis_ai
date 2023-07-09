import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vocalis_ai/application/prompt/prompt_bloc.dart';
import 'package:vocalis_ai/presentation/core/constants/colors.dart';
import 'package:vocalis_ai/presentation/home_page/widgets/chat_bubbles/failure_bubble.dart';
import 'package:vocalis_ai/presentation/home_page/widgets/chat_bubbles/image_bubble.dart';
import 'package:vocalis_ai/presentation/home_page/widgets/chat_bubbles/in_bubble.dart';
import 'package:vocalis_ai/presentation/home_page/widgets/chat_bubbles/out_bubble.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SpeechToText _speechToText;
  late final FlutterTts _flutterTts;

  String _lastWords = "";
  String _prevWords = "";

  @override
  void initState() {
    super.initState();

    _speechToText = SpeechToText();
    _initSpeech();

    _flutterTts = FlutterTts();
  }

  Future<void> _initSpeech() async {
    await _speechToText.initialize();
  }

  Future<void> _startListening() async {
    _flutterTts.stop();
    _lastWords = "";

    await _speechToText.listen(
      onResult: _onSpeechResult,
      partialResults: false,
      listenMode: ListenMode.dictation,
    );
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  Future<void> _startSpeak(String content) async {
    await _flutterTts.speak(content);
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  _searchQuery(BuildContext context, String query) {
    if (_lastWords.isNotEmpty) {
      BlocProvider.of<PromptBloc>(context).add(Prompted(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    _searchQuery(context, _lastWords);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.color1,
              expandedHeight: 280,
              toolbarHeight: 30,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.color1,
                  ),
                  child: Center(
                    child: Text(
                      "Vocalis AI",
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.75),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset("assets/images/chatbot.png"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
                child: Column(
                  children: [
                    const InBubble("Ask Me Anything !!!"),
                    if (_lastWords.isNotEmpty || _speechToText.isListening)
                      OutBubble(
                        _lastWords,
                        isListening: _speechToText.isListening,
                      ),
                    if (_lastWords.isNotEmpty && !_speechToText.isListening)
                      BlocBuilder<PromptBloc, PromptState>(
                        builder: (context, state) => state.maybeMap(
                          textResponse: (state) {
                            bool shouldSpeak = _prevWords != state.content;
                            _prevWords = state.content;
                            if (shouldSpeak) {
                              _startSpeak(state.content);
                            }
                            return InBubble(state.content);
                          },
                          imageResponse: (state) => ImageBubble(state.imageUrl),
                          promptFailure: (state) =>
                              FailureBubble(failure: state.message),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_speechToText.isListening) ...[
              const Text(
                "Listening...",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
            ],
            FloatingActionButton(
              onPressed: () async {
                if (await _speechToText.hasPermission &&
                    _speechToText.isNotListening) {
                  await _startListening();
                } else if (_speechToText.isListening) {
                  await _stopListening();
                } else {
                  _initSpeech();
                }
              },
              backgroundColor: AppColors.accentColor,
              child: BlocBuilder<PromptBloc, PromptState>(
                builder: (context, state) => state.maybeMap(
                  orElse: () => _speechToText.isListening
                      ? const Icon(Icons.stop)
                      : const Icon(Icons.mic),
                  fetching: (_) => const SpinKitSpinningLines(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
