import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';


import 'package:http/http.dart' as http;
import 'package:watchtower/Services/device_endpoint_config.dart';

import '../Models/waterlevel_model.dart';
import '../main.dart';


var updateDate = DateFormat('MM/dd/yyyy hh:mm:ss').format(DateTime.now());

Future<void> _refresh() {
  return Future.delayed(
    const Duration(seconds: 1),
    () async {
      var dateNow = DateTime.now();
      String formattedDate = DateFormat('MM/dd/yyyy hh:mm:ss').format(dateNow);
      snackbarKey.currentState?.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: const StadiumBorder(),
        content: Row(
          children: [
            const Icon(Icons.refresh, color: Colors.white),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'Page has been refreshed at: $formattedDate',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ));
    },
  );
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getWaterLevelData(),
        builder: (context, snapshot) {
          print(snapshot);
          if (!snapshot.hasData) {
            return Container();
          } else {
            var notify = snapshot.data;
            int itemCount = notify!.length;

            if (itemCount == 0) {
              return Scaffold(
                body: SingleChildScrollView(
                    child: Column(
                  children: const [
                    SizedBox(
                      height: 250,
                    ),
                    Center(child: Text("There are no new notifications!")),
                    SizedBox(
                      height: 500,
                    ),
                  ],
                )),
              );
            }
            return Scaffold(
                body: SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 500,
                      child: RefreshIndicator(
                        color: Colors.orange,
                        onRefresh: () async {
                          notify = await getWaterLevelData();
                          await Future.delayed(const Duration(seconds: 2));
                          _refresh();
                          setState(() {
                            itemCount = notify!.length;
                          });
                        },
                        edgeOffset: 15,
                        displacement: 75,
                        strokeWidth: 4,
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        child: ListView.builder(
                          itemCount: itemCount,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: _buildNotifTitle(
                                  context, index, notify![index]),
                              leading: const Icon(Icons.water_drop,color: Colors.blue),
                              trailing: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      DateFormat('MM/dd/yyyy hh:mm:ss').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              notify![index].Timestamp * 1000)),
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 13)),
                                ],
                              ),
                              onTap: () async {
                                debugPrint("item ${(index + 1)} selected");
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )));
          }
        });
  }
}

Widget _buildLeadingIcon(BuildContext context, String Severity) {
  switch (Severity) {
    case "Informational":
      {
        return const ImageIcon(
          AssetImage("images/alert blue.png"),
          size: 30,
          color: Colors.blue,
        );
      }
    case "Service Impacting":
      {
        return const ImageIcon(
          AssetImage("images/alert red.png"),
          size: 30,
          color: Colors.red,
        );
      }
    case "Planned Works/Future Notice":
      {
        return const ImageIcon(
          AssetImage("images/alert amber.png"),
          size: 30,
          color: Colors.amber,
        );
      }
  }

  return const Scaffold();
}

Widget _buildNotifTitle(BuildContext context, int index, WaterLevelData WaterLevelData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        ("${WaterLevelData.WaterLevel.toString()} meters"),
        style: GoogleFonts.sourceSansPro(
            fontSize: 14, fontWeight: FontWeight.bold),
      ),
      Text(("The water level is ${WaterLevelData.WaterLevel.toString()} meters"),
          style: GoogleFonts.sourceSansPro(
            fontSize: 13,
          ))
    ],
  );
}

PreferredSizeWidget _updateAppBarOnWaterLevel() {
  return AppBar(
    title: Column(
      children: [
        const SizedBox(
          height: 5,
          width: 150,
        )
      ],
    ),
    toolbarHeight: 90,
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.orange,
    centerTitle: true,
  );
}

Future<List<WaterLevelData>> getWaterLevelData() async {
  
  var endpoint = await getBackEndUrl();
  // parse url
  var url = Uri.parse('http://$endpoint:8090/getHistory');
  print(url);

  // send request to backend server
  http.Response response = await http.get(url, headers: {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json'
  });

  // map response from server
  final Map parsed = json.decode(response.body);

  List<WaterLevelData> waterlvl = [];
  // check if response is successful
  if (response.statusCode == 200) {
    // return parsed response of server
    for (int i = 0; i <= parsed["WaterLevelData"].length - 1; i++) {
      waterlvl.add(WaterLevelData.fromMap(parsed["WaterLevelData"][i]));
    }

    print(waterlvl[0].ID);
    print(waterlvl[0].WaterLevel);
    print(waterlvl[0].Timestamp);

    return waterlvl;
  }
  return waterlvl;
}

PreferredSizeWidget _updateAppBarOnNotification() {
  return AppBar(
    title: Column(
      children: [
        const SizedBox(
          height: 5,
          width: 150,
        ),
        Image.asset(
          'images/esc-logo-horiz.png',
          width: 200,
        ),
      ],
    ),
    toolbarHeight: 90,
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.orange,
    centerTitle: true,
  );
}
