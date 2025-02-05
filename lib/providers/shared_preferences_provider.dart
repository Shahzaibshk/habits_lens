import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Override provider in provider scope
final sharedPreferencesProvider = Provider<SharedPreferencesProvider>((ref) {
  throw UnimplementedError();
});

class SharedPreferencesProvider {
  const SharedPreferencesProvider(this.prefs, this.ref);
  final SharedPreferences prefs;
  final Ref ref;

  final onboardingKey = 'onboarding';
  final themeModeKey = 'themeMode';

  bool get showOnboarding => prefs.getBool(onboardingKey) ?? true;
  Future<void> setOnboardingFalse() async {
    await prefs.setBool(onboardingKey, false);
  }
}
