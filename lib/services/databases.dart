import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addStudent(Map<String, dynamic> studentInfoMap, String id) async {
    studentInfoMap['attendanceLocked'] = false;
    studentInfoMap['Present'] = false;
    studentInfoMap['Absent'] = false;
    return await FirebaseFirestore.instance
        .collection("Student")
        .doc(id)
        .set(studentInfoMap);
  }

  Future<Stream<QuerySnapshot>> getStudentDetails() async {
    return FirebaseFirestore.instance.collection("Student").snapshots();
  }

  Future<void> updateAttendance(String attendanceField, String id) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection("Student").doc(id).get();

    bool attendanceLocked = docSnapshot['attendanceLocked'];
    if (!attendanceLocked) {
      await FirebaseFirestore.instance.collection("Student").doc(id).update({
        attendanceField: true,
        'attendanceLocked': true, // Lock the attendance after marking
      });
    }
  }

  Future<void> deleteStudentData(String id) async {
    await FirebaseFirestore.instance.collection("Student").doc(id).delete();
  }
}
