import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialRequirementsObject {
  const SpecialRequirementsObject({
    required this.specialRequirements,
    required this.scheduleNotes,
    required this.addressLine1,
    required this.addressLine2,
    required this.zipCode,
    required this.shiftApprovalNote,
    required this.shiftAcceptedActionDate,
    required this.shiftConfirmedActionDate,
    required this.shiftApprovedBy,
    required this.shiftApprovedActionDate,
    required this.shiftCancelledActionDate,
    required this.shiftCancelledById,
    required this.shiftCancelledByName,
    required this.shiftCancelledNote,
  });

  final String? specialRequirements;
  final String? scheduleNotes;
  final String? addressLine1;
  final String? addressLine2;
  final String? zipCode;
  final String? shiftApprovalNote;
  final Timestamp? shiftAcceptedActionDate;
  final Timestamp? shiftConfirmedActionDate;
  final Timestamp? shiftApprovedBy;
  final Timestamp? shiftApprovedActionDate;
  final Timestamp? shiftCancelledActionDate;
  final int? shiftCancelledById;
  final String? shiftCancelledByName;
  final String? shiftCancelledNote;

  factory SpecialRequirementsObject.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return SpecialRequirementsObject(
        specialRequirements: data?['specialRequirements'],
        scheduleNotes: data?['scheduleNotes'],
        addressLine1: data?['addressLine1'],
        addressLine2: data?['addressLine2'],
        zipCode: data?['zipCode'],
        shiftApprovalNote: data?['shiftApprovalNote'],
        shiftAcceptedActionDate: data?['shiftAcceptedActionDate'],
        shiftConfirmedActionDate: data?['shiftConfirmedActionDate'],
        shiftApprovedBy: data?['shiftApprovedBy'],
        shiftApprovedActionDate: data?['shiftApprovedActionDate'],
        shiftCancelledActionDate: data?['shiftCancelledActionDate'],
        shiftCancelledById: data?['shiftCancelledById:'],
        shiftCancelledByName: data?['shiftCancelledByName'],
        shiftCancelledNote: data?['shiftCancelledNote']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
     'specialRequirements': specialRequirements,
      'scheduleNotes': scheduleNotes,
      'addressLine1': addressLine1,
      'address:ome2': addressLine2,
      'zipCode': zipCode,
      'shiftApprovalNote': shiftApprovalNote,
      'shiftAcceptedActionDate': shiftAcceptedActionDate,
      'shiftConfirmedActionDate': shiftConfirmedActionDate,
      'shiftApprovedBy,': shiftApprovedBy,
      'shiftApprovedActionDate': shiftApprovedActionDate,
      'shiftCancelledActionDate': shiftCancelledActionDate,
      'shiftCancelledById': shiftCancelledById,
      'shiftCancelledByName': shiftCancelledByName,
      'shiftCancelledNote': shiftCancelledNote,
    };
  }
}

class ClientWorkOrderCampaign {
  const ClientWorkOrderCampaign({
      required this.id,
      required this.clientId,
      required this.clientName,
      required this.departmentId,
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
      required this.hcpLatitude,
      required this.hcpLongitude,
      required this.hcpState,
      required this.hcpName,
      required this.orderTypeCodeId,
      required this.charge,
      required this.workersCompCodeId,
      required this.workersCompType,
      required this.rateGroupTypeCodeId,
      required this.rateGroupTypeName,
      required this.rateGroupTypeValue,
      required this.orientation,
      required this.clientCity,
      required this.usePremiumRate,
      required this.premiumRate,
      required this.date,
      required this.shiftAccepted,
      required this.shiftConfirmed,
      required this.shiftApproved,
      required this.shiftStatus,
      required this.shiftStatusDate,
      required this.shiftCancelled,
      required this.shiftDate,
      required this.weekend,
      required this.holiday,
      required this.dayValue,
      required this.rateType,
      required this.overridePayModifier,
      required this.overrideRates,
      required this.overrideBillModifiers,
      required this.rateGroupId,
      required this.rateId,
      required this.shiftCode,
      required this.shiftCodeDescription,
      required this.startTime,
      required this.endTime,
      required this.meals,
      required this.calcType,
      required this.shiftTime,
      required this.hours,
      required this.decimalHours,
      required this.payRate,
      required this.payRateWE,
      required this.shiftCount,
      required this.messageFrequency,
      required this.shiftId,
      required this.specialRequirements});

  final String id;
  final int clientId;
  final String clientName;
  final int departmentId;
  final String departmentName;
  final int schedulerId;
  final String schedulerName;
  final int branchId;
  final String branchName;
  final String disciplineCodes;
  final String disciplineIds;
  final double latitude;
  final double longitude;
  final String state;
  final int hcpId;
  final double hcpLatitude;
  final double hcpLongitude;
  final String? hcpState;
  final String? hcpName;
  final int orderTypeCodeId;
  final bool charge;
  final int workersCompCodeId;
  final String? workersCompType;
  final int rateGroupTypeCodeId;
  final String? rateGroupTypeName;
  final String? rateGroupTypeValue;
  final bool orientation;
  final String? clientCity;
  final bool usePremiumRate;
  final double premiumRate;
  final DateTime date;
  final bool shiftAccepted;
  final bool shiftConfirmed;
  final bool shiftApproved;
  final String? shiftStatus;
  final Timestamp? shiftStatusDate;
  final bool shiftCancelled;
  final Timestamp? shiftDate;
  final bool weekend;
  final bool holiday;
  final String? dayValue;
  final String? rateType;
  final bool overridePayModifier;
  final bool overrideRates;
  final bool overrideBillModifiers;
  final int rateGroupId;
  final int rateId;
  final String? shiftCode;
  final String? shiftCodeDescription;
  final String? startTime;
  final String? endTime;
  final int meals;
  final String? calcType;
  final String? shiftTime;
  final String? hours;
  final double decimalHours;
  final double payRate;
  final double payRateWE;
  final int shiftCount;
  final String messageFrequency;
  final int shiftId;
  final SpecialRequirementsObject specialRequirements;

  factory ClientWorkOrderCampaign.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return ClientWorkOrderCampaign(
        id: data?["id"],
        clientId: data?['clientId'],
        clientName: data?['clientName'],
        departmentId: data?['departmentId'],
        departmentName: data?['deparmentName'],
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
        hcpLatitude: data?['hcpLatitude'],
        hcpLongitude: data?['hcpLongitude'],
        hcpState: data?['hcpState'],
        hcpName: data?['hcpName'],
        orderTypeCodeId: data?['orderTypeCodeId'],
        charge: data?['charge'],
        workersCompCodeId: data?['workersCompCodedId'],
        workersCompType: data?['workersCompType'],
        rateGroupTypeCodeId: data?['rateGroupTypeCodeId'],
        rateGroupTypeName: data?['rateGroupTypeName'],
        rateGroupTypeValue: data?['rateGroupTypeValue'],
        orientation: data?['orientation'],
        clientCity: data?['clientCity'],
        usePremiumRate: data?['usePremiumRate'],
        premiumRate: data?['premiumRate'],
        date: data?['Date'],
        shiftAccepted: data?['shiftAccepted:'],
        shiftConfirmed: data?['shiftConfirmed'],
        shiftApproved: data?['shiftApproved'],
        shiftStatus: data?['shiftStatus'],
        shiftStatusDate: data?['shiftStatusDate'],
        shiftCancelled: data?['shiftCancelled:'],
        shiftDate: data?['shiftDate'],
        weekend: data?['weekend'],
        holiday: data?['holiday'],
        dayValue: data?['dayValue'],
        rateType: data?['rateType'],
        overridePayModifier: data?['overridePayModifier'],
        overrideRates: data?['overrideRates'],
        overrideBillModifiers: data?['overrideBillModifiers'],
        rateGroupId: data?['rateGroupId'],
        rateId: data?['reateId'],
        shiftCode: data?['shiftCode'],
        shiftCodeDescription: data?['shiftDescription'],
        startTime: data?['startTime'],
        endTime: data?['endTime'],
        meals: data?['mea;s'],
        calcType: data?['calcTy[e'],
        shiftTime: data?['shiftTime'],
        hours: data?['hours'],
        decimalHours: data?['decimalHours'],
        payRate: data?['payRate'],
        payRateWE: data?['payRateWE'],
        shiftCount: data?['shiftCount'],
        messageFrequency: data?['messageFrequency'],
        shiftId: data?['shiftId'],
        specialRequirements: data?['specialRequirements']
    );
  }
  Map<String,dynamic> toFirestore() {
    return {
      'id': id,
    'clientId': clientId,
    'clientName': clientName,
    'departmentId': departmentId,
    'departmentName': departmentName,
    'schedulerId': schedulerId,
    'branchId': branchId,
    'branchName': branchName,
    'disciplineCodes': disciplineCodes,
    'disciplineIds': disciplineIds,
    'latitude': latitude,
    'longitude': longitude,
    'state': state,
    'hcpId': hcpId,
    'hcpLatitude': hcpLatitude,
    'hcpLongitude': hcpLongitude,
    'hcpState': hcpState,
    'hcpName': hcpName,
    'orderTypeCodeId': orderTypeCodeId,
    'charge': charge,
    'workersCompCodeId': workersCompCodeId,
    'workersCompType': workersCompType,
    'rateGroupTypeCodeId': rateGroupTypeCodeId,
    'rateGroupTypeName': rateGroupTypeName,
    'rateGroupTypeValue': rateGroupTypeValue,
    'orientation': orientation,
    'clientCity': clientCity,
    'usePremiumRate': usePremiumRate,
    'premiumRate': premiumRate,
    'date': date,
    'shiftAccepted': shiftAccepted,
    'shiftConfirmed': shiftConfirmed,
    'shiftApproved': shiftApproved,
    'shiftStatus': shiftStatus,
    'shiftStatusDate': shiftStatusDate,
    'shiftCancelled': shiftCancelled,
    'shiftDate': shiftDate,
    'weekend': weekend,
    'holiday': holiday,
    'dayValue': dayValue,
    'rateType': rateType,
    'overridePayModifier': overridePayModifier,
    'overrideRates': overrideRates,
    'overrideBillModifiers': overrideBillModifiers,
    'rateGroupId': rateGroupId,
    'rateId': rateId,
    'shiftCode': shiftCode,
    'shiftCodeDescription': shiftCodeDescription,
    'startTime': startTime,
    'endTime,': endTime,
    'meals': meals,
    'calcTy;e': calcType,
    'shiftTime': shiftTime,
    'hours': hours,
    'decimalHours': decimalHours,
    'payRate': payRate,
    'payRateWE': payRateWE,
    'shiftCount': shiftCount,
    'messageFrequency': messageFrequency,
    'shiftId': shiftId,
    'specialRequirements': specialRequirements

    };
  }

    }
