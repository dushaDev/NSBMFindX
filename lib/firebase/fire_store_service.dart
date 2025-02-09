import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_x/random.dart';

class FireStoreService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Random _random = Random();
  Future<void> register(String email, String name) async {
    List<String> words = _random.splitName(name);
    await _fireStore.collection('users').doc(email).set({
      'name': name,
      'dn': words[0],
      'email': email,
      'dp': _random.randomDp(name),
    });
    await _fireStore.collection('todos').doc(email).set({'version_id01': 1});
  }

  Future<void> setMovies(
    String email,
    List imdbIdList,
    List typeList,
    List nameList,
    List dateList,
    List releaseList,
    List imgList,
    List statusList,
  ) async {
    for (int i = 0; i < imdbIdList.length; i++) {
      await _fireStore
          .collection('todos')
          .doc(email)
          .collection('movies')
          .doc(imdbIdList[i])
          .set({
        'id': imdbIdList[i],
        'type': typeList[i],
        'name': nameList[i],
        'img': imgList[i],
        'releaseDate': releaseList[i],
        'listedDate': dateList[i],
        'watchStatus': statusList[i],
      });
    }
  }

  Future<void> setVersion(
      String email, String versionId, int versionCode) async {
    await _fireStore.collection('todos').doc(email).set({
      versionId: versionCode,
    });
  }

  // Get all documents from a collection
  Future<List<Map<String, dynamic>>> getDocuments(
      String col1, String email, String col2) async {
    final collectionRef =
        _fireStore.collection(col1).doc(email).collection(col2);
    final snapshot = await collectionRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocuments2(
      String col1, String email) {
    return _fireStore.collection(col1).doc(email).get();
  }

  Future<List<String>> getDocumentNames(
      String col1, String email, String col2) async {
    final collectionRef =
        _fireStore.collection(col1).doc(email).collection(col2);
    final snapshot = await collectionRef.get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> deleteCollection(String col1, String email, String col2) async {
    final collection =
        FirebaseFirestore.instance.collection(col1).doc(email).collection(col2);
    // Get all documents in the collection
    final snapshot = await collection.get();
    // Loop through and delete each document
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
