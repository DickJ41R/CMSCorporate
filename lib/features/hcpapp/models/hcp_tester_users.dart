

class TesterUserModel {

  // final ObjectId id;
  final int clientUserId;
  final String username;
  final String email;
  final bool active;
  final int hcpId;
  final String firstName;
  final String lastName;
  final String fullName;
  final List<int>branchIds;
  final List<String>branchNames;
  final List<String>roles;
  final String password;
  final String device;

  TesterUserModel({
    // required this.id,
    required this.clientUserId,required this.username,required this.email,required this.active,
    required this.hcpId,required this.firstName,required this.lastName,required this.fullName,required this.branchIds,
    required this.branchNames,required this.roles,required this.password,required this.device});


}