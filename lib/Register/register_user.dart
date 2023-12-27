import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:watchtower/Services/device_endpoint_config.dart';
import 'package:crypto/crypto.dart';

import 'dart:convert';

import '../main.dart';

class RegisterUserPage extends StatefulWidget {
  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final UsernameController = TextEditingController(text: "");
  final PasswordController = TextEditingController(text: "");
  final ConfirmPasswordController = TextEditingController(text: "");

  @override
  void dispose() {
    UsernameController.dispose();
    PasswordController.dispose();
    ConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }

  Future<void> _handleConnect() async {
    
    var Username = UsernameController.text;
    var Password = PasswordController.text;
    var ConfirmPassword = ConfirmPasswordController.text;

    var endpoint = await getBackEndUrl();


    if(Password == ConfirmPassword){
      var url = Uri.parse('http://$endpoint:8090/register');

      var bytes = utf8.encode(Password);
      var hash = md5.convert(bytes);

      print(hash);

      Map<String, dynamic> jsonMap = {
        'Username': Username ,
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
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          ShowSnackBarAlertSuccess(context);
          UsernameController.clear();
          PasswordController.clear();
          ConfirmPasswordController.clear();
        });
      }else{
        ShowSnackBarAlertErrorRegisterError(context,parsed["message"]);
      }
    }else{
        ShowSnackBarAlertErrorPasswordNotMatch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: 
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60,),
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
                Text(
                  'Register',
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 48),
                ),
                const SizedBox(height: 30,),
                Text(
                  "Username:",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: GoogleFonts.audiowide(color: Colors.black),
                    controller: UsernameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.black)
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.black)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                            Text(
                  "Password:",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: GoogleFonts.audiowide(color: Colors.black),
                    controller: PasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      fillColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.black)
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.black)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                            Text(
                  "Confirm Password:",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: GoogleFonts.audiowide(color: Colors.black),
                    controller: ConfirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      fillColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.black)
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.black)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _handleConnect,
                    label: Text("Register User",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15)),
                    icon: const Icon(Icons.app_registration_rounded),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}


void ShowSnackBarAlertErrorPasswordNotMatch(BuildContext context) {
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
            'Password and Confirm Password does not match',
            style: GoogleFonts.audiowide(color:Colors.black),
          ),
        ),
      ],
    ),
  ));
}

void ShowSnackBarAlertErrorRegisterError(BuildContext context, String message) {
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
            message,
            style: GoogleFonts.audiowide(color:Colors.black),
          ),
        ),
      ],
    ),
  ));
}

void ShowSnackBarAlertSuccess(BuildContext context) {
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
            'Successfully Registered the account',
            style: GoogleFonts.audiowide(color:Colors.white),
          ),
        ),
      ],
    ),
  ));
}
