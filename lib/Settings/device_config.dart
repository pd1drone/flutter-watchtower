import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:watchtower/Services/device_endpoint_config.dart';

class DeviceConfigPage extends StatefulWidget {
  @override
  _DeviceConfigPageState createState() => _DeviceConfigPageState();
}

class _DeviceConfigPageState extends State<DeviceConfigPage> {
  final BackendipController = TextEditingController(text: "");
  final NodeMCUipController = TextEditingController(text: "");

  @override
  void dispose() {
    BackendipController.dispose();
    NodeMCUipController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _getDefaultSettings();
  }

  Future<void> _handleConnect() async {
    
    var BackendIP = BackendipController.text;
    var NodeIP = NodeMCUipController.text;

    saveBackEndUrl(BackendIP);
    saveNodeMCUUrl(NodeIP);

    Navigator.pop(context);

  }

  Future<void> _getDefaultSettings() async{
    var backend = await getBackEndUrl();
    var nodemcu = await getNodeMCUUrl();
    BackendipController.text = backend!;
    NodeMCUipController.text = nodemcu!;
    print(BackendipController.text);
    print(NodeMCUipController.text);
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
                  'Settings',
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 48),
                ),
                const SizedBox(height: 70,),
                Text(
                  "Backend IP Address:",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: GoogleFonts.audiowide(color: Colors.black),
                    controller: BackendipController,
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
                  "NodeMCU IP Address:",
                  style: GoogleFonts.audiowide(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: GoogleFonts.audiowide(color: Colors.black),
                    controller: NodeMCUipController,
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
                const SizedBox(height: 50),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _handleConnect,
                    label: Text("Save Settings",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15)),
                    icon: const Icon(Icons.settings),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
