import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:watchtower/Admin/create_userpage.dart';
import 'package:watchtower/Services/device_endpoint_config.dart';

import '../main.dart';

class UpdateUserPage extends StatefulWidget {
  final int id;
  final String initialUsername;
  final bool adminOrnot;

  UpdateUserPage({
    this.id = 0, // Default value set to 0
    required this.initialUsername,
    required this.adminOrnot,
  });
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final usernameController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  bool isAdmin = false;
  int id = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    usernameController.text = widget.initialUsername;
    isAdmin = widget.adminOrnot;
    id = widget.id;
  }

    Future<void> handleUpdate() async {
    var backendurl = await getBackEndUrl();
    var url = Uri.parse('http://$backendurl:8090/users');

     Map<String, dynamic> jsonMap = {
        'ID': id,
        'Username': usernameController.text,
        'Password': passwordController.text,
        'IsAdmin' : isAdmin,
      };
      print(json.encode(jsonMap));
      final response = await http.put(url, headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
    body: json.encode(jsonMap)
    ); 
    
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.of(context).pop(true);
      ShowSnackBarMessage("Successfully Edited User",Icon(Icons.update, color: Colors.white));
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update User",style: GoogleFonts.audiowide(color:Colors.black)),
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
                    onPressed: handleUpdate,
                    label: Text("Update User",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15)),
                    icon: const Icon(Icons.update),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
