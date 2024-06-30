import 'package:db_client/db_client.dart';
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
          .map<UserModel>((categoryData) => UserModel.fromJson(
                id: categoryData.id,
                categoryData.data,
              ))
          .toList();
      print("fetched");
      for (int i = 0; i < categories.length; i++) {
        print(categories[i].email);
      }
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
