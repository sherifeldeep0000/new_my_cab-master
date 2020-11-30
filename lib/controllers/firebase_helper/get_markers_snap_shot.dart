import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

Stream<QuerySnapshot> getOnlineDriversSnapShot() =>
    _fireStore.collection("online_drivers").snapshots();
