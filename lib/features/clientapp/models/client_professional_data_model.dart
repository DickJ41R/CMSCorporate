//
import 'package:cloud_firestore/cloud_firestore.dart';

class HCProfessionalDataModel {
  final int hcpId;
  final String hcpName;
  final int clientId;
  final String clientName;
  final String shiftDateString;
  final String shiftStatus;
  final String shiftCode;
  final String startTime;
  final String endTime;
  final String disciplineName;

  HCProfessionalDataModel(
      {required this.hcpId,
        required this.hcpName,
        required this.clientId,
        required this.clientName,
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
    'clientId': int clientId,
    'clientName': String clientName,
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
          clientId: clientId,
          clientName: clientName,
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
    'clientId': clientId,
    'clientName': clientName,
    'shiftDateString': shiftDateString,
    'shiftStatus': shiftStatus,
    'shiftCode': shiftCode,
    'startTime': startTime,
    'endTime': endTime,
    'disciplineName': disciplineName
  };
}
