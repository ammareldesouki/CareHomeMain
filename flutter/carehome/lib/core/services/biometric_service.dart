import 'package:local_auth/local_auth.dart';

/// Wraps local_auth — biometric availability check + authentication.
class BiometricService {
  BiometricService._();

  static final BiometricService instance = BiometricService._();

  final _auth = LocalAuthentication();

  /// True if the device supports biometrics AND has enrolled biometrics.
  Future<bool> isAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  /// Returns 'Face ID' (iOS), 'Fingerprint' (Android), or 'Biometrics'.
  Future<String> getBiometricLabel() async {
    final list = await _auth.getAvailableBiometrics();
    if (list.contains(BiometricType.face)) return 'Face ID';
    if (list.contains(BiometricType.fingerprint)) return 'Fingerprint';
    return 'Biometrics';
  }

  /// Triggers the OS biometric prompt.
  /// Returns true on success, false on failure / cancellation.
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
