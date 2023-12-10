import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:watchtower/Services/device_endpoint_config.dart';
import 'package:http/http.dart' as http;

int id = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime lastNotificationTime = DateTime(2018);
  double waterValue = 0.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to update waterValue every 100 milliseconds
    GetSensorValues();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      GetSensorValues();
    });
  }

  void cancelTimer() {
    if (timer != null) {
      timer?.cancel();
    }
  }

  void GetSensorValues() async{

  var endpoint = await getNodeMCUUrl();
  var url = Uri.parse('http://$endpoint:8088/waterlvl');
    http.Response response = await http.get(url,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        });

        
    final Map parsed = json.decode(response.body);
    print("${response.statusCode}");
    print(parsed);

      if (response.statusCode == 200){
        setState(() {
          waterValue = double.parse(parsed["water_level"]);
        });
      }
    
    if (lastNotificationTime == null ||
          DateTime.now().difference(lastNotificationTime).inMinutes >= 5) {
      if (waterValue >= 18.0){
          await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: 'waterlvl',
            title:'Water Level has reached ' +waterValue.toStringAsFixed(1)+'m' ,
            body: 'Marikina River is now on 3rd alarm.\nWater Level: ' + waterValue.toStringAsFixed(1) + 'm',
            notificationLayout: NotificationLayout.Default,
            displayOnForeground: true,
          ),
        );
        lastNotificationTime = DateTime.now();
      }else if (waterValue < 18.0 && waterValue >=16.0){
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: 'waterlvl',
            title:'Water Level has reached ' +waterValue.toStringAsFixed(1)+'m' ,
            body: 'Marikina River is now on 2nd alarm.\nWater Level: ' + waterValue.toStringAsFixed(1) + 'm',
            notificationLayout: NotificationLayout.Default,
            displayOnForeground: true,
          ),
        );
        lastNotificationTime = DateTime.now();
      }else if (waterValue <16.0 && waterValue >=15.0){
          await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: 'waterlvl',
            title:'Water Level has reached ' +waterValue.toStringAsFixed(1)+'m' ,
            body: 'Marikina River is now on 1st alarm.\nWater Level: ' + waterValue.toStringAsFixed(1) + 'm',
            notificationLayout: NotificationLayout.Default,
            displayOnForeground: true,
          ),
        );
        lastNotificationTime = DateTime.now();
      }
    }
  }
  @override
  void dispose() {
    // Cancel the Timer when the page is no longer active
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 110,
                        child: Image.asset('images/watchtower_no_bg.png')
                        ),
                      Text(
                        'ater Level',
                        style: GoogleFonts.audiowide(color: Colors.black, fontSize: 35),
                      ),
                    ],
                  ),
                  Text(
                    'Monitoring',
                    style: GoogleFonts.audiowide(color: Colors.black, fontSize: 35),
                  ),
                ],
              ), 
              const SizedBox(height: 50),
              Container(
                  child: LiquidCustomProgressIndicator(
                    value: waterValue / 22,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                    backgroundColor: Colors.grey,
                    direction: Axis.vertical,
                    shapePath: _buildWaterTankPath(),
                    center: Text(waterValue.toStringAsFixed(1)+" meters",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
                  ),
                ),
            ],
        ),
      ),
    );
  }
}
Path _buildWaterTankPath() {
  final path = Path();
  double width = 300.0; // Width of the cylinder
  double height = 300.0; // Height of the cylinder
  double radius = width / 4.0; // Radius of the cylinder (1/4 of the width)

  // Draw the top rectangle of the cylinder
  path.moveTo(0, 0); // Move to the top-left corner
  path.lineTo(width, 0); // Draw the top-right corner
  path.lineTo(width, height / 2.0); // Draw the bottom-right corner
  path.lineTo(0, height / 2.0); // Draw the bottom-left corner
  path.close(); // Close the top rectangle

  // Draw the bottom ellipse of the cylinder
  Rect bottomEllipseRect = Rect.fromCenter(
    center: Offset(width / 2.0, height / 2.0),
    width: width,
    height: height / 2.0,
  );
  path.addOval(bottomEllipseRect);

  return path;
}