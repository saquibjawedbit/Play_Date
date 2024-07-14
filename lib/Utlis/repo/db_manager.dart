import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_client/db_client.dart';
import 'package:hive/hive.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';
import 'package:play_dates/Utlis/Models/participants_model.dart';
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

  Future<List<UserModel>> fetchUser({required String email}) async {
    try {
      final categoriesData = await dbClient.fetchOnly(
        collection: 'user',
        field: 'email',
        startTime: email,
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
      throw Exception('Failed to fetch the user $err');
    }
  }

  Future<List<ParticipantModel>> fetchPlayers({required String id}) async {
    try {
      final categoriesData = await dbClient.fetchPlayers(
        collection: 'contest',
        id: id,
        collection2: 'players',
      );
      final categories = categoriesData
          .map<ParticipantModel>(
            (categoryData) => ParticipantModel.fromJson(
              id: categoryData.id,
              categoryData.data,
            ),
          )
          .toList();
      return categories;
    } catch (err) {
      throw Exception('Failed to fetch the user $err');
    }
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

  Future<List<ContactModel>> fetchContacts({required String id}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .collection('contacts')
        .get();

    List<ContactModel> contacts = querySnapshot.docs.map(
      (doc) {
        return ContactModel.fromDocument(doc, doc.id);
      },
    ).toList();

    //cacheContacts(contacts);

    return contacts;
  }

  Future<void> createUser(
      String collection, Map<String, dynamic> data, String id) async {
    try {
      await dbClient.add(collection: collection, data: data, id: id);
    } catch (err) {
      throw Exception('Failed to create the categories $err');
    }
  }

  Future<void> createParticpant(String collection, String id,
      String nextCollection, Map<String, dynamic> data) async {
    try {
      await dbClient.addInCollection(
        collection: collection,
        id: id,
        nextCollection: nextCollection,
        data: data,
      );
    } catch (err) {
      throw Exception('Failed to create the categories $err');
    }
  }
}
