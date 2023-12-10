import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watchtower/Services/device_endpoint_config.dart';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:watchtower/Services/username_data.dart';
import 'dart:convert';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

      @override
    void initState() {
    super.initState();

      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(title: Text("Allow Notifications"),
        content: Text("Our app would like to send you notifications"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Don't Allow",style: TextStyle(color: Colors.grey, fontSize: 18),)),
          TextButton(onPressed: (){
            AwesomeNotifications().requestPermissionToSendNotifications().then((_) => Navigator.pop(context));
          }, child: Text("Allow",style: TextStyle(color: Colors.teal, fontSize: 18,fontWeight: FontWeight.bold),))
        ],
        );
      });
      }
    });
  }
  
  final UsernameTextBoxController = TextEditingController(text: "");
  final PasswordTextBoxController = TextEditingController(text: "");
  bool loginfail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: 
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 120,),
                Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 110,
                      child: Image.asset('images/watchtower_no_bg.png')
                      ),
                    Text(
                      'atchtower',
                      style: GoogleFonts.audiowide(color: Colors.black, fontSize: 48),
                    ),
                  ],
                ),   
                const SizedBox(
                  height: 20,
                ),
                Text(
                      'Login',
                      style: GoogleFonts.audiowide(color: Colors.black, fontSize: 48),
                ),
                const SizedBox(
                    height: 40,
                ),    
                 SizedBox(
                  width: 295,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.1),
                    child: TextFormField(
                      style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Username';
                        }
                        return null;
                      },
                      controller: UsernameTextBoxController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        iconColor:Colors.black,
                        prefixIcon: const Icon(
                          Icons.people,
                          size: 40,
                        ),
                        hintText: 'Username',
                        labelText: 'Enter Username',
                        errorText: loginfail ? 'Invalid Credentials' : null,
                      ),
                    ),
                  ),
                ),    
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 295,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.1),
                    child: TextFormField(
                      style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password Cannot Be Empty';
                        }
                        return null;
                      },
                      controller: PasswordTextBoxController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.key,
                          size: 40,
                        ),
                        hintText: 'Password',
                        labelText: 'Enter Password',
                        errorText: loginfail ? '' : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    print(UsernameTextBoxController.text);
                    print(PasswordTextBoxController.text);

                    var endpoint = await getBackEndUrl();


                      var url = Uri.parse('http://$endpoint:8090/login');
                      //var url = Uri.parse('http://192.168.43.123:8081/login');

                      print(url);
                      var usernameTobeSent = UsernameTextBoxController.text;
                      var passwordTobeSent = PasswordTextBoxController.text;
                      
                      var bytes = utf8.encode(passwordTobeSent);
                      var hash = md5.convert(bytes);

                      print(hash);

                      Map<String, dynamic> jsonMap = {
                        'Username': usernameTobeSent == "" ? "" : usernameTobeSent ,
                        'Password': hash.toString(),
                      };

                      print(jsonMap);

                      http.Response response = await http.post(url,
                          headers: {
                            'Access-Control-Allow-Origin': '*',
                            'Content-Type': 'application/json'
                          },
                          body: json.encode(jsonMap));
                      final Map parsed = json.decode(response.body);
                      print("${response.statusCode}");
                      print(parsed);

                      bool success = parsed["success"];

                      if (success){
                        
                        Map loginData = parsed["response"];
                        var id = loginData["ID"];
                        var uname = loginData["Username"];
                        var pass = loginData["Password"];
                        var isadmin = loginData["IsAdmin"];
                        print(id);
                        print(uname);
                        print(pass);
                        print(isadmin);
                        loginfail = false;

                        saveUserID(id);
                        saveIsAdmin(isadmin);
                        saveUsername(uname);
                        _onLoading(context);
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pushNamed('dashboard');
                          ShowSnackBarAlert(context);
                          UsernameTextBoxController.clear();
                          PasswordTextBoxController.clear();
                        });
                      }else{
                        loginfail = true;
                        ShowSnackBarAlertError(context);
                      }
                  
                  },
                  icon: const Icon(Icons.login),
                  label: Text(
                    "Login",
                    style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pushNamed('settings');
                  },
                  icon: const Icon(Icons.settings),
                  label: Text(
                    "Configure Settings",
                    style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15),
                  ),
                ),
              ),
              ]
            ),
          ),
      ),
    );
  }
}


void _onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          height: 60,
          width: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children:  [
              const CircularProgressIndicator(
                color: Colors.orange,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Logging in...",
                style: GoogleFonts.audiowide(color:Colors.black,fontSize: 20),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void ShowSnackBarAlert(BuildContext context) {
  snackbarKey.currentState?.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.orange,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    shape: const StadiumBorder(),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  [
        const Icon(Icons.login, color: Colors.white),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            'Successfully Logged-in.',
            style: GoogleFonts.audiowide(color:Colors.white),
          ),
        ),
      ],
    ),
  ));
}


void ShowSnackBarAlertError(BuildContext context) {
  snackbarKey.currentState?.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    shape: const StadiumBorder(),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  [
        const Icon(Icons.login, color: Colors.black),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            'Error in Login wrong credentials',
            style: GoogleFonts.audiowide(color:Colors.black),
          ),
        ),
      ],
    ),
  ));
}