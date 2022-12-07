import 'package:connectivity_checker/src/qrcode/providers/qrcode_provider.dart';
import 'package:connectivity_checker/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// The QRCODE page uses both the internet connectivity provider and the qrcodeProvider
/// The screen background is RED if no internet connection and GREEN if there is one
class QRCodePage extends ConsumerWidget {
  const QRCodePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectivityProvider);
    final qrcodeState = ref.watch(qrcodeProvider);
    switch (connectionState) {
      case ConnectivityState.checking:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );

      default:
        return Scaffold(
            backgroundColor: connectionState == ConnectivityState.notConnected
                ? Colors.red
                : Colors.green,
            appBar: AppBar(
              title: const Text("QRCODE DISPLAY"),
            ),
            body: Stack(
              children: [
                Visibility(
                  visible: qrcodeState == QRCodeState.loading,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                Visibility(
                    visible: qrcodeState != QRCodeState.loading,
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                            visible: ref
                                .read(qrcodeProvider.notifier)
                                .codeValue
                                .isNotEmpty,
                            child: QrImage(
                              data: ref.read(qrcodeProvider.notifier).codeValue,
                              version: QrVersions.auto,
                              size: 100.0,
                            )),
                        Text(ref.read(qrcodeProvider.notifier).codeValue),
                        Visibility(
                            visible: connectionState ==
                                ConnectivityState.notConnected,
                            child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(connectivityProvider.notifier)
                                      .checkConnection;
                                },
                                child: const Text("RETRY")))
                      ],
                    )))
              ],
            ));
    }
    ;
  }
}
