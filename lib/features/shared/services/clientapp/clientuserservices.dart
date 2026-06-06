
class ClientUserServices {
  final int? clientId;
  final int? clientUserId;
  final String? fullName;
  final List<String>? userRoles;
  final dynamic clientUser;
  final List<int>? clientIds;
  final String? email;
  ClientUserServices(
      {this.clientId,
      this.clientUserId,
      this.fullName,
      required this.userRoles,
      this.clientUser,
      this.clientIds,
      this.email});

  ClientUserServices copyWith(
      {int? clientId,
      int? clientUserId,
      String? fullName,
      userRoles,
      clientUser,
      clientIds,
      email}) {
    return ClientUserServices(
        clientId: clientId ?? this.clientId,
        clientUserId: clientUserId ?? this.clientUserId,
        fullName: fullName ?? fullName,
        userRoles: userRoles ?? this.userRoles,
        clientUser: clientUser ?? this.clientUser,
        clientIds: clientIds ?? this.clientIds,
        email: email ?? this.email);
  }
}

// class ClientUserServicesNotifier extends StateNotifier<ClientUserServices> {
//   ClientUserServicesNotifier(
//       clientId, clientUserId, fullName, userRoles, clientUser, email)
//       : super((ClientUserServices(
//             clientId: clientId,
//             clientUserId: clientUserId,
//             fullName: fullName,
//             userRoles: userRoles,
//             clientUser: clientUser,
//             email: email)));
//
//   Future<dynamic> getClientUser(String email) async {
//     dynamic clientUser;
//     try {
//       await FirebaseFirestore.instance
//           .collection("ClientUser")
//           .where('email', isEqualTo: email)
//           .get()
//           .then((querySnapshot) {
//         for (var docSnapshot in querySnapshot.docs) {
//           var obj = docSnapshot.data();
//           clientUser = obj;
//         }
//       });
//
//       debugPrint('line 48: in get clientuser $email $clientUser');
//       return clientUser;
//     } catch (e) {
//       debugPrint('line 57 error getting client user: ${e.toString()}');
//       throw Exception(e.toString());
//     }
//   }
//
//   Future<dynamic> getClientList(List<dynamic> branchIds) async {
//     List<int> listOfBranchIds = [
//       615,
//       618,
//       621,
//       624,
//       631,
//       632,
//       634,
//       635,
//       637,
//       638,
//       639,
//       640,
//       641,
//       643
//     ];
//     List<int> disciplineIds = [558, 559, 560, 561, 567, 614, 643, 659];
//
//     debugPrint('line 42 clusrnotifction');
//     List<dynamic> clientList = [];
//     List<dynamic> hcpClientList = [];
//     List<int> lBranchCntIds = [];
//     List<List<int>> disciplineCnts = [];
//     List<List<dynamic>> hcpFinds = [];
//     List<Map<String, dynamic>> localList = [];
//     try {
//       await FirebaseFirestore.instance
//           .collection("ClientUser")
//           .where('status', isEqualTo: 'Active')
//           .get()
//           .then((querySnapshot) {
//         for (var docSnapshot in querySnapshot.docs) {
//           var obj = docSnapshot.data();
//           localList.add(obj);
//         }
//       });
//     } catch (e) {
//       debugPrint('line 57 error getting client user: ${e.toString()}');
//       throw Exception(e.toString());
//     }
//     int len = localList.length;
//     debugPrint('line 61: $len');
//     List<int> rnds = [];
//     clientList = localList;
//     clientList.sort((a, b) => a['clientId'].compareTo(b['clientId']));
//     debugPrint('line 45 gen list: $rnds ${clientList.length}');
//     //now hcps
//     List<int> dp = [];
//     List<dynamic> ep = [];
//     for (int i = 0; i < branchIds.length; i++) {
//       lBranchCntIds.add(0);
//       dp.add(0);
//     }
//     for (int i = 0; i < disciplineIds.length; i++) {
//       disciplineCnts.add(dp);
//       hcpFinds.add(ep);
//     }
//     dynamic hcpLocalList = [];
//     try {
//       await FirebaseFirestore.instance
//           .collection("HCProfessional")
//           .where('status', isEqualTo: 'Active')
//           .get()
//           .then((querySnapshot) {
//         for (var docSnapshot in querySnapshot.docs) {
//           var obj = docSnapshot.data();
//           hcpLocalList.add(obj);
//         }
//       });
//     } catch (e) {
//       debugPrint('line 57 error getting client user: ${e.toString()}');
//       throw Exception(e.toString());
//     }
//     debugPrint('line 119: ${hcpLocalList.length}');
//     List<int> branchCnt = [];
//     for (int i = 0; i < branchIds.length; i++) {
//       branchCnt.add(0);
//     }
//     // if (branchIds[0] != 0) {
//     debugPrint('line 131 not 0');
//     for (int i = 0; i < hcpLocalList.length; i++) {
//       dynamic cd = hcpLocalList[i];
//       int idx = listOfBranchIds.indexOf(cd['branchId']);
//       ;
//       int idy = disciplineIds.indexOf(cd['disciplineId']);
//       //   debugPrint('line 136: $idx $idy');
//       if (i < 10) {
//         debugPrint('line 145: $idx, $idy');
//       }
//       if (idx != -1 && idy != -1) {
//         dp = disciplineCnts[idy];
//         ep = hcpFinds[idy];
//         if (dp[idx] >= 5) {
//           continue;
//         }
//         dp[idx] += 1;
//         ep.add(cd);
//         branchCnt[idx] += 1;
//         disciplineCnts[idy] = dp;
//         hcpFinds[idy] = ep;
//         hcpClientList.add(cd);
//       }
//     }
//     hcpLocalList = hcpClientList;
//     debugPrint('line 146: ${hcpLocalList.length}');
//     debugPrint('line 172');
//     debugPrint('line 157: ${hcpClientList.length} ${lBranchCntIds}');
//     debugPrint('line 166: ${disciplineCnts}');
//     dynamic obj = {"clients": clientList, "hcps": hcpFinds};
//     return obj;
//   }
//
//   Future<dynamic> getCurrentWorkingSet(clientUserId) async {
//     debugPrint('line 218 getcurrent workingset');
//     Map<String, dynamic>? workingSet;
//     try {
//       await FirebaseFirestore.instance
//           .collection("TestingWorkingSet")
//           .where('clientUserId', isEqualTo: clientUserId)
//           .get()
//           .then((querySnapshot) {
//         for (var docSnapshot in querySnapshot.docs) {
//           var obj = docSnapshot.data();
//           workingSet = obj;
//         }
//       });
//     } catch (e) {
//       debugPrint('line 57 error getting client user: ${e.toString()}');
//       throw Exception(e.toString());
//     }
//
//     return workingSet;
//   }
//
//   Future<dynamic> saveWorkingSet(dynamic clientUser, String selectedValue,
//       List<String> selectedItems) async {
//     debugPrint('line 219 saveworkigset: ${clientUser}');
//     debugPrint('line 220: ${clientUser['clientUserId']}');
//     try {
//       int i1 = -1;
//       int i2 = -1;
//       int clientUserId = clientUser['clientUserId'];
//       List<dynamic> hcpData = [];
//       for (int i = 0; i < selectedItems.length; i++) {
//         String str = selectedItems[i];
//         debugPrint('line 233: $str');
//         i1 = str.indexOf('-');
//         String sHcpId = str.substring(0, i1).trim();
//         debugPrint('line 246: $i1 $sHcpId');
//         int hcpId = int.parse(sHcpId);
//         i2 = i1 + 1;
//         i1 = str.indexOf('-', i2);
//         String email = str.substring(i2, i1).trim();
//         debugPrint('line 240: $i1 $i2 $email');
//         i2 = i1 + 1;
//         i1 = str.indexOf('-', i2);
//         String pw = str.substring(i2, i1).trim();
//         debugPrint('line 246:$i1 $i2 $pw');
//         i2 = i1 + 1;
//         i1 = str.indexOf('-', i2);
//         String sBranchId = str.substring(i2, i1).trim();
//         debugPrint('line 249: $i1 $i2 $sBranchId');
//         int branchId = int.parse(sBranchId);
//         i2 = i1 + 1;
//         i1 = str.indexOf('-', i2);
//         if (i1 == -1) {
//           i1 = str.length;
//         }
//         String disciplineCode = str.substring(i2, i1).trim();
//         debugPrint('line 257: $i1 $i2 $disciplineCode');
//         dynamic obj = {
//           "hcpId": hcpId,
//           "email": email,
//           "password": pw,
//           "branchId": branchId,
//           "disciplineCode": disciplineCode
//         };
//         hcpData.add(obj);
//       }
//       debugPrint('line 259: ${hcpData.length}');
//       String stc = selectedValue;
//       debugPrint('line 261: $stc');
//       i1 = stc.indexOf('-');
//       String sClientId = stc.substring(0, i1).trim();
//       int clientId = int.parse(sClientId);
//       i2 = i1 + 1;
//       i1 = stc.indexOf('-', i2);
//       String sBranchId = stc.substring(i2, i1).trim();
//       int branchId = int.parse(sBranchId);
//       i2 = i1 + 1;
//       i1 = stc.indexOf('-', i2);
//       if (i1 == -1) {
//         i1 = stc.length;
//       }
//       String clientName = stc.substring(i2, i1).trim();
//       dynamic clientData = {
//         "clientId": clientId,
//         "clientName": clientName,
//         "branchId": branchId
//       };
//       dynamic obj = {
//         "clientUserId": clientUserId,
//         "clientData": clientData,
//         "hcpData": hcpData
//       };
//       debugPrint('line 281 check');
//       await FirebaseFirestore.instance
//           .collection("TestingWorkingSet")
//           .where('clientUserId', isEqualTo: clientUserId)
//           .get()
//           .then((querySnapshot) {
//         for (var docSnapshot in querySnapshot.docs) {
//           String documentId = docSnapshot.id;
//           FirebaseFirestore.instance
//               .collection("TestingWorkingSet")
//               .doc(documentId)
//               .delete();
//         }
//       });
//
//       await FirebaseFirestore.instance
//           .collection('TestingWorkingSet')
//           .doc()
//           .set(obj);
//       Map<String, dynamic>? client;
//       try {
//         await FirebaseFirestore.instance
//             .collection("Client")
//             .where('clientId', isEqualTo: 'clientId')
//             .get()
//             .then((querySnapshot) {
//           for (var docSnapshot in querySnapshot.docs) {
//             var obj = docSnapshot.data();
//             client = obj;
//           }
//         });
//       } catch (e) {
//         debugPrint('line 57 error getting clientr: ${e.toString()}');
//         throw Exception(e.toString());
//       }
//       debugPrint('line 300: $client');
//       return client;
//     } catch (e) {
//       debugPrint('line 289 error $e');
//       throw Exception(e.toString());
//     }
//   }

// void updateClientUser(dynamic clientUser) {
//   state = state.copyWith(clientUser: clientUser);
// }
//
// void updateClientId(int clientId) {
//   state = state.copyWith(clientId: clientId);
// }
//
// void updateEmail(String email) {
//   state = state.copyWith(email: email);
// }
//
// void updateClientIds(List<int> clientIds) {
//   state = state.copyWith(clientIds: clientIds);
// }
//
// void updateFullName(String fullName) {
//   state = state.copyWith(fullName: fullName);
// }
//
// void updateClientUserId(int clientUserId) {
//   state = state.copyWith(clientUserId: clientUserId);
// }
//
// void updateUserRoles(List<String> userRoles) {
//   state = state.copyWith(userRoles: userRoles);
// }
//
// dynamic get fromClientUser {
//   return state.clientUser;
// }
//
// int? get fromClientId {
//   return state.clientId;
// }
//
// String? get fromEmail {
//   return state.email;
// }
//
// String? get fromFullName {
//   return state.fullName;
// }
//
// int? get fromClientUserId {
//   return state.clientUserId;
// }
//
// List<int>? get fromClientIds {
//   return state.clientIds;
// }
//
// List<String>? get fromUserRoles {
//   return state.userRoles;
// }
//}
