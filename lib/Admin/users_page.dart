import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:http/http.dart' as http;
import 'package:watchtower/Admin/update_userpage.dart';
import 'package:watchtower/Models/user_model.dart';
import 'package:watchtower/Services/device_endpoint_config.dart';

import '../Models/waterlevel_model.dart';
import 'create_userpage.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserData> userdata= [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    var backendurl = await getBackEndUrl();
    var url = Uri.parse('http://$backendurl:8090/users');
    final response = await http.get(url, headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json'
    }); // Replace with your API URL
    
    List<UserData> userobj = [];
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      setState(() {
        // Map the response data to listOfColumns
      for (int i = 0; i <= parsed["UsersArray"].length - 1; i++) {
            userobj.add(UserData.fromMap(parsed["UsersArray"][i]));
        }
        userdata = userobj;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: 500,
                  child: DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 300,
                    columns: const [
                      DataColumn(
                        label: Text('ID'),
                      ),
                      DataColumn2(
                        label: Text('Username'),
                        size: ColumnSize.L,
                      ),
                      DataColumn(
                        label: Text('IsAdmin'),
                      ),
                      DataColumn(
                        label: Text('Edit'),
                      ),
                      DataColumn(
                        label: Text('Delete'),
                      ),
                    ],
                    rows: userdata.map(
                      (element) {
                        final id = element.ID;
                        final username = element.Username;
                        final isadmin = element.IsAdmin;
                        return DataRow(
                          cells: [
                            DataCell(Text(id.toString())),
                            DataCell(Text(username)),
                            DataCell(Text(isadmin.toString())),
                            DataCell(IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      handleEdit(id,username,isadmin);
                                    },
                                  )),
                            DataCell(          IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      handleDelete(id,username,isadmin);
                                    },
                                  ),
                              ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
                 SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateUserPage(),
                        ),
                      );
                    if (result == true) {
                      // Refresh logic here, e.g., fetch updated data
                      fetchData();
                    }
                  },
                  icon: const Icon(Icons.people),
                  label: Text(
                    "Create user",
                    style: GoogleFonts.audiowide(color:Colors.black, fontSize: 15),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleDelete(int id, String username, bool isAdmin ) async {
    print("Delete clicked for Number: $id");
    var backendurl = await getBackEndUrl();
    var url = Uri.parse('http://$backendurl:8090/users');

     Map<String, dynamic> jsonMap = {
        'ID': id
      };
    final response = await http.delete(url, headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json'
    },
    body: json.encode(jsonMap)
    ); 
    
    if (response.statusCode == 200) {
      print(response.body);
      ShowSnackBarMessage("Successfully Deleted the User",Icon(Icons.delete, color: Colors.white));
      fetchData();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void handleEdit(int id,String username, bool isAdmin) {
    print("Edit clicked for Number: $id");
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateUserPage(
        id: id,
        initialUsername: username,
        adminOrnot: isAdmin,
      ),
    ),
  ).then((result) {
    if (result == true) {
      // Fetch data here after UpdateUserPage has finished and popped
      fetchData();
    }
  });
  }
}