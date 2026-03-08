import 'package:cloud_firestore/cloud_firestore.dart';

class CMSUser {
  const CMSUser(
      {required this.primaryBranchId,
      required this.primaryBranchName,
      required this.cmsUserId,
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
      required this.lastName,
      this.loginCounter,
      this.dateOfLastLogin,
      this.ownerId,
      required this.password,
      required this.roles,
      required this.userId,
      required this.username});

  final int primaryBranchId;
  final String primaryBranchName;
  final int cmsUserId;
  final bool active;
  final List<int> branchIds;
  final List<String> branchNames;
  final List<String> devices;
  final String displayName;
  final String email;
  final String fcmToken;
  final List<Map<String, dynamic>> fcmTokens;
  final String firstName;
  final String fullName;
  final String lastName;
  final int? loginCounter;
  final Timestamp? dateOfLastLogin;
  final int? ownerId;
  final String password;
  final List<String> roles;
  final int userId;
  final String username;
}
