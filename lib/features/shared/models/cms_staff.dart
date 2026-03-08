

class CMSStaff {
  const CMSStaff(
    this.userId,
//    this.ownerId,
    this.userName,
    this.email,
    this.securityGroupId,
    this.securityGroupName,
    this.active,
    this.userType,
    this.isAdministrator,
    this.lastLogin,
    this.regId,
    this.clientId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.isEmailVerified,
    this.status
);
    final int userId;
  //  final ObjectId ownerId;
    final String userName;
    final String email;
    final String securityGroupId;
    final String securityGroupName;
    final bool active;
    final List<String> userType;
    final bool isAdministrator;
    final DateTime? lastLogin;
    final int regId;
    final int clientId;
    final String lastName;
    final String firstName;
    final String fullName;
    final bool isEmailVerified;
    final String status;

    Map<String, dynamic> setCollection() {
      Map<String, dynamic> col = {};
      col['cmsId'] = regId;
 //     col['owner_id'] = ownerId;
      col['userName'] = userName;
      col['email'] = email;
      col['securityTypeId'] = securityGroupId;
      col['securityGroupName'] = securityGroupName;
      col['active'] = active;
      col['userType'] = userType;
      col['isAdministrator'] = isAdministrator;
      col['lastLogin'] = lastLogin;
      col['lastName'] = lastName;
      col['firstName'] = firstName;
      col['fullName'] = fullName;
      col['telephoneNumber'] = '';
      col['cmsId'] = regId;
      col['clientId'] = clientId;
      col['isEmailVerified'] = isEmailVerified;
      col['status'] = status;

      return col;
      }
}
