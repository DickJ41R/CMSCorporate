class UserModelx {
  final String id;
  final DateTime? createdAt;
  final String name;
  final String avatar;

  UserModelx({required this.id, required this.createdAt, required this.name, required this.avatar});

  factory UserModelx.fromJson(Map<String, dynamic> json) {
  //  if (json == null) return null;
    return UserModelx(
      id: json["id"],
      createdAt:
      json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<UserModelx> fromJsonList(List? list) {
  //  if (list == null) return null;
    return list!.map((item) => UserModelx.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#$id $name';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return createdAt.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModelx model) {
    return id == model.id;
  }

  @override
  String toString() => name;
}