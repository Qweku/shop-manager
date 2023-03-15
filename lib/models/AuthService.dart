import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_manager/models/UserModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(user.uid, user.email, user.displayName);
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(credential.user);
  }

  Future<UserModel?> createUserWithEmailAndPassword(String displayName,
      String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
        await credential.user!.updateDisplayName(displayName);
    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
