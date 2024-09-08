import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:studentattendence/services/databases.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _rollnoController = TextEditingController();

  bool isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  SizedBox(width: 70),
                  Text("Add",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(width: 10),
                  Text("Student",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              SizedBox(height: 30),
              Text("Student Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Student Name"),
                ),
              ),
              SizedBox(height: 20),
              Text("Student Age",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Student Age"),
                ),
              ),
              SizedBox(height: 20),
              Text("Student Roll no",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _rollnoController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Student Roll no"),
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  // Prevent multiple submissions when in loading state
                  if (!isLoading && _nameController.text != "" && _ageController.text != "" && _rollnoController.text != "") {
                    setState(() {
                      isLoading = true; // Start loading
                    });
                    
                    String Addid = randomAlpha(10);
                    Map<String, dynamic> StudentInfoMap = {
                      "Name": _nameController.text,
                      "Age": _ageController.text,
                      "RollNo": _rollnoController.text,
                      "Absent": false,
                      "Present": false,
                    };
                    
                    // Add student to the database
                    await DatabaseMethods().addStudent(StudentInfoMap, Addid).then((value) {
                      // Clear the fields
                      _nameController.text = "";
                      _ageController.text = "";
                      _rollnoController.text = "";

                      // Show success toast message
                      Fluttertoast.showToast(
                        msg: "Student Data Has Been Uploaded",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    }).catchError((error) {
                      // Handle error if any
                      Fluttertoast.showToast(
                        msg: "Error uploading student data!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    }).whenComplete(() {
                      setState(() {
                        isLoading = false; // Stop loading
                      });
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please fill all the fields",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  }
                },
                child: isLoading // Show loading indicator if isLoading is true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : Center(
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
