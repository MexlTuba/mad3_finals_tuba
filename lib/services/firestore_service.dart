import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> storeUser(String email, String uid,
      {DateTime? signInTime}) async {
    return FirebaseFirestore.instance.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      if (signInTime != null) "lastSignIn": signInTime
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (!user.exists) {
      throw Exception("The user $uid does not exist in database");
    }
    return user.data();
  }

  // Add journal entry
  Future<void> addJournalEntry(
      String uid, Map<String, dynamic> journalData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("journalEntries")
        .add({
      ...journalData,
      "created_at": FieldValue.serverTimestamp(),
      "updated_at": FieldValue.serverTimestamp(),
    });
  }

  // Update journal entry
  Future<void> updateJournalEntry(String uid, String journalEntryId,
      Map<String, dynamic> journalData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("journalEntries")
        .doc(journalEntryId)
        .update({
      ...journalData,
      "updated_at": FieldValue.serverTimestamp(),
    });
  }

  // Delete journal entry
  Future<void> deleteJournalEntry(String uid, String journalEntryId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("journalEntries")
        .doc(journalEntryId)
        .delete();
  }

  // Get all journal entries for a user
  Future<List<Map<String, dynamic>>> getJournalEntries(String uid) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .collection("journalEntries")
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        ...doc.data(),
        'id': doc.id, // Include the document ID
      };
    }).toList();
  }

  // Get a single journal entry
  Future<Map<String, dynamic>> getJournalEntry(
      String uid, String journalEntryId) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .collection("journalEntries")
        .doc(journalEntryId)
        .get();
    if (!doc.exists) {
      throw Exception("Journal entry $journalEntryId does not exist.");
    }
    return doc.data()!;
  }
}
