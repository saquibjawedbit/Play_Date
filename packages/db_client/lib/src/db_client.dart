import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_client/src/db_record.dart';
import 'package:http/http.dart' as http;

class DbClient {
  final FirebaseFirestore _firestore;

  DbClient({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> add({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collection).add(data);
      return docRef.id;
    } catch (err) {
      throw Exception('Error adding document $err');
    }
  }

  Future<List<DbRecord>> fetchAll({
    required String collection,
  }) async {
    try {
      final colRef = _firestore.collection(collection);
      final documents = await colRef.get();
      return documents.docs
          .map(
            (doc) => DbRecord(
              id: doc.id,
              data: doc.data(),
            ),
          )
          .toList();
    } catch (err) {
      throw Exception('Error adding document $err');
    }
  }

  Future<List<DbRecord>> fetchOnly(
      {required String collection, required DateTime startTime}) async {
    try {
      final colRef = _firestore.collection(collection).where(
            'startTime',
            isEqualTo: Timestamp.fromDate(
              startTime,
            ),
          );
      final documents = await colRef.get();
      return documents.docs
          .map(
            (doc) => DbRecord(
              id: doc.id,
              data: doc.data(),
            ),
          )
          .toList();
    } catch (err) {
      throw Exception('Error adding document $err');
    }
  }

  Future<List<DbRecord>> fetchAllFromBundle<T>({
    required String collection,
    required String bundleUrl,
  }) async {
    final response = await http.get(Uri.parse('$bundleUrl/$collection'));
    final buffer = Uint8List.fromList(response.body.codeUnits);
    final task = _firestore.loadBundle(buffer);

    task.stream.listen((taskProgressState) {
      if (taskProgressState.taskState == LoadBundleTaskState.success) {
        // ignore: avoid_print
        print("Loaded Successfully");
      }
    });

    await task.stream.last;
    final querySnap = _firestore.collection(collection).get(
          const GetOptions(source: Source.cache),
        );

    return querySnap.then((querySnap) {
      return querySnap.docs
          .map(
            (doc) => DbRecord(
              id: doc.id,
              data: doc.data(),
            ),
          )
          .toList();
    });
  }
}
