import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  Future adminLogin(String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: 'admin@halalapp.com', password: pass);
      User user = result.user;
      return user.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
