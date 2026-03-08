/// Custom business object class which contains properties to hold the detailed
/// information about the order which will be rendered in datagrid.

class HCPClass {
  /// Creates the order class with required details.
  HCPClass(
      this.hcpId,
      this.statusId,
      this.SSN,
      this.fullName,
      this.branchName,
      this.genderCodeDescription,
      this.disciplineName,
      this.workerType,
      this.credsWillWarnDate,
      this.lastWorked);

  /// Id of an order.
  final int hcpId;

  /// status an order.
  final String statusId;

  /// client Name of an order.
  final String SSN;

  final String fullName;

  /// City of an order.
  final String branchName;

  /// Freight of an order.
  final String genderCodeDescription;

  /// Price of an order.
  final String disciplineName;
  final String workerType;
  final String credsWillWarnDate;
  final String lastWorked;

  HCPClass.fromJson(Map<String, dynamic> json)
      : hcpId = json['hcpId'] as int,
        statusId = json['statusId'] as String,
        SSN = json['SSN'] as String,
        fullName = json['fullName'] as String,
        branchName = json['branchName'] as String,
        genderCodeDescription = json['genderCodeDescription'] as String,
        disciplineName = json['disciplineName'] as String,
        workerType = json['workerType'] as String,
        credsWillWarnDate = json['credsWillWarnDate'],
        lastWorked = json['lastWorked'] as String;

  Map<String, dynamic> toJson() => {
        'hcpId': hcpId,
        'statusId': statusId,
        'SSN': SSN,
        'fullName': fullName,
        'branchName': branchName,
        'genderCodeDescription': genderCodeDescription,
        'disciplineName': disciplineName,
        'workerType': workerType,
        'credsWillWarnDate': credsWillWarnDate,
        'lastWorked': lastWorked
//      'payRate': payRate,
      };

  HCPClass copyWith(
      {int? hcpId,
      String? statusId,
      String? SSN,
      String? fullName,
      String? branchName,
      String? genderCodeDescription,
      String? disciplineName,
      String? workerType,
      String? credsWillWarnDate,
      String? lastWorked}) {
    return HCPClass(
        hcpId ?? this.hcpId,
        statusId ?? this.statusId,
        SSN ?? this.SSN,
        fullName ?? this.fullName,
        branchName ?? this.branchName,
        genderCodeDescription ?? this.genderCodeDescription,
        disciplineName ?? this.disciplineName,
        workerType ?? this.workerType,
        credsWillWarnDate ?? this.credsWillWarnDate,
        lastWorked ?? this.lastWorked);
  }

  List<HCPClass> HCPClasses = <HCPClass>[];

  void convertToHCPClasses(List<dynamic> listD) {
    for (int i = 0; i < listD.length; i++) {
      dynamic ld = listD[i];
      HCPClass wkc = HCPClass(
          ld['hcpId'],
          ld['statusId'],
          ld['SSN'],
          ld['fullName'],
          ld['branchName'],
          ld['genderCodeDescription'],
          ld['disciplineName'],
          ld['workerType'],
          ld['credsWillWarnDate'],
          ld['lastWorked'].toString());
      HCPClasses.add(wkc);
    }
  }
}
