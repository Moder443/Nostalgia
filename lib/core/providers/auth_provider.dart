import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simplified auth state - no authentication needed
class AuthState {
  const AuthState();
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
