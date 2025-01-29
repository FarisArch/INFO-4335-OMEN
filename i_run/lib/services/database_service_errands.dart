import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServiceErrand {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String ERRANDS_COLLECTION_REF = 'errands';

  late final CollectionReference<Map<String, dynamic>> _errandsRef;

  DatabaseServiceErrand() {
    _errandsRef = _firestore.collection(ERRANDS_COLLECTION_REF);
  }

  /// Retrieves all errands from Firestore
  Future<List<Map<String, dynamic>>> getAllErrands() async {
    try {
      final querySnapshot = await _errandsRef.get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error retrieving errands: $e');
      throw Exception('Error retrieving errands: $e');
    }
  }

  /// Retrieves errands assigned to a specific person
  Future<List<Map<String, dynamic>>> getErrandsByAssignee(String assignee) async {
    try {
      final querySnapshot = await _errandsRef.where('assigned', isEqualTo: assignee).get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error retrieving errands for $assignee: $e');
      throw Exception('Error retrieving errands for $assignee: $e');
    }
  }
}
