import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  final _storage = const FlutterSecureStorage();

  /// Проверяет, есть ли активная сессия
  bool get isLoggedIn => _client.auth.currentSession != null;

  /// Регистрация
  Future<AuthResponse> signUp(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    if (response.session != null) {
      await _saveSession(response.session!);
    }
    return response;
  }

  /// Вход
  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.session != null) {
      await _saveSession(response.session!);
    }
    return response;
  }

  /// Выход
  Future<void> signOut() async {
    await _client.auth.signOut();
    await _storage.deleteAll();
  }

  /// Сохраняем сессию в защищённое хранилище
  Future<void> _saveSession(Session session) async {
    await _storage.write(key: 'access_token', value: session.accessToken);
    await _storage.write(key: 'refresh_token', value: session.refreshToken ?? '');
  }
}