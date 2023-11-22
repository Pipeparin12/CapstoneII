import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/service/api/user.dart';

class AccManagementScreen extends StatefulWidget {
  const AccManagementScreen({super.key});

  @override
  State<AccManagementScreen> createState() => _AccManagementScreenState();
}

class _AccManagementScreenState extends State<AccManagementScreen> {
  var users = [];
  List<String> userRole = ['customer', 'admin'];

  Future<void> getPacking() async {
    try {
      var result = await UserApi.getUsers();
      print(result.data);
      setState(() {
        users = result.data['users'].map((user) {
          return {
            ...user,
            "userId": user['_id'],
          };
        }).toList();
      });
      print(users);
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getPacking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Management"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      String selectedUserRole = users[index]['role'];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title:
                              Text("${user["firstName"]} ${user["lastName"]}"),
                          subtitle: Text("Username: ${user["username"]}"),
                          trailing: DropdownButton<String>(
                            value: selectedUserRole,
                            onChanged: (String? value) {
                              setState(() {
                                user["role"] = value!;
                              });
                            },
                            items: userRole.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  List<Map<String, dynamic>> updatedUsers = users.map((user) {
                    return {
                      "userId": user["userId"],
                      "role": user["role"],
                    };
                  }).toList();
                  var result = await UserApi.updateUserRoles(updatedUsers);
                  print(result.data);
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade400,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
