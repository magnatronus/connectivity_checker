import 'package:connectivity_checker/src/home/home.dart';
import 'package:connectivity_checker/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<SharedPreferences> prefs = ref.watch(sharedPreferencesProvider);
    return MaterialApp(
        title: 'Connectivity Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: prefs.when(
            data: (_) => const HomePage(),
            error: (err, stack) {},
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}
