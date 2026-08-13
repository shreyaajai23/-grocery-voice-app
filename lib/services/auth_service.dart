import 'package:firebase_auth/firebase_auth.dart';

/// Signs in anonymously on app start. Since only the two of you use this
/// app, there's no login screen — both phones just get an anonymous
/// Firebase Auth session, which is enough to satisfy Firestore security
/// rules requiring `request.auth != null`. Both phones read/write the same
/// shared data via a fixed household ID (see FirestoreService), not the
/// anonymous UID.
class AuthService {
  Future<User> ensureSignedIn() async {
    final auth = FirebaseAuth.instance;
    final current = auth.currentUser;
    if (current != null) return current;
    final credential = await auth.signInAnonymously();
    return credential.user!;
  }
}
