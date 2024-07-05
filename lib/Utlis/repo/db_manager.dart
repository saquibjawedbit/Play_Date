import 'package:db_client/db_client.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';

class DbManager {
  final DbClient dbClient;

  const DbManager({required this.dbClient});

  Future<List<UserModel>> fetchCategories() async {
    try {
      final categoriesData = await dbClient.fetchAll(
        collection: 'users',
      );
      final categories = categoriesData
          .map<UserModel>(
            (categoryData) => UserModel.fromJson(
              id: categoryData.id,
              categoryData.data,
            ),
          )
          .toList();
      return categories;
    } catch (err) {
      throw Exception('Failed to fetch the categories $err');
    }
  }

  Future<List<QuizModel>> fetchQuizModel({required DateTime startTime}) async {
    try {
      final categoriesData = await dbClient.fetchOnly(
        collection: 'contest',
        startTime: startTime,
      );
      final categories = categoriesData
          .map<QuizModel>(
            (categoryData) => QuizModel.fromJson(
              id: categoryData.id,
              categoryData.data,
            ),
          )
          .toList();
      return categories;
    } catch (err) {
      throw Exception('Failed to fetch the categories $err');
    }
  }

  Future<void> createCategories(
      String collection, Map<String, dynamic> data) async {
    try {
      await dbClient.add(collection: collection, data: data);
    } catch (err) {
      throw Exception('Failed to create the categories $err');
    }
  }
}
