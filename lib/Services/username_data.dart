import 'package:shared_preferences/shared_preferences.dart';


Future<bool> saveUsername(String value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("username", value);
  print('username: $value');
  return prefs.setString("username", value);
}

Future<String?> getUsername() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString("username");
  return username;
}


Future<bool> saveIsAdmin(bool value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isadmin", value);
  print('isadmin: $value');
  return prefs.setBool("isadmin", value);
}

Future<bool?> getIsAdmin() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isadmin = prefs.getBool("isadmin");
  return isadmin;
}


Future<bool> saveUserID(int value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("userid", value);
  print('userid: $value');
  return prefs.setInt("userid", value);
}

Future<int?> getUserID() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userid = prefs.getInt("userid");
  return userid;
}

