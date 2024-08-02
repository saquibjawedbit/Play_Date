import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';

class InBoxController extends GetxController {
  var contacts = [].obs;
  List<ContactModel> totalContacts = [];

  bool rebuilding = false;

  Stream<List<ContactModel>> fetchContacts() {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final snap = FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .collection('contacts')
        .orderBy('lastMessageTime')
        .limit(10)
        .snapshots();

    final data = snap.map((doc) {
      final val = doc.docs.map((data) {
        final val = ContactModel.fromJson(data.data(), id: data.id);
        totalContacts.add(val);
        return val;
      }).toList();
      contacts.value = val;
      totalContacts = val;
      return val;
    });
    return data;
  }

  void search(String query) {
    if (query == "" || query.isBlank!) {
      contacts.value = totalContacts.toList();
    } else {
      contacts.value = totalContacts
          .where((value) => (value.name.toLowerCase() == query.toLowerCase()))
          .toList();
    }
  }

  void fetchOldContacts({required lastDocument}) {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final snap = FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .collection('contacts')
        .orderBy('lastMessageTime')
        .limit(20)
        .startAfter(lastDocument)
        .snapshots();

    snap.map((doc) {
      return doc.docs.map((data) {
        totalContacts.add(ContactModel.fromJson(data.data(), id: data.id));
      }).toList();
    });
    contacts.addAll(totalContacts);
  }
}
