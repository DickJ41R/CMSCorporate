import 'package:cloud_firestore/cloud_firestore.dart';

// class FCMToken =
// {
// const FCMToken
// ({
// required this.app,
// required this.aspectRatio
// required this.createdOn,
// required this.phone,
// required this.fcmToken,
// required this.os
// });
// final String app;
// final String aspectRatio;
// final Timestamp createdOn;
// final String this.phone;
// final String fcmToken;
// final String os;
//
// }
class ClientUser {
  const ClientUser(
      {required this.clientId,
      required this.clientUserId,
      required this.active,
      required this.branchIds,
      required this.branchNames,
      required this.devices,
      required this.displayName,
      required this.email,
      required this.fcmToken,
      required this.fcmTokens,
      required this.firstName,
      required this.fullName,
      required this.genId,
      required this.lastName,
      this.loginCounter,
      this.dateOfLastLogin,
      this.ownerId,
      required this.password,
      required this.roles,
      required this.userId,
      required this.username,
      this.securityGroupId,
      this.securityGroupName,
      this.userType,
      this.isAdministrator});
  final int clientId;
  final int clientUserId;
  final bool active;
  final List<dynamic> branchIds;
  final List<dynamic> branchNames;
  final List<dynamic> devices;
  final String displayName;
  final String email;
  final String fcmToken;
  final List<dynamic> fcmTokens;
  final String firstName;
  final String fullName;
  final int genId;
  final String lastName;
  final int? loginCounter;
  final Timestamp? dateOfLastLogin;
  final int? ownerId;
  final String password;
  final List<dynamic> roles;
  final int userId;
  final String username;
  final int? securityGroupId;
  final String? securityGroupName;
  final String? userType;
  final bool? isAdministrator;
}
