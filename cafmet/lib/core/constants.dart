// Google Sheets Configuration - Use environment variables for sensitive URLs
const String csvUrl = String.fromEnvironment(
  'GOOGLE_SHEETS_CSV_URL',
  defaultValue: 'YOUR_GOOGLE_SHEETS_CSV_URL_HERE',
);

const String csvId = String.fromEnvironment(
  'GOOGLE_SHEETS_ID',
  defaultValue: 'YOUR_GOOGLE_SHEETS_ID_HERE',
);

class AppConstants {
  const AppConstants._();

  static final RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9_]+$");
}
class AppStrings {
  const AppStrings._();

  static const String loginAndRegister = 'Login and Register UI';
  static const String uhOhPageNotFound = 'uh-oh!\nPage not found';

  static const String register = 'Register';
  static const String login = 'Login';
  static const String createYourAccount = 'Sign in to your\nAccount';
  static const String doNotHaveAnAccount = "Don't have an account?";

  static const String loggedIn = 'Logged In!';
  static const String registrationComplete = 'Registration Complete!';

  static const String username = 'Username';
  static const String pleaseEnterUsername = 'Please, Enter Username';
  static const String invalidUsername = 'Invalid Username';

  static const String password = 'Password';
  static const String pleaseEnterPassword = 'Please, Enter Password';
}
