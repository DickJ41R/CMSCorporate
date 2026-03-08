import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:intl/intl.dart';
class Users {
  const Users(
      {required this.active,
      required this.genId,
      required this.email,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.fullName,
      required this.displayName,
      required this.devices,
      required this.roles,
      required this.fcmToken,
      required this.fcmTokens,
      required this.branchIds,
      required this.branchNames,
      required this.ownerId,
      required this.userId,
      required this.password,
      this.dateLastLoggedIn,
      this.loginCounter});

  final bool active;
  final int genId;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String displayName;
  final List<String> devices;
  final List<String> roles;
  final String fcmToken;
  final List<dynamic> fcmTokens;
  final List<dynamic> branchIds;
  final List<String> branchNames;
  final String ownerId;
  final int userId;
  final String password;
  final Timestamp? dateLastLoggedIn;
  final int? loginCounter;

  Map<String, dynamic> toMap() {
    return {
      "active": active,
      "genId": genId,
      "email": email,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "fullName": fullName,
      "displayName": displayName,
      "devices": devices,
      "roles": roles,
      'fcmToken': fcmToken,
      "fcmTokens": fcmTokens,
      "branchIds": branchIds,
      "branchNames": branchNames,
      "ownerId": ownerId,
      "userId": userId,
      'password': password,
      'dateLastLoggedIn': dateLastLoggedIn,
      'loginCounter': loginCounter
    };
  }

//   UserModels.secondary();
//

  static Users convertToUser(dynamic ld) {
    print('line 65 in convertouser');
    List<String> sroles = [];
    for (int i = 0; i < ld['roles'].length; i++) {
      String st = ld['roles'][i] as String;
      sroles.add(st);
    }
    List<String> sbns = [];
    for (int i = 0; i < ld['branchNames'].length; i++) {
      String st = ld['branchNames'][i] as String;
      sbns.add(st);
    }
    Timestamp? tmp;
    if (ld['dateLastLoggedIn'] == null) {
      tmp = Timestamp.fromDate(DateTime.parse('1970-01-01'));
    } else {
      // final DateFormat formatter = DateFormat('yyyy-MM-dd');
      tmp = ld['dateLastLoggedIn'];
    }
    try {
      Users wkc = Users(
          active: ld["active"],
          genId: ld["genId"],
          email: ld["email"],
          username: ld["username"],
          firstName: ld["firstName"],
          lastName: ld["lastName"],
          fullName: ld["fullName"],
          displayName: ld["displayName"],
          devices: ld['devices'],
          roles: sroles,
          fcmToken: ld['fcmToken'],
          fcmTokens: ld["fcmTokens"],
          branchIds: ld["branchIds"],
          branchNames: sbns,
          ownerId: ld["ownerId"],
          userId: ld["userId"],
          password: ld['password'],
          dateLastLoggedIn: tmp,
          loginCounter: ld['loginCounter']);
      return wkc;
    } catch (e) {
      print('line 87 error: ${e.toString()}');
      throw Exception('line 88 error: ${e.toString()}');
    }
  }
}
//   factory UserModels.fromJson(Map<String, dynamic> json) =>
//       UserModels(
//           id: json['id'],
//           email: json['email'],
//           username: json['username'],
//           firstName: json['firstName'],
//           lastName: json['lastName'],
//           displayName: json['displayName'],
//           role: json['role'],
//           fcmToken: json['fcmToken'],
//           isClient: json['isClient'],
//           isHCP: json['isHCP'],
//           isBranch: json['isBranch'],
//           isCMS: json['isCms']
//       );
//
//
//   Map<String, dynamic> toJson() =>
//       {
//         'id' : id,
//         'email': email,
//         'username': username,
//         'firstName': firstName,
//         'lastName': lastName,
//         'displayName': displayName,
//         'role': role,
//         'fcmToken': fcmToken,
//         'isClient': isClient,
//         'isHCP' : isHCP,
//         'isBranch': isBranch,
//         'isCMS': isCMS
//       };
// @override
// bool operator ==(Object o) {
//   if (identical(this, o)) return true;
//
//   return o is User &&
//       o.email == email;
// }
//
// @override
// int get hashCode => email.hashCode;
