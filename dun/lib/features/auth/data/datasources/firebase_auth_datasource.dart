import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun/core/errors/exceptions.dart';
import 'package:dun/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dun/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource implements AuthRemoteDataSource {
  FirebaseAuthDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _fetchUser(firebaseUser.uid);
    });
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw const AuthException('Échec de l\'authentification anonyme.');
      }

      final existing = await _fetchUser(firebaseUser.uid);
      if (existing != null) return existing;

      final now = DateTime.now();
      final newUser = UserModel(
        id: firebaseUser.uid,
        createdAt: now,
        updatedAt: now,
      );

      await saveUser(newUser);
      return newUser;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return _fetchUser(firebaseUser.uid);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel?> _fetchUser(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
