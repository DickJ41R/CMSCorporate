
class HCPUserModel {
  //final ObjectId id;
  DateTime? createdAt;
  final String name;
  final String avatar;
  final int userId;
  final String ownerId;
  final int branchId;
  final String username;
  final String email;
  final bool active;
  DateTime? lastLogin;
  final String userTypeString;
  final int hcpId;
  final String firstName;
  final String lastName;
  final String fullName;
  final String telephone;
  final String? extension;
  final String branchName;
  final bool isEmailVerified;
  final String status;
  final String? fcmToken;
  final String displayName;
  final List<String>? role;

  HCPUserModel({
    //required this.id,
    this.createdAt, required this.name, required this.avatar,
    required this.userId,required this.ownerId,required this.branchId,required this.username,required this.email,
    required this.active,this.lastLogin, required this.userTypeString, required this.hcpId,required this.firstName,
    required this.lastName,required this.fullName,required this.telephone, this.extension,required this.branchName,
   required  this.isEmailVerified,required this.status, this.fcmToken,required this.displayName, this.role
  });

  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   //if (json == null) return null;
  //   return UserModel(
  //     id: json["id"],
  //     createdAt:
  //     json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  //     name: json["name"],
  //     avatar: json["avatar"],
  //   );
  // }

  // static List<UserModel> fromJsonList(List list) {
  //  // if (list == null) return null;
  //   return list.map((item) => UserModel.fromJson(item)).toList();
  // }

  ///this method will prevent the override of toString
  String userAsString() {
    return 'name'; //'#$id $name'; have to fixe
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return createdAt.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(HCPUserModel model) {
    return false; // have to fixid == model.id;
  }

  @override
  String toString() => name;
}