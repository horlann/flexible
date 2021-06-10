import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexible/authentification/models/user_data_model.dart';

class UsersDataRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<UserData>> getUsers() async {
    QuerySnapshot usersSnap = await _usersCollection.get();
    List usersList = usersSnap.docs
        .map((e) => UserData.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    return usersList as List<UserData>;
  }

  Future<UserData?> getUser(String uid) async {
    DocumentSnapshot documentSnapshot = await _usersCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      return UserData.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<bool> existsByPhone(String phone) async {
    QuerySnapshot documentSnapshot =
        await _usersCollection.where('phoneNumber', isEqualTo: phone).get();
    return documentSnapshot.docs.isNotEmpty;
  }

  setUser(UserData userData) async {
    print(userData);
    try {
      // yes
      await _usersCollection.doc(userData.uid).set(userData.onlyTextMap());

      // Prevent errors on large or corrupted data
      await _usersCollection.doc(userData.uid).update(userData.toMap());
    } catch (e) {
      print(e);
    }
  }
}
