
class HCPModel {
  final String id;
  DateTime? createdAt;
  final String name;
  final String discipline;

  HCPModel(
      {required this.id, this.createdAt, required this.name, required this.discipline});

  factory HCPModel.fromJson(Map<String, dynamic> json) {
    //if (json == null) return null;
    return HCPModel(
      id: json["id"],
      createdAt:
      json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      discipline: json["discipline"],
    );
  }

  static List<HCPModel> fromJsonList(List list) {
    // if (list == null) return null;
    return list.map((item) => HCPModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String HCProfesionalAsString() {
    return '#$id $name';
  }

  ///this method will prevent the override of toString
  bool hcprofessionalFilterByCreationDate(String filter) {
    return createdAt.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(HCPModel model) {
    return id == model.id;
  }

  @override
  String toString() => name;
}
