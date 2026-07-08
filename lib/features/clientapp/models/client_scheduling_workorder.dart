import 'package:cms_web/features/workorderapp/models/cms_workorder_date.dart';
import 'package:cms_web/features/shared/models/cms_special_requirement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientSchedulingWorkOrder {
  ClientSchedulingWorkOrder(
      {required this.id,
      required this.clientId,
      required this.clientName,
      required this.departmentId,
      required this.departmentNumber,
      required this.departmentName,
      required this.schedulerId,
      required this.schedulerName,
      required this.branchId,
      required this.branchName,
      required this.disciplineCodes,
      required this.disciplineIds,
      required this.latitude,
      required this.longitude,
      required this.state,
      required this.hcpId,
      required this.hcpName,
      required this.orderTypeCodeId,
      required this.charge,
      required this.workersCompCodeId,
      required this.workersCompType,
      required this.rateGroupTypeCodeId,
      required this.rateGroupTypeName,
      required this.rateGroupTypeValue,
      required this.specialRequirements,
      required this.pushNotificationsFrequencyRate,
      required this.clientFCMToken,
      required this.dates});

  final String id;
  final int clientId;
  final String clientName;
  final int departmentId;
  final String departmentNumber;
  final String departmentName;
  final int schedulerId;
  final String schedulerName;
  final int branchId;
  final String branchName;
  final List<String> disciplineCodes;
  final List<int> disciplineIds;
  final double latitude;
  final double longitude;
  final String state;
  final int hcpId;
  final String hcpName;
  final int orderTypeCodeId;
  final bool charge;
  final int workersCompCodeId;
  final int workersCompType;
  final int rateGroupTypeCodeId;
  final String rateGroupTypeName;
  final String rateGroupTypeValue;
  final CMSSpecialRequirement specialRequirements;
  final String pushNotificationsFrequencyRate;
  final String clientFCMToken;
  final List<CMSWorkorderDate> dates;

  factory ClientSchedulingWorkOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ClientSchedulingWorkOrder(
        id: data?["id"],
        clientId: data?["clientID"],
        clientName: data?['clientName'],
        departmentId: data?['departmentId'],
        departmentNumber: data?["departmentNumber"],
        departmentName: data?['departmentName'],
        schedulerId: data?['schedulerId'],
        schedulerName: data?['schedulerName'],
        branchId: data?['branchId'],
        branchName: data?['branchName'],
        disciplineCodes: data?['disciplineCodes'],
        disciplineIds: data?['disciplineIds'],
        latitude: data?['latitude'],
        longitude: data?['longitude'],
        state: data?['state'],
        hcpId: data?['hcpId'],
        hcpName: data?['hcpName'],
        orderTypeCodeId: data?['orderTypeCodeId'],
        charge: data?['charge'],
        workersCompCodeId: data?['orkersCompCodeId'],
        workersCompType: data?['workersCompType'],
        rateGroupTypeCodeId: data?['rateGroupTypeCodeId'],
        rateGroupTypeName: data?['rateGroupTypeName'],
        rateGroupTypeValue: data?['rateGroupTypeValue'],
        specialRequirements: data?['specialRequirements'],
        pushNotificationsFrequencyRate: data?['pushNotificationsFrequencyRate'],
        clientFCMToken: data?['clientFCMToken'],
        dates: data?['rates']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'departmentId': departmentId,
      'departmentNumber': departmentNumber,
      'departmentName': departmentName,
      'schedulerId': schedulerId,
      'schedulerName': schedulerName,
      'branchId': branchId,
      'branchName': branchName,
      'disciplineCodes': disciplineCodes,
      'disciplineIds': disciplineIds,
      'latitude': latitude,
      'longitude': longitude,
      'state': state,
      'hcpId': hcpId,
      'hcpName': hcpName,
      'orderTypeCodeId': orderTypeCodeId,
      'charge': charge,
      'workersCompCodeId': workersCompCodeId,
      'workersCompType': workersCompType,
      'rateGroupTypeCodeId': rateGroupTypeCodeId,
      'rateGroupTypeName': rateGroupTypeName,
      'rateGroupTypeValue': rateGroupTypeValue,
      'specialRequirements': specialRequirements,
      'pushNotificationsFrequencyRate': pushNotificationsFrequencyRate,
      'clientFCMToken': clientFCMToken,
      'dates': dates
    };
  }
}
