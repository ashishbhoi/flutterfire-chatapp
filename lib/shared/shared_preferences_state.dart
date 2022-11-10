import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesState {
  //keys
  static String userLoggedInKey = "USERLOGGEDINKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userNameKey = "USERNAMEKEY";

  //saving data to SF
  static Future<bool> setLoggedInStatus(bool loggedInStatus) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, loggedInStatus);
  }

  static Future setUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmail, userEmail);
  }

  static Future setUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  //getting the data from SF
  static Future<bool?> getLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}
