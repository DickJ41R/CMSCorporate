import 'package:cloud_firestore/cloud_firestore.dart';

class HCProfessionalDataModel {
  final int hcpId;
  final String hcpName;
  final int branchId;
  final String branchName;
  final String shiftDateString;
  final String shiftStatus;
  final String shiftCode;
  final String startTime;
  final String endTime;
  final String disciplineName;

  HCProfessionalDataModel(
      {required this.hcpId,
      required this.hcpName,
      required this.branchId,
      required this.branchName,
      required this.shiftDateString,
      required this.shiftStatus,
      required this.shiftCode,
      required this.startTime,
      required this.endTime,
      required this.disciplineName});

  factory HCProfessionalDataModel.fromJson(Map<String, Object?> json) {
    if (json
        case {
          'hcpId': int hcpId,
          'hcpName': String hcpName,
          'branchId': int branchId,
          'branchName': String branchName,
          'shiftDateString': String shiftDateString,
          'shiftStatus': String shiftStatus,
          "shiftCode": String shiftCode,
          'startTime': String startTime,
          'endTime': String endTime,
          'disciplineName': String disciplineName
        }) {
      return HCProfessionalDataModel(
          hcpId: hcpId,
          hcpName: hcpName,
          branchId: branchId,
          branchName: branchName,
          shiftDateString: shiftDateString,
          shiftStatus: shiftStatus,
          shiftCode: shiftCode,
          startTime: startTime,
          endTime: endTime,
          disciplineName: disciplineName);
    } else {
      throw UnsupportedError('Could not convert $json to UserModel.');
    }
  }
  Map<String, Object?> toJson() => {
        'hcpId': hcpId,
        'hcpName': hcpName,
        'branchId': branchId,
        'branchName': branchName,
        'shiftDateString': shiftDateString,
        'shiftStatus': shiftStatus,
        'shiftCode': shiftCode,
        'startTime': startTime,
        'endTime': endTime,
        'disciplineName': disciplineName
      };
}
