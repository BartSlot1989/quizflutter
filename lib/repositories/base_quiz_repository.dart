import 'package:iaspectquiz/models/question_model.dart';
import 'package:iaspectquiz/enums/difficulty.dart';

abstract class BaseQuizRepository {
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  });
}
