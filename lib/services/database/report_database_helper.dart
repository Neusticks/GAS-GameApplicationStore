import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/models/ReportedProblem.dart';
import 'package:gas_gameappstore/models/ReportedUser.dart';

class ReportDatabaseHelper{
  static const String PROBLEM_REPORT_COLLECTION_NAME = "reportedProblem";
  static const String USER_REPORT_COLLECTION_NAME = "reportedUser";
  static const String USER_REPORT_ID_KEY = "reportedUserId";
  static const String PROBLEM_REPORT_ID_KEY = "reportedProblemId";
  static const String PROBLEM_REPORT_USER_NAME_KEY = "reportedProblemUsername";
  static const String PROBLEM_REPORT_DATE_KEY = "reportedProblemDate";
  static const String PROBLEM_REPORT_DESCRIPTION_KEY = "reportedProblemDesc";
  static const String USER_REPORT_USER_NAME_KEY = "userNameReport";
  static const String USER_REPORT_REPORTED_USER_NAME_KEY = "reportedUsername";
  static const String USER_REPORT_DATE_KEY = "reportedUserDate";
  static const String USER_REPORT_DESCRIPTION_KEY = "reportedUserDesc";

  ReportDatabaseHelper._privateConstructor();
  static ReportDatabaseHelper _instance = ReportDatabaseHelper._privateConstructor();
  factory ReportDatabaseHelper(){
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore{
    if(_firebaseFirestore == null){
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<String> addProblemReport(ReportedProblem report) async{
    final reportCollectionRef = firestore.collection(PROBLEM_REPORT_COLLECTION_NAME);
    final docRef = await reportCollectionRef.add(report.toMap());
    return docRef.id;
  }

  Future<String> addUserReport(ReportedUser report) async{
    final reportCollectionRef = firestore.collection(USER_REPORT_COLLECTION_NAME);
    final docRef = await reportCollectionRef.add(report.toMap());
    return docRef.id;
  }

  Future<List<String>> get allProblemReport async{
    final reports = await firestore.collection(PROBLEM_REPORT_COLLECTION_NAME).get();
    List reportId = List<String>();
    for (final report in reports.docs){
      final id = report.id;
      reportId.add(id);
    }
    return reportId;
  }

  Future<ReportedProblem> getReportProblemWithId(String reportId) async{
    final docSnapshot = await firestore.collection(PROBLEM_REPORT_COLLECTION_NAME).doc(reportId).get();
    if(docSnapshot.exists){
      return ReportedProblem.fromMap(docSnapshot.data(), id: docSnapshot.id);
    }
    return null;
  }

  Future<List<String>> get allUserReport async{
    final reports = await firestore.collection(USER_REPORT_COLLECTION_NAME).get();
    List reportId = List<String>();
    for (final report in reports.docs){
      final id = report.id;
      reportId.add(id);
    }
    return reportId;
  }

  Future<ReportedUser> getUserReportWithId(String reportId) async{
    final docSnapshot = await firestore.collection(USER_REPORT_COLLECTION_NAME).doc(reportId).get();
    if(docSnapshot.exists){
      return ReportedUser.fromMap(docSnapshot.data(), id: docSnapshot.id);
    }
    return null;
  }
}