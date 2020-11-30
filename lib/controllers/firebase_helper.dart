import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static final String _onlineDrivers = "online_drivers";

  Future<List<Map<String, dynamic>>> getOnlineDrivers(
      {bool inSide, bool isMale}) async {
    List<Map<String, dynamic>> data = [];
    QuerySnapshot querySnapshot;

    if (isMale == null)
      querySnapshot = await FirebaseFirestore.instance
          .collection("$_onlineDrivers")
          .where("inSide", isEqualTo: inSide)
          .get();
    else if (isMale)
      querySnapshot = await FirebaseFirestore.instance
          .collection("$_onlineDrivers")
          .where("inSide", isEqualTo: inSide)
          .where("gender", isEqualTo: "m")
          .get();
    else
      querySnapshot = await FirebaseFirestore.instance
          .collection("$_onlineDrivers")
          .where("inSide", isEqualTo: inSide)
          .where("gender", isEqualTo: "f")
          .get();

    querySnapshot.docs
        .map((QueryDocumentSnapshot e) => data.add(e.data()))
        .toList();

    return data;
  }
}
