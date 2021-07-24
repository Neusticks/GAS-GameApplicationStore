import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';

class PilotDatabaseHelper{
  static const String PILOT_REQUEST_COLLECTION_NAME = "pilotRequest";
  static const String PILOT_REQUEST_ID_KEY = "requestId";
  static const String PILOT_REQUEST_GAME_ID_KEY = "gameId";
  static const String PILOT_REQUEST_USER_NAME_KEY = "userName";
  static const String PILOT_REQUEST_USER_PHONE_NUM_KEY = "userPhone";
  static const String PILOT_REQUEST_GAME_CHOICE_KEY = "pilotRequestGameChoice";
  static const String PILOT_REQUEST_STATUS_KEY = "requestStatus";

  PilotDatabaseHelper._privateConstructor();
  static PilotDatabaseHelper _instance = PilotDatabaseHelper._privateConstructor();
  factory PilotDatabaseHelper(){
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore{
    if(_firebaseFirestore == null){
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

    Future<String> addPilotRequest(PilotRequest request) async{
      final requestCollectionRef = firestore.collection(PILOT_REQUEST_COLLECTION_NAME);
      final docRef = await requestCollectionRef.add(request.toMap());
      return docRef.id;
    }

    Future<List<String>> get allRequestList async {
    final pilots = await firestore.collection(PILOT_REQUEST_COLLECTION_NAME).get();
    List requestId = List<String>();
    for (final request in pilots.docs) {
      final id = request.id;
      requestId.add(id);
    }
    return requestId;
  }

  Future<List<String>> get notFinishRequestList async {
    final pilots = await firestore.collection(PILOT_REQUEST_COLLECTION_NAME).where(PILOT_REQUEST_STATUS_KEY, isEqualTo: 'Not Finished').get();
    List requestId = List<String>();
    for (final request in pilots.docs){
      final id = request.id;
      requestId.add(id);
    }
    return requestId;
  }

  Future<PilotRequest> getRequestWithID(String requestId) async {
    final docSnapshot = await firestore
        .collection(PILOT_REQUEST_COLLECTION_NAME)
        .doc(requestId)
        .get();

    if (docSnapshot.exists) {
      return PilotRequest.fromMap(docSnapshot.data(), id: docSnapshot.id);
    }
    return null;
  }

}