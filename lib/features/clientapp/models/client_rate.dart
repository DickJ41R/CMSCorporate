
import 'package:cloud_firestore/cloud_firestore.dart';
class DepartmentInstance {
  DepartmentInstance({required this.departmentId, required this.departmentName,
    this.departmentNumber,});
  final int departmentId;
  final String departmentName;
  String? departmentNumber;

  factory  DepartmentInstance.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final lc = snapshot.data();
    return DepartmentInstance(
        departmentId: lc?['departmentId'],
        departmentName: lc?['departmentName'],
        departmentNumber: lc?['departmentNumber']
    );
  }
  Map<String,dynamic> toFirestore() {
    return {
      'departmentId': departmentId,
      'departmentName': departmentName,
      'departmentNumber': departmentNumber
    };
  }
}
class DisciplineInstance {
  const DisciplineInstance({
    required this.disciplineId, required this.disciplineName});

  final int disciplineId;
  final String disciplineName;

  factory  DisciplineInstance.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final lc = snapshot.data();
    return DisciplineInstance(
        disciplineId: lc?['disciplineId'],
        disciplineName: lc?['disciplineName'],
    );
  }
  Map<String,dynamic> toFirestore() {
    return {
      'disciplineId': disciplineId,
      'disciplineName': disciplineName
    };
  }
}
class RateDetailInstance {

  RateDetailInstance({required this.rateId,required this.shiftCodeCodeId,required this.shiftCode,
    required this.shiftCodeDescription,required this.calcType,required this.margin,required this.marginWE,
    required this.payRate,required this.payRateWE,required this.billRate,required this.billRateWE,
    this.startTime,this.endTime,required this.meals});

  final int rateId;
  final int shiftCodeCodeId;
  final String shiftCode;
  final String shiftCodeDescription;
  final String calcType;
  final double margin;
  final double marginWE;
  final double payRate;
  final double payRateWE;
  final double billRate;
  final double billRateWE;
  String? startTime;
  String? endTime;
  final int meals;

  factory  RateDetailInstance.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final lc = snapshot.data();
    return RateDetailInstance(
      rateId: lc?['rateId'],
     shiftCodeCodeId: lc?['shiftCodeCodeId'],
     shiftCode: lc?['shiftCode'],
     shiftCodeDescription: lc?['shiftCodeDescription'],
     calcType: lc?['calcType'],
     margin: lc?['margin'],
     marginWE: lc?['marginWE'],
     payRate: lc?['payRate'],
     payRateWE: lc?['payRateWE'],
     billRate: lc?['billRate'],
     billRateWE: lc?['billRateWE'],
     startTime: lc?['startTime'],
     endTime: lc?['endtime'],
     meals: lc?['meals']
    );
  }
  Map<String,dynamic> toFirestore() {
    return {
      'rateId': rateId,
      'shiftCodeCodeId' : shiftCodeCodeId,
      'shiftCode': shiftCode,
      'shiftCodeDescription' : shiftCodeDescription,
      'calcType': calcType,
      'margin': margin,
      'marginWE': marginWE,
      'payRate': payRate,
      'payRateWE': payRateWE,
      'billRate': billRate,
      'billRateWE': billRateWE,
      'startTime': startTime,
      'endTime': endTime,
      'meals' : meals
    };
  }
}

class RateInstance {
  RateInstance({required this.rateGroupId,required this.rateId,required this.expirationDate,this.overridePayModifiers,
    this.payOT,this.payOTPlus,this.payDbl,this.payDblPlus,this.payHoliday,this.payHolidayPlus,this.payMax,this.payMaxPlus,
    this.overrideBilModifiers,this.billOT,this.billOTPlus,this.billDbl,this.billDblPlus,this.billHoliday,
    this.billHolidayPlus,this.billMax,this.billMaxPlus,required this.rateDetails});

  final int rateGroupId;
  final int rateId;
  final Timestamp expirationDate;
  bool? overridePayModifiers;
  final double? payOT;
  final double? payOTPlus;
  final double? payDbl;
  final double? payDblPlus;
  final double? payHoliday;
  final double? payHolidayPlus;
  final double? payMax;
  final double? payMaxPlus;
  bool? overrideBilModifiers;
  final double? billOT;
  final double? billOTPlus;
  final double? billDbl;
  final double? billDblPlus;
  final double? billHoliday;
  final double? billHolidayPlus;
  final double? billMax;
  final double? billMaxPlus;
  final List<RateDetailInstance> rateDetails;
}
class ClientRate {

  ClientRate(
      {required this.rateGroupId, required this.rateType, required this.branchId, required this.branchName,
        required this.disciplineId, required this.disciplineName, required this.clientId,
        required this.clientName, required this.nationalClient, this.hcpId, required this.hcpName,
        required this.burden, this.orderId, required this.contract, required this.workersCompCodeId,
        required this.workersCompType, this.quoteId, required this.rateGroupTypeCodeId, required this.rateGroupTypeName,
        required this.rateGroupTypeValue, this.contractTemplateName, required this.overridePayModifiers, this.payOT, this.payOTPlus,
        this.payDbl, this.payDblPlus, this.payHoliday, this.payHolidayPlus, this.payMax, this.payMaxPlus, required this.overrideBillModifiers,
        this.billOT, this.billOTPlus, this.billDbl, this.billDblPlus, this.billHoliday, this.billHolidayPlus, this.billMax, this.billMaxPlus,
        required this.departments, required this.disciplines, required this.rates,
        this.expirationDate, this.lastModifiedDate});

  final int rateGroupId;
  final String rateType;
  final int branchId;
  final String branchName;
  final int disciplineId;
  final String disciplineName;
  final int clientId;
  final String clientName;
  final bool nationalClient;
  int? hcpId;
  String? hcpName;
  final double burden;
  int? orderId;
  final bool contract;
  final int workersCompCodeId;
  final String workersCompType;
  final String? quoteId;
  final int rateGroupTypeCodeId;
  final String rateGroupTypeName;
  final String rateGroupTypeValue;
  String? contractTemplateName;
  final bool overridePayModifiers;
  final double? payOT;
  final double? payOTPlus;
  final double? payDbl;
  final double? payDblPlus;
  final double? payHoliday;
  final double? payHolidayPlus;
  final double? payMax;
  final double? payMaxPlus;
  final bool overrideBillModifiers;
  double? billOT;
  double? billOTPlus;
  double? billDbl;
  double? billDblPlus;
  double? billHoliday;
  double? billHolidayPlus;
  double? billMax;
  double? billMaxPlus;
  final List<DepartmentInstance>? departments;
  final List<DisciplineInstance>? disciplines;
  final List<RateInstance> rates;
  Timestamp? expirationDate;
  Timestamp? lastModifiedDate;

  factory  ClientRate.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final lc = snapshot.data();
    return ClientRate(
        rateGroupId: lc?['rateGroupId'],
        rateType: lc?['rateType'],
        branchId: lc?['branchId'],
        branchName: lc?['branchName'],
        disciplineId: lc?['disciplineId'],
        disciplineName: lc?['disciplineName'],
        clientId: lc?['clientId'],
        clientName: lc?['clientName'],
        nationalClient: lc?['naionalClient'],
        hcpId: lc?['hcpId'],
        hcpName: lc?['hcpName'],
        burden: lc?['burden'],
        orderId: lc?['orderId'],
        contract: lc?['contract'],
        workersCompCodeId: lc?['workersCompCodeId'],
        workersCompType: lc?['workersCompType'],
        quoteId: lc?['quoteId'],
        rateGroupTypeCodeId: lc?['rateGroupTypeCodeId'],
        rateGroupTypeName: lc?['rateGroupTypeName'],
        rateGroupTypeValue: lc?['rateGroupTypeValue'],
        contractTemplateName: lc?['contractTemplateName'],
        overridePayModifiers: lc?[' overridePayModifiers'],
        payOT: lc?['payOT'],
        payOTPlus: lc?['payOTPlus'],
        payDbl: lc?['payDbl'],
        payDblPlus: lc?['payDblPlus'],
        payHoliday: lc?['payHoliday'],
        payHolidayPlus: lc?['payHolidayPlus'],
        payMax: lc?['payMax'],
        payMaxPlus: lc?['payMaxPlus'],
        overrideBillModifiers: lc?['overrideBillModifiers'],
        billOT: lc?['billOT'],
        billOTPlus: lc?['billOTPlus'],
        billDbl: lc?['billDbl'],
        billDblPlus: lc?['billDblPlus'],
        billHoliday: lc?['billHoliday'],
        billHolidayPlus: lc?['billHolidayPlus'],
        billMax: lc?['billMax'],
        billMaxPlus: lc?['billMaxPlus'],
        departments: lc?['departments'],
        disciplines: lc?['disciplines'],
        rates: lc?['rates'],
        expirationDate: lc?['expirationDate'],
        lastModifiedDate: lc?['lastModifiedDate']
    );
  }
  Map<String,dynamic> toFirestore() {
    return {
      'rateGroupId': rateGroupId,
      'rateType': rateType,
      'branchId': branchId,
      'branchName': branchName,
      'disciplineId': disciplineId,
      'disciplineName': disciplineName,
      'clientId': clientId,
      'clientName': clientName,
      'nationalClient': nationalClient,
      'hcpId': hcpId,
      'hcpName': hcpName,
      'burden': burden,
      'orderId': orderId,
      'contract': contract,
      'workersCompCodeId': workersCompCodeId,
      'workersCompType': workersCompType,
      'quoteId': quoteId,
      'rateGroupTypeCodeId': rateGroupTypeCodeId,
      'rateGroupTypeName': rateGroupTypeName,
      'rateGroupTypeValue': rateGroupTypeValue,
      'contractTemplateName': contractTemplateName,
      'overridePayModifiers': overridePayModifiers,
      'payOT': payOT,
      'payOTPlus': payOTPlus,
      'payDbl': payDbl,
      'payDblPlus': payDblPlus,
      'payHoliday': payHoliday,
      'payHolidayPlus': payHolidayPlus,
      'payMax': payMax,
      'payMaxPlus': payMaxPlus,
      'overrideBillModifiers': overrideBillModifiers,
      'billOT': billOT,
      'billOTPlus': billOTPlus,
      'billDbl': billDbl,
      'billDblPlus': billDblPlus,
      'billHoliday': billHoliday,
      'billHolidayPlus': billHolidayPlus,
      'billMax': billMax,
      'billMaxPlus': billMaxPlus,
      'departments': departments,
      'disciplines': disciplines,
      'rates': rates,
      'expirationDate': expirationDate,
      'lastModifiedDate': lastModifiedDate
    };
  }
  }

