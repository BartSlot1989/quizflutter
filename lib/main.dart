import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:pubquiz/controllers/quiz/quiz_controller.dart';
import 'package:pubquiz/controllers/quiz/quiz_state.dart';
import 'package:pubquiz/enums/difficulty.dart';
import 'package:pubquiz/models/question_model.dart';
import 'package:pubquiz/models/failure_model.dart';
// import 'package:pubquiz/quiz_screen.dart';
import 'package:pubquiz/repositories/quiz_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
      title: 'Pubquiz i-aspect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: const QuizScreen(),
    ));
  }
}

final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
    (ref) => ref.watch(quizRepostitoryProvider).getQuestions(
          numQuestions: 10,
          categoryId: Random().nextInt(24) + 9,
          difficulty: Difficulty.any,
        ));

class QuizScreen extends HookWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizQuestions = useProvider(QuizQuestionsProvider);
    final pageController = usePageController();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0F0F0), Color(0xFFD9D9D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) => _buildBody(context, pageController, questions),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, _) => QuizError(
            message: error is Failure
                ? error.message
                : 'Oops, the beertap is not connected properly!',
          ),
        ),
      ),
    );
  }
}

class QuizError extends StatelessWidget {
  final String message;
  const QuizError({
    required Key key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        const SizedBox(height: 20.0),
        CustomButton(
          title: 'Opnieuw',
          onTap: () => context.refresh(quizRepostitoryProvider),
        ),
      ]),
    );
  }
}

class CustomButton extends StateLessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomButton({
    required Key key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.all(20.0),
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          )),
      child: Text(title),
      onPressed: onTap,
    );
  }
}
