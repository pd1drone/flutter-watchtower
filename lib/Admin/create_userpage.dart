import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:watchtower/Services/device_endpoint_config.dart';

import '../main.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final usernameController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  bool isAdmin = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }

    Future<void> handleCreate() async {
    var backendurl = await getBackEndUrl();
    var url = Uri.parse('http://$backendurl:8090/users');

     Map<String, dynamic> jsonMap = {
        'Username': usernameController.text,
        'Password': usernameController.text,
        'IsAdmin' : isAdmin,
      };
    final response = await http.post(url, headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json'
    },
    body: json.encode(jsonMap)
    ); 
    
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(context).pop(true);
      ShowSnackBarMessage("Succesfully Created User",const Icon(Icons.add, color: Colors.white));
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create User",style: GoogleFonts.audiowide(color:Colors.black)),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: Image.asset(
              'images/watchtower_no_bg.png',
              height: 65,
              width: 65,
            ),
        actions: [
          IconButton(
            onPressed: () {
              print("Logout");
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
          )),
        ],    
      ),
      body: SingleChildScrollView(
        child: 
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                Text(
                  "Username:",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: GoogleFonts.audiowide(color: Colors.black),
                    controller: usernameController,
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
                    obscureText: true,
                    style: GoogleFonts.audiowide(color: Colors.black),
                    controller: passwordController,
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
                  "Is Admin:",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<bool>(
                    value: isAdmin,
                    onChanged: (value) {
                      setState(() {
                        isAdmin = value!;
                      });
                    },
                    items:  [
                      DropdownMenuItem<bool>(
                        value: true,
                        child: Text("Yes",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24)),
                      ),
                      DropdownMenuItem<bool>(
                        value: false,
                        child: Text("No",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: handleCreate,
                    label: Text("Create User",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15)),
                    icon: const Icon(Icons.people),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}


void ShowSnackBarMessage(String message, Icon icon) {
  snackbarKey.currentState?.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.orange,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    shape: const StadiumBorder(),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  [
        icon,
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.audiowide(color:Colors.white),
          ),
        ),
      ],
    ),
  ));
}
