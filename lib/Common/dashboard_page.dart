import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:watchtower/Admin/users_page.dart';
import 'dart:convert';

import '../Logout/dashboard_logout.dart';
import '../Services/username_data.dart';
import '../Settings/device_config.dart';
import 'history_page.dart';
import 'home_page.dart';


class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int currentPage = 0;
  late Future<bool?> isAdminFuture = getIsAdmin();
  List<Widget> pages = [
    HomePage(),
    NotificationList(),
    UsersPage(),
  ];

  
  
  @override
  void initState() {
    super.initState();
    isAdminFuture = getIsAdmin();
  }

  

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
              title: getDashboardTitle(context, currentPage),
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
                    showLogoutAlert(context);
                    print("Logout");
                  },
                  icon: const Icon(
                    Icons.logout,
                )),
              ],    
            ),
        bottomNavigationBar: FutureBuilder<bool?>(
          future: isAdminFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for isAdmin value, return an empty container.
              return SizedBox.shrink();
            } else if (snapshot.hasError || snapshot.data == false) {
              // If an error occurs or isAdmin is false, don't show the "Users" tab.
              return NavigationBar(
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home, size: 20),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history, size: 20),
                    label: 'History',
                  ),
                ],
                onDestinationSelected: (int index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                selectedIndex: currentPage,
              );
            } else {
              // If isAdmin is true or null, show the "Users" tab.
              return NavigationBar(
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home, size: 20),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history, size: 20),
                    label: 'History',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.people, size: 20),
                    label: 'Users',
                  ),
                ],
                onDestinationSelected: (int index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                selectedIndex: currentPage,
              );
            }
          },
        ),
        body: pages[currentPage],
      ),
    );
  }
}

Widget? getDashboardTitle(BuildContext context, currPage) {
  if (currPage == 0) {
    return Text("Dashboard",style: GoogleFonts.audiowide(color: Colors.black));
  } else if (currPage == 1){
    return Text("Water Level History",style: GoogleFonts.audiowide(color: Colors.black));
  } else if (currPage == 2){
    return Text("Users",style: GoogleFonts.audiowide(color: Colors.black));
  }
  return null;
}


