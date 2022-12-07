import 'package:connectivity_checker/src/qrcode/qrcode.dart';
import 'package:connectivity_checker/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The homepage os simple a place to launch the QRCODE page
/// When the QRCODe button is pressed the internet connection check will start
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: const Text("Connectivity Demo")),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  ref.read(connectivityProvider.notifier).checkConnection;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRCodePage()));
                },
                child: const Text("SHOW QRCODE"))));
  }
}
