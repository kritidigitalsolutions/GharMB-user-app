import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthResult {
  final String token;
  final String? email;
  final String? name;
  final String? photoUrl;

  GoogleAuthResult({required this.token, this.email, this.name, this.photoUrl});
}

class GoogleSignInService {
  // Web Client ID (client_type: 3) from google-services.json
  static const String _serverClientId =
      '9610363754-dlcdkprvbdho73cqj7acj3i6a8vk93fe.apps.googleusercontent.com';

  static GoogleSignIn? _googleSignIn;

  static GoogleSignIn get _instance {
    _googleSignIn ??= GoogleSignIn(
      serverClientId: _serverClientId,
      scopes: ['email', 'profile'],
    );
    return _googleSignIn!;
  }

  /// Performs Google Sign-In and returns authentication details
  static Future<GoogleAuthResult?> signIn() async {
    try {
      debugPrint('🔵 [GoogleSignInService] Starting signIn()...');
      debugPrint('🔵 [GoogleSignInService] serverClientId: $_serverClientId');

      // Sign out first to force account picker to show every time
      try {
        await _instance.signOut();
        debugPrint('🟡 [GoogleSignInService] Previous session cleared');
      } catch (e) {
        debugPrint('🟡 [GoogleSignInService] No previous session: $e');
      }

      debugPrint('🔵 [GoogleSignInService] Showing account picker...');
      final GoogleSignInAccount? account = await _instance.signIn();

      if (account == null) {
        debugPrint('🟡 [GoogleSignInService] User cancelled account picker');
        return null;
      }

      debugPrint('🟢 [GoogleSignInService] Account selected: ${account.email}');
      debugPrint('🟢 [GoogleSignInService] Name: ${account.displayName}');

      debugPrint('🔵 [GoogleSignInService] Fetching authentication tokens...');
      final GoogleSignInAuthentication auth = await account.authentication;
      final String idToken = auth.idToken ?? '';

      debugPrint(
        '🟢 [GoogleSignInService] idToken: ${idToken.isNotEmpty ? "Received (length: ${idToken.length})" : "EMPTY/NULL"}',
      );

      if (idToken.isEmpty) {
        debugPrint(
          '❌ [GoogleSignInService] idToken is EMPTY! Check Web Client ID in Firebase Console.',
        );
        throw Exception(
          'Google ID Token not received. Ensure Web Client ID is correct.',
        );
      }

      return GoogleAuthResult(
        token: idToken,
        email: account.email,
        name: account.displayName,
        photoUrl: account.photoUrl,
      );
    } catch (e, stack) {
      debugPrint('🔴 [GoogleSignInService] Exception during signIn(): $e');
      debugPrint('🔴 [GoogleSignInService] StackTrace: $stack');
      rethrow;
    }
  }

  /// Signs out of Google account
  static Future<void> signOut() async {
    try {
      await _instance.signOut();
      debugPrint('🟢 [GoogleSignInService] Signed out successfully');
    } catch (e) {
      debugPrint('🔴 [GoogleSignInService] Sign-Out Error: $e');
    }
  }
}
