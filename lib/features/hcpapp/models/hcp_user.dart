class HCPUser {
  HCPUser(
      {
//  required this.id,  required this.role});
      required this.active,
      required this.genId,
      required this.hcpId,
      required this.email,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.fullName,
      required this.displayName,
      required this.roles,
      required this.fcmToken,
      required this.fcmTokens,
      required this.branchIds,
      required this.branchNames,
      required this.ownerId,
      required this.userId,
      required this.password,
      this.loginCounter});

//  final ObjectId id;
  final bool active;
  final int genId;
  final int hcpId;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String displayName;
  final List<String> roles;
  final String fcmToken;
  final List<Map<String, dynamic>> fcmTokens;
  final List<int> branchIds;
  final List<String> branchNames;
  final String ownerId;
  final int userId;
  final String password;
  final int? loginCounter;
}
