import 'package:cloud_firestore/cloud_firestore.dart';

class CMSBranchUser {
  CMSBranchUser(
    this.active,
    this.branchIds,
    this.branchNames,
    this.dateOfLastLogin,
    this.devices,
    this.displayName,
    this.email,
    this.fcmToken,
    this.fcmTokens,
    this.firstName,
    this.fullName,
    this.genId,
    this.isAdministrator,
    this.isEmailVerified,
    this.lastName,
    this.loginCounter,
    this.ownerId,
    this.password,
    this.roles,
    this.status,
    this.statusId,
    this.securityGroupId,
    this.securityGroupName,
    this.telephone,
    this.telephoneExtension,
    this.userId,
    this.username,
    this.userType,
  );
  final bool active;
  final List<dynamic> branchIds;
  final List<dynamic> branchNames;
  final Timestamp dateOfLastLogin;
  final List<dynamic> devices;
  final String displayName;
  final String email;
  final String? fcmToken;
  final List<dynamic> fcmTokens;
  final String firstName;
  final String fullName;
  final int genId;
  final bool isAdministrator;
  final bool isEmailVerified;
  final String lastName;
  final int loginCounter;
  String? ownerId;
  String? password;
  final List<dynamic> roles;
  final String status;
  final String statusId;
  final int securityGroupId;
  final String securityGroupName;
  String? telephone;
  String? telephoneExtension;
  int? userId;
  final String username;
  final String userType;

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};

    col['active'] = active;
    col['branchIds'] = branchIds;
    col['branchNames'] = branchNames;
    col['dateLastLogin'] = dateOfLastLogin;
    col['devices'] = devices;
    col['displayName'] = displayName;
    col['email'] = email;
    col['fcmToken'] = fcmToken;
    col['fcmTokens'] = fcmTokens;
    col['firstName'] = firstName;
    col['fullName'] = fullName;
    col['genId'] = genId;
    col['isAdministrator'] = isAdministrator;
    col['isEmailVerified'] = isEmailVerified;
    col['lastName'] = lastName;
    col['loginCounter'] = loginCounter;
    col['ownerId'] = ownerId;
    col['password'] = password;
    col['roles'] = roles;
    col['status'] = status;
    col['statusId'] = statusId;
    col['securityGroupId'] = securityGroupId;
    col['securityGroupName'] = securityGroupName;
    col['telephone'] = telephone!;
    col['telephoneExtension'] = telephoneExtension!;
    col['userId'] = userId;
    col['username'] = username;
    col['userType'] = userType;

    return col;
  }
}
