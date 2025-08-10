// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get serverUrlLabel => 'Server URL';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String hello(String username) {
    return 'Hello $username';
  }

  @override
  String get library => 'Library';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get continueListening => 'Continue Listening';

  @override
  String get refresh => 'Refresh';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get controls => 'Controls';

  @override
  String get localListening => 'Local Listening';

  @override
  String get downloads => 'Downloads';

  @override
  String get noDownloads => 'No downloads';
}
