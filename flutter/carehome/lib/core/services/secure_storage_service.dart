import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Single source of truth for all secure data:
/// access token, saved credentials, biometric preference.
class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── Keys ──────────────────────────────────────────────────────────────────
  static const _keyToken = 'access_token';
  static const _keyEmail = 'saved_email';
  static const _keyPassword = 'saved_password';
  static const _keyBiometricEnabled = 'biometric_enabled';

  // ── Token ─────────────────────────────────────────────────────────────────
  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<void> deleteToken() => _storage.delete(key: _keyToken);

  Future<bool> hasToken() async => (await getToken()) != null;

  // ── Credentials  (kept for biometric silent re-login) ─────────────────────
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
  }

  Future<String?> getSavedEmail() => _storage.read(key: _keyEmail);

  Future<String?> getSavedPassword() => _storage.read(key: _keyPassword);

  // ── Biometric preference ───────────────────────────────────────────────────
  Future<void> setBiometricEnabled(bool val) =>
      _storage.write(key: _keyBiometricEnabled, value: val.toString());

  Future<bool> isBiometricEnabled() async =>
      (await _storage.read(key: _keyBiometricEnabled)) == 'true';

  // ── Full clear on logout ───────────────────────────────────────────────────
  /// Clears everything — call on logout.
  Future<void> clearSession() => _storage.deleteAll();
}
