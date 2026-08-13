import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grocery_item.dart';
import '../models/cooking_note.dart';

/// Both phones share one household document so lists/notes sync between
/// you two with no per-user setup. Change this if you ever want to
/// separate households.
const String householdId = 'default_household';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _groceryItems => _db
      .collection('households')
      .doc(householdId)
      .collection('grocery_items');

  CollectionReference<Map<String, dynamic>> get _cookingNotes => _db
      .collection('households')
      .doc(householdId)
      .collection('cooking_notes');

  Stream<List<GroceryItem>> watchGroceryItems() {
    return _groceryItems.orderBy('createdAt', descending: true).snapshots().map(
      (snap) => snap.docs
          .map((d) => GroceryItem.fromMap(d.id, d.data()))
          .toList(),
    );
  }

  Future<void> addGroceryItem(GroceryItem item) {
    return _groceryItems.doc(item.id).set(item.toMap());
  }

  Future<void> setGroceryItemChecked(String id, bool isChecked) {
    return _groceryItems.doc(id).update({'isChecked': isChecked});
  }

  Future<void> removeGroceryItem(String id) {
    return _groceryItems.doc(id).delete();
  }

  Stream<List<CookingNote>> watchCookingNotes() {
    return _cookingNotes.orderBy('createdAt', descending: true).snapshots().map(
      (snap) =>
          snap.docs.map((d) => CookingNote.fromMap(d.id, d.data())).toList(),
    );
  }

  Future<void> addCookingNote(CookingNote note) {
    return _cookingNotes.doc(note.id).set(note.toMap());
  }

  Future<void> removeCookingNote(String id) {
    return _cookingNotes.doc(id).delete();
  }
}
