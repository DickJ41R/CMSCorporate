//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcp_app/services/auth_service.dart';
import 'package:hcp_app/models/users.dart';

class HCPUserServices {
  late int? userId;
  late String? fullName;
  late List<String>? userRoles;
  late dynamic hcpUser;
  AuthService authService = AuthService();
  dynamic currentUser;
  Users? user;
  String? email;

  HCPUserServices();

  Future<Map<String, dynamic>> getHCPUser(int hcpId) async {
    print('line 19 in gethcpuser $hcpId');
    try {
      Map<String, dynamic>? hcpUser;
      await FirebaseFirestore.instance
          .collection("HCProfessional")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          hcpUser = obj;
          print('line 29: ${hcpUser!['hcpId']}');
          await FirebaseFirestore.instance
              .collection('HCPAddress')
              .where('hcpId', isEqualTo: obj['hcpId'])
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              var adr = docSnapshot.data();
              if (adr['latitude'] != null) {
                hcpUser!['latitude'] = adr['latitude'];
                hcpUser!['longitude'] = adr['longitude'];
                break;
              }
            }
          });
          if (hcpUser == null) {
            print('line 48 hcpuser is null $email');
            return {};
          }
          print('line 50:  ${hcpUser!['latitude']} ${hcpUser!['longitude']}');
          authService.hcpId = hcpUser!['hcpId'];
          print('line 52 in get hcpuser hcpid');
          return hcpUser!;
        }
      });
      return hcpUser!;
    } catch (e) {
      print('line 58 error getting hcpuser: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getHCProfessional(String email) async {
    print('line 61 in getHCPProfessional: $email');
    try {
      Map<String, dynamic>? hcpUser;
      await FirebaseFirestore.instance
          .collection("HCProfessional")
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          hcpUser = obj;
        }
      });

      print('line 42: in get hcpuser $email');
      return hcpUser!;
    } catch (e) {
      print('line 53 error getting hcpuser: $e');
      throw Exception(e);
    }
  }
}
