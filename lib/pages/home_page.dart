import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentattendence/pages/add_student.dart';
import 'package:studentattendence/services/databases.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

@override
void initState(){
  getontheLoad();
  super.initState();
}


getontheLoad()async{
  studentStream = await DatabaseMethods().getStudentDetails();
  setState(() {
    
  });
}

Stream? studentStream;

Widget StudentList() {
  return StreamBuilder(
    stream: studentStream,
    builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData
          ? ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                // Fetch attendance status and locking state
                bool isAttendanceLocked = ds['attendanceLocked'];
                bool isPresent = ds['Present'];
                bool isAbsent = ds['Absent'];

                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Student Name: ",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                ds["Name"],
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await DatabaseMethods()
                                        .deleteStudentData(ds.id);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text(
                                "Roll no: ",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                ds["RollNo"],
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text(
                                "Age: ",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                ds["Age"],
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                         
                          Row(
                            children: [
                              Text(
                                "Attendance: ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: isAttendanceLocked
                                    ? null // Disable tap if attendance is locked
                                    : () async {
                                        await DatabaseMethods()
                                            .updateAttendance(
                                                "Present", ds.id);
                                      },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5),
                                    color: isPresent
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "P",
                                      style: TextStyle(
                                          color: isPresent
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: isAttendanceLocked
                                    ? null // Disable tap if attendance is locked
                                    : () async {
                                        await DatabaseMethods()
                                            .updateAttendance(
                                                "Absent", ds.id);
                                      },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5),
                                    color: isAbsent
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "A",
                                      style: TextStyle(
                                          color: isAbsent
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Container();
    },
  );
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddStudent()));
        },
      child: Icon(Icons.add),),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 60.0,left: 20,right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Student",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black)
                  ),
                  SizedBox(width: 10,),
                   Text("Attendence",style: TextStyle(color:Colors.blue,fontSize: 24,fontWeight: FontWeight.bold,)
                  )
                ],
              ),
              SizedBox(height: 20,),
          StudentList()
            ],
          ),
        ),
      ),
    );
  }
}