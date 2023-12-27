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
  String warningLevel = "Normal";
  Timer? timer;
  MaterialColor waterColor = Colors.blue;
  double waterLevelPredictionPrevValue =0.0;
  Timer? waterLevelPredictionTimer;
  int currentMessageIndex = 0;

  List<String>         warningMessages = [
        "STAY CALM AT ALL TIMES",
        "KNOW WHO TO CONTACT - KEEP YOUR LINES ALWAYS OPEN ",
        "BE AWARE OF YOUR SURROUNDINGS",
        "DO NOT PANIC",
        "BRING POWERBANKS OR OTHER PORTABLE CHARGER FOR YOUR DEVICES",
        "LISTEN AND KEEP TRACK OF RADIO OR LIVE NEWS",
        "ALWAYS DOUBLE-CHECK IF YOU ALREADT HAVE EVERYTHING YOU NEED",
        "TIME IS IMPORTANT AND KEY AT ALL TIMES",
       ];

  @override
  void initState() {
    super.initState();
    // Start a timer to update waterValue every 100 milliseconds
    GetSensorValues();
    GetWaterLevelColor();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      GetSensorValues();
      GetWaterLevelColor();
      updateWarningMessage();
    });
  }

  void updateWarningMessage() {
    setState(() {
      // Increment the message index
      currentMessageIndex = (currentMessageIndex + 1) % warningMessages.length;
    });
  }

Timer scheduleWaterLevelPrediction() {
  return Timer(Duration(minutes: 30), () {
    // Check if water level is still in warning state
    if (waterValue >= 15.0) {
      double predictedWaterLevelValue = waterValue - waterLevelPredictionPrevValue;
      // Show the prediction notification
      showWaterLevelPredictionNotification(predictedWaterLevelValue);
    }
  });
}

void showWaterLevelPredictionNotification(double predictedWaterLevelValue) async {
  double prediction = waterValue + predictedWaterLevelValue;
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id++,
      channelKey: 'waterlvl',
      title: 'Water Level Prediction',
      body: 'The Water Level in the next 30 minutes \nwill be: ' + prediction.toStringAsFixed(1) + 'm',
      notificationLayout: NotificationLayout.Default,
      displayOnForeground: true,
      color: Colors.blue,
      backgroundColor: Colors.blue,
      displayOnBackground: true,
    ),
  );
}

  void cancelTimer() {
    if (timer != null) {
      timer?.cancel();
    }
  }

  void GetWaterLevelColor() {
    if(waterValue >= 18.0){
        setState(() {
          warningLevel = "3rd alarm";
          waterColor = Colors.red;
       warningMessages = [
        "FORCED EVACUATION WILL BE ENFORCED",
        "DO NOT ATTEMPT TO DRIVE IN FLOODED AREAS",
        "HAVE YOUR COMMUNICATION DEVICES READY AND IN-HAND",
        "WHEN STRANDED, DO NOT PANIC",
       ];
        });
    }else if(waterValue < 18.0 && waterValue >=16.0){
        setState(() {
          warningLevel = "2nd alarm";
          waterColor = Colors.orange;
        warningMessages = [
        "EVACUATE TO DESIGNATED CENTERS",
        "STAY AWAY FROM LOW-LYING, OR FLOOD-PRONE AREAS",
        "KEEP UPDATED WITH NEWS IN YOUR AREA",
        "WATCH OUT FOR FLOODING",
        "SECURE YOUR HOMES; WINDOWS, DOORS, BACKDOORS, ETC.",
       ];
        });
    }else if(waterValue <16.0 && waterValue >=15.0){
        setState(() {
          warningLevel = "1st alarm";
          waterColor = Colors.yellow;
          warningMessages = [
        "PREPARE TO EVACUATE",
        "FAMILIARIZE AND KNOW THE EVACUATION AREAS",
        "HAVE ENOUGH FOOD, AND WATER FOR 3 DAYS",
        "HAVE SOME CASH HANDY", 
        "ONLINE PAYMENTS OR BANKS MAY BE UNAVAILABLE",
       ];
        });
    }else if(waterValue <15.0){
        setState(() {
          warningLevel = "Normal";
          waterColor = Colors.blue;
        warningMessages = [
        "STAY CALM AT ALL TIMES",
        "KNOW WHO TO CONTACT - KEEP YOUR LINES ALWAYS OPEN ",
        "BE AWARE OF YOUR SURROUNDINGS",
        "DO NOT PANIC",
        "BRING POWERBANKS OR OTHER PORTABLE CHARGER FOR YOUR DEVICES",
        "LISTEN AND KEEP TRACK OF RADIO OR LIVE NEWS",
        "ALWAYS DOUBLE-CHECK IF YOU ALREADT HAVE EVERYTHING YOU NEED",
        "TIME IS IMPORTANT AND KEY AT ALL TIMES",
       ];
        });
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
            color: Colors.red,
            backgroundColor: Colors.red,
            displayOnBackground: true
          ),
        );
        waterLevelPredictionPrevValue = waterValue;
        lastNotificationTime = DateTime.now();
        if (waterLevelPredictionTimer?.isActive != true) {
          waterLevelPredictionTimer = scheduleWaterLevelPrediction();
        }
      }else if (waterValue < 18.0 && waterValue >=16.0){
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: 'waterlvl',
            title:'Water Level has reached ' +waterValue.toStringAsFixed(1)+'m' ,
            body: 'Marikina River is now on 2nd alarm.\nWater Level: ' + waterValue.toStringAsFixed(1) + 'm',
            notificationLayout: NotificationLayout.Default,
            displayOnForeground: true,
            color: Colors.orange,
            backgroundColor: Colors.orange,
            
            displayOnBackground: true
          ),
        );
        waterLevelPredictionPrevValue = waterValue;
        lastNotificationTime = DateTime.now();
        if (waterLevelPredictionTimer?.isActive != true) {
          waterLevelPredictionTimer = scheduleWaterLevelPrediction();
        }
      }else if (waterValue <16.0 && waterValue >=15.0){
          await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: 'waterlvl',
            title:'Water Level has reached ' +waterValue.toStringAsFixed(1)+'m' ,
            body: 'Marikina River is now on 1st alarm.\nWater Level: ' + waterValue.toStringAsFixed(1) + 'm',
            notificationLayout: NotificationLayout.Default,
            displayOnForeground: true,
            color: Colors.yellow,
            backgroundColor: Colors.yellow,
            displayOnBackground: true
          ),
        );
        waterLevelPredictionPrevValue = waterValue;
        lastNotificationTime = DateTime.now();
        if (waterLevelPredictionTimer?.isActive != true) {
          waterLevelPredictionTimer = scheduleWaterLevelPrediction();
        }
      }else if (waterValue < 15.0) {
        waterLevelPredictionTimer?.cancel();
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
                height: 10,
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
              const SizedBox(height: 30),
              Text(
                '"Industrial Valley Compound"',
                style: GoogleFonts.audiowide(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(height: 30),
              Container(
                  child: LiquidCustomProgressIndicator(
                    value: waterValue / 22,
                    valueColor: AlwaysStoppedAnimation(waterColor),
                    backgroundColor: Colors.grey,
                    direction: Axis.vertical,
                    shapePath: _buildWaterTankPath(),
                    center: Text(waterValue.toStringAsFixed(1)+" meters",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 18)),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                'Water Level: '+ waterValue.toStringAsFixed(1)+" meters",
                style: GoogleFonts.audiowide(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                      'Warning: ',
                      style: GoogleFonts.audiowide(color: Colors.black, fontSize: 18),
                    ),
                  Text(
                    warningLevel,
                      style: GoogleFonts.audiowide(color: waterColor, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: 400,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Adjust the border color as needed
                      width: 2.0, // Adjust the border width as needed
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)), // Adjust the border radius as needed
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        warningMessages[currentMessageIndex],
                        style: GoogleFonts.audiowide(color: Colors.black, fontSize: 8),
                      ),
                    ],
                  ),
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
  double width = 250.0; // Width of the cylinder
  double height = 250.0; // Height of the cylinder
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