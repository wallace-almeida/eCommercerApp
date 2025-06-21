import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> signup({
    required String name,
    required String email,
    required String senha,
    required String role,
  }) async {
    try {
      final authResponse = await _supabase.auth.signUp(
        email: email.trim(),
        password: senha.trim(),
      );

      final userId = authResponse.user?.id;
      if (userId == null) {
        return 'Falha ao criar usuário.';
      }

      final insertResponse = await _supabase.from('users').insert({
        'id': userId,
        'name': name.trim(),
        'role': role,
        'email': email.trim(),
      });

      return null; // sucesso
    } on AuthException catch (e) {
      return e.message;
    } on PostgrestException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({required String email, required String senha}) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: senha.trim(),
      );

      final userId = authResponse.user?.id;
      if (userId == null) {
        return 'Falha no login.';
      }

      final data =
          await _supabase
              .from('users')
              .select('role')
              .eq('id', userId)
              .single();

      final role = data['role'] as String?;
      return role;
    } on AuthException catch (e) {
      return e.message;
    } on PostgrestException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
