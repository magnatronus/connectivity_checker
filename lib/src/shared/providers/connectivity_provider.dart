import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// what state the connection can exist
enum ConnectivityState { checking, connected, notConnected }

/// This notifier tracks the state of the last checked connection and provides
/// a function for checking the current state.
/// When the current state is checked any active listeners will be notified of the result.
class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  /// This is the host that is used to contact and confirm a network connection
  final String _host;

  /// This timeout in seconds will cause the Socket connection to fail after this time
  final int _timeout;

  // If there is an error this string will reflect the last error recorded
  String _error = '';

  ConnectivityNotifier(state,
      {String host = 'google.com', int timeoutSeconds = 1})
      : _host = host,
        _timeout = timeoutSeconds,
        super(state) {
    checkConnection;
  }

  /// Return any error that occured when checking connectivity
  String get error {
    return _error;
  }

  /// Here we do an address look up  and then attempt a socket connection
  /// The socket connection test is  NEEDED as the address look up could be cached and return a false positive
  Future<void> get checkConnection async {
    _error = '';
    state = ConnectivityState.checking;
    bool hasConnection = false;
    try {
      final result = await InternetAddress.lookup(_host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final socket = await Socket.connect(result[0].address, 80,
            timeout: Duration(seconds: _timeout));
        socket.destroy();
        hasConnection = true;
      }
      state = hasConnection
          ? ConnectivityState.connected
          : ConnectivityState.notConnected;
    } on SocketException catch (_) {
      _error = 'Connection SocketException';
      state = ConnectivityState.notConnected;
    } on TimeoutException catch (_) {
      _error = 'Connection TimeoutException';
      state = ConnectivityState.notConnected;
    } catch (_) {
      _error = "Connection Unknown Exception";
      state = ConnectivityState.notConnected;
    }
  }
}

/// This is our ConnectivityProvider, the assumption here is to assume no connection until checked
final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityState>(
        (ref) => ConnectivityNotifier(ConnectivityState.notConnected));
