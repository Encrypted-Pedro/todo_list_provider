import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<User?> register(String email, String password);
  Future<User?> loogin(String email, String password);
  Future<void> forgotPassword(String email);
  Future<User?> googleLogin();
  Future<User?> logout();
  Future<void> updateDisplayName(String name);
}
