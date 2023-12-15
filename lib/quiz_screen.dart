import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iaspectquiz/main.dart';
import 'package:iaspectquiz/repositories/quiz_repository.dart';

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
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) => _buildBody(context, pageController, questions),
          loading: () => const Center(child: CircularProgressIndicator()),
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
