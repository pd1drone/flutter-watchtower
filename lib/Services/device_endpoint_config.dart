import 'package:shared_preferences/shared_preferences.dart';


Future<bool> saveBackEndUrl(String value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("backend", value);
  print('backend: $value');
  return prefs.setString("backend", value);
}

Future<String?> getBackEndUrl() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? backend = prefs.getString("backend");
  return backend;
}


Future<bool> saveNodeMCUUrl(String value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("nodemcu", value);
  print('nodemcu: $value');
  return prefs.setString("nodemcu", value);
}

Future<String?> getNodeMCUUrl() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? nodemcu = prefs.getString("nodemcu");
  return nodemcu;
}


