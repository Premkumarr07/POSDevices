import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../constants/firestore_paths.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository({
    required FirebaseAuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService;

  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.asyncMap((user) async {
      if (user == null) return null;
      try {
        final doc = await _firestoreService.getDocument(
          FirestorePaths.userDoc(user.uid),
        );
        if (doc.exists) {
          return UserModel.fromFirestore(doc);
        }
      } catch (e) {
        print('Error getting user data: $e');
      }
      return null;
    });
  }

  bool get isLoggedIn => _authService.isLoggedIn;
  String? get currentUserId => _authService.currentUserId;

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String venueId,
  }) async {
    final credential = await _authService.signUp(
      email: email,
      password: password,
    );

    final user = UserModel(
      id: credential.user.uid,
      name: name,
      email: email,
      role: 'manager',
      venueId: venueId,
      active: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestoreService.setDocument(
      FirestorePaths.userDoc(user.id),
      user.toFirestore(),
    );

    return user;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signIn(
      email: email,
      password: password,
    );

    final doc = await _firestoreService.getDocument(
      FirestorePaths.userDoc(credential.user.uid),
    );

    return UserModel.fromFirestore(doc);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    if (_authService.currentUserId == null) return null;

    try {
      final doc = await _firestoreService.getDocument(
        FirestorePaths.userDoc(_authService.currentUserId!),
      );

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting current user: $e');
    }

    return null;
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String role,
  }) async {
    await _firestoreService.updateDocument(
      FirestorePaths.userDoc(userId),
      {
        'name': name,
        'role': role,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }
}
