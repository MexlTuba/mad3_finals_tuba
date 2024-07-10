import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("journalEntries")
        .doc(journalEntryId);

    final doc = await docRef.get();
    if (!doc.exists) {
      throw Exception("Journal entry $journalEntryId does not exist.");
    }

    final journalData = doc.data();
    if (journalData == null) {
      throw Exception("No data found for journal entry $journalEntryId.");
    }

    // Get the list of image URLs from the journal entry
    final List<dynamic> imageUrls = journalData['images'] ?? [];

    // Delete each image from Firebase Storage
    for (final imageUrl in imageUrls) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();
      } catch (e) {
        // Handle any errors during deletion
        print("Failed to delete image $imageUrl: $e");
      }
    }

    // Delete the journal entry document from Firestore
    await docRef.delete();
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
