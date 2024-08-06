import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_client/db_client.dart';
import 'package:hive/hive.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';
import 'package:play_dates/Utlis/Models/result_model.dart';
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

  Future<void> saveLastSessionTime(String userId) async {
    final now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .set({'lastSeen': now}, SetOptions(merge: true));
    changeActiveSession(userId, false);
  }

  Future<void> changeActiveSession(String userId, bool isActive) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .set({'isOnline': isActive}, SetOptions(merge: true));
  }

  Future<List<QuizModel>> fetch({required DateTime startTime}) async {
    try {
      final categoriesData = await dbClient.fetchOnly(
        collection: 'contest',
        field: 'startTime',
        startTime: Timestamp.fromDate(
          startTime,
        ),
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
      throw Exception('Failed to fetch the contest data $err');
    }
  }

  Future<UserModel?> fetchUser({required String id}) async {
    try {
      final categoriesData = await dbClient.fetchById(
        collection: 'user',
        id: id,
      );
      final categories = UserModel.fromJson(
        id: categoriesData.id,
        categoriesData.data,
      );
      return categories;
    } catch (err) {
      return null;
      //throw Exception('Failed to fetch the user $err');
    }
  }

  Future<QuizModel?> fetchQuizDate({required String id}) async {
    try {
      final categoriesData = await dbClient.fetchById(
        collection: 'contest',
        id: id,
      );
      final categories = QuizModel.fromJson(
        id: categoriesData.id,
        categoriesData.data,
      );
      return categories;
    } catch (err) {
      throw Exception('Failed to fetch the user $err');
    }
  }

  Stream<ResultModel> fetchPlayers({
    required String id,
    required String clgName,
    required String round,
  }) {
    try {
      return FirebaseFirestore.instance
          .collection('contest')
          .doc(id)
          .collection(round)
          .doc(clgName)
          .snapshots()
          .map((doc) =>
              ResultModel.fromJson(doc.data() as Map<String, dynamic>));
    } catch (err) {
      throw Exception('Failed to fetch the user $err');
    }
  }

  Stream<UserModel> getUserStream(String userId) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>));
  }

  Future<void> cacheContacts(List<ContactModel> contacts) async {
    var box = await Hive.openBox('contactsBox');
    await box.put(
        'contacts', contacts.map((contact) => contact.toMap()).toList());
  }

  Future<List<ContactModel>> getCachedContacts() async {
    var box = await Hive.openBox('contactsBox');
    List<Map<String, dynamic>> cachedContacts =
        box.get('contacts', defaultValue: []);
    return cachedContacts
        .map((contact) => ContactModel.fromJson(contact))
        .toList();
  }

  Future<void> createUser(
      String collection, Map<String, dynamic> data, String id) async {
    try {
      await dbClient.add(collection: collection, data: data, id: id);
    } catch (err) {
      throw Exception('Failed to create the categories $err');
    }
  }

  Future<void> addFriend(String collection, String id, String subCollection,
      String subId, Map<String, dynamic> data) async {
    try {
      await dbClient.addFriend(
          collection: collection,
          id: id,
          subCollection: subCollection,
          subId: subId,
          data: data);
    } catch (err) {
      throw Exception('Failed to create the categories $err');
    }
  }
}
