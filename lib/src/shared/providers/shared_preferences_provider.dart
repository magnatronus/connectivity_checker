import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared Preferences Provider - simply provides a common link to SharedPrefs
final sharedPreferencesProvider =
    FutureProvider((ref) async => SharedPreferences.getInstance());
