import 'dart:math';

import 'package:connectivity_checker/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum QRCodeState { loading, cached, generated }

class QRCodeNotfifier extends StateNotifier<QRCodeState> {
  String? _currentCode;
  final ConnectivityState _connectivityState;
  final SharedPreferences _sharedPreferences;
  QRCodeNotfifier(
      QRCodeState state, this._connectivityState, this._sharedPreferences)
      : super(state) {
    debugPrint(
        'QRCode notifier constructor: connectivityState = $_connectivityState ');
    _init();
  }

  /// This init method run each time the QRCode notifier is created - as it it watching ConnectivityProvider this will be each time that state changes
  Future<void> _init() async {
    // attempt to get a new code and cache it as we have a internet connection
    if (_connectivityState == ConnectivityState.connected) {
      debugPrint('Getting new code from remote source');
      _currentCode = await _generateCode();
      _sharedPreferences.setString("qrcode", _currentCode!);
      state = QRCodeState.generated;
    }

    // attempt to use the cached code as their is no internet connection
    if (_connectivityState == ConnectivityState.notConnected) {
      debugPrint(
          'no internet connection so attempting to extract the last stored code');
      _currentCode = _sharedPreferences.getString("qrcode");
      state = QRCodeState.cached;
    }
  }

  /// Return a code if there is one or a blank
  String get codeValue {
    return _currentCode ?? '';
  }

  /// This is just used as a faux code generate simulating a network call if we have connectivity
  /// if it fails and we have a cached code it will use that otherwise it will throw an Exception
  Future<String> _generateCode() async {
    String newCode = await _fauxCodeGenerator();
    return newCode;
  }

  /// This is just used as a faux code generator simulating a network call if we have connectivity
  /// This could also be in its own FutureProvider (like the Shared Prefs)
  Future<String> _fauxCodeGenerator() async {
    await Future.delayed(const Duration(seconds: 2));
    final code = Random().nextInt(900000) + 100000;
    return code.toString();
  }
}

/// This is our QRCode Provider it tracks the latest network connectivity and uses the sharedPreferencesProvider to store data locally
final qrcodeProvider =
    StateNotifierProvider<QRCodeNotfifier, QRCodeState>((ref) {
  final connectivityState = ref.watch(connectivityProvider);
  final sharedPrefs = ref.read(sharedPreferencesProvider);
  return QRCodeNotfifier(
      QRCodeState.loading, connectivityState, sharedPrefs.value!);
});
