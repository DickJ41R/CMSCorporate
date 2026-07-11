import 'package:cloud_firestore/cloud_firestore.dart';


class Date {

  Date({
    required this.departmentId,
    required this.departmentName,
    required this.departmentNumber,
    required this.disciplineCodes,
    required this.rates,
    required this.shiftDateInfo,
  }
  );

  final int departmentId;
  final String departmentName;
  final String departmentNumber;
  final int disciplineCodes;
  final List<Rate>rates;
  List<ShiftDateInfo>shiftDateInfo;


}
class Rate {

  Rate({
    required this.billDblPlusRate,
    required this.billDblRate,
    required this.billHolidayPlusRate,
    required this.billHolidayRate,
    required this.billMaxPlusRate,
    required this.billMaxRate,
    required this.billOTPlusRate,
    required this.billOTRate,
    required this.branchId,
    required this.branchName,
    required this.clientId,
    required this.clientName,
    required this.clientUserId,
    required this.disciplineId,
    required this.disciplineName,
    required this.overrideBillModifiers,
    required this.overridePayModifiers,
    required this.payDblPlusRate,
    required this.payDblRate,
    required this.payHolidayPlusRate,
    required this.payHolidayRate,
    required this.payMaxPlusRate,
    required this.payMaxRate,
    required this.payOTPlusRate,
    required this.payOTRate,
    required this.rateGroupId,
    required this.rateId,
    required this.scheduledRateDetails,
    required this.rateDetails,
  }
  );

  final double billDblPlusRate;
  final double billDblRate;
  final double billHolidayPlusRate;
  final double billHolidayRate;
  final double billMaxPlusRate;
  final double billMaxRate;
  final double billOTPlusRate;
  final double billOTRate;
  final int branchId;
  final String branchName;
  final int clientId;
  final String clientName;
  final int clientUserId;
  final int disciplineId;
  final String disciplineName;
  final bool overrideBillModifiers;
  final bool overridePayModifiers;
  final double payDblPlusRate;
  final double payDblRate;
  final double payHolidayPlusRate;
  final double payHolidayRate;
  final double payMaxPlusRate;
  final double payMaxRate;
  final double payOTPlusRate;
  final double payOTRate;
  final int rateGroupId;
  final int rateId;
  final String? scheduledRateDetails;
  List<RateDetail>rateDetails;

}

class RateDetail {

  RateDetail({
    required this.billRate,
    required this.billRateWE,
    required this.calcType,
    required this.endTime,
    required this.hour,
    required this.hours,
    required this.isAHoliday,
    required this.isAWeekend,
    required this.margin,
    required this.marginWE,
    required this.meals,
    required this.payRate,
    required this.payRateWE,
    required this.shiftCode,
    required this.shiftCodeCodeId,
    required this.shiftCodeDesc,
    required this.shiftCount,
    required this.shiftDate,
    required this.startTime,
  }
  );

  final double billRate;
  final double billRateWE;
  final String calcType;
  final String endTime;
  final String hour;
  final String hours;
  final bool isAHoliday;
  final bool isAWeekend;
  final double margin;
  final double marginWE;
  final int meals;
  final double payRate;
  final double payRateWE;
  final String shiftCode;
  final int shiftCodeCodeId;
  final String shiftCodeDesc;
  final int shiftCount;
  final Timestamp shiftDate;
  final String startTime;

}

class ShiftDateInfo {

  ShiftDateInfo({
    required this.createdDate,
    required this.dayValue,
    required this.endTime,
    required this.holiday,
    required this.indexValue,
    required this.margin,
    required this.marginWE,
    required this.overrideBillModifiers,
    required this.overridePayModifiers,
    required this.payOTRate,
    required this.rateType,
    required this.shiftCode,
    required this.shiftCount,
    required this.shiftDate,
    required this.shiftSequence,
    required this.startTime,
    required this.statusId,
    required this.weekend,
  }
  );

  final Timestamp createdDate;
  final int dayValue;
  final String endTime;
  final bool holiday;
  final bool indexValue;
  final double margin;
  final double marginWE;
  final bool overrideBillModifiers;
  final bool overridePayModifiers;
  final double? payOTRate;
  final String rateType;
  final String shiftCode;
  final int shiftCount;
  final Timestamp shiftDate;
  final int shiftSequence;
  final String startTime;
  final String statusId;
  final bool weekend;

}


class WorkOrder {

  WorkOrder({
    required this.addressLine1,
    required this.addressLine2,
    required this.agencyCancelCredit,
    required this.agencyCancelLimit,
    required this.asmWorkOrderId,
    required this.billDblPlusRate,
    required this.billDblRate,
    required this.billHolidayPlusRate,
    required this.billHolidayRate,
    required this.billMaxPlusRate,
    required this.billMaxRate,
    required this.billOTPlusRate,
    required this.billOTRate,
    required this.bookShift,
    required this.branchId,
    required this.branchName,
    required this.burden,
    required this.canceledBy,
    required this.charge,
    required this.clientCity,
    required this.clientFCMToken,
    required this.clientFcmTokens,
    required this.clientHCPWorkOrderId,
    required this.clientId,
    required this.clientName,
    required this.clientState,
    required this.clientUserEmail,
    required this.clientUserId,
    required this.contract,
    required this.contractTemplateName,
    required this.createdDate,
    required this.dates,
    required this.departmentId,
    required this.departmentName,
    required this.departmentNumber,
    required this.disciplineCodes,
    required this.disciplineIds,
    required this.disciplineName,
    required this.disciplineNames,
    required this.email,
    required this.facilityCancelCharge,
    required this.facilityCancelLimit,
    required this.flagShowPushNotifications,
    required this.hcpFcmTokens,
    required this.hcpId,
    required this.hcpName,
    required this.indexValue,
    required this.isGPOClient,
    required this.latitude,
    required this.longitude,
    required this.orderId,
    required this.orderTypeOrderId,
    required this.orientation,
    required this.overrideBillModifiers,
    required this.overridePayModifiers,
    required this.payDblPlusRate,
    required this.payDblRate,
    required this.payHolidayPlusRate,
    required this.payHolidayRate,
    required this.payMaxPlusRate,
    required this.payMaxRate,
    required this.payOTPlusRate,
    required this.payOTRate,
    required this.premiumRate,
    required this.pushNotificationFrequencyRate,
    required this.quoteId,
    required this.rateGroupId,
    required this.rateGroupTypeCodeId,
    required this.rateGroupTypeName,
    required this.rateGroupTypeValue,
    required this.rateType,
    required this.rateTypeCodeId,
    required this.scheduleNotes,
    required this.schedulerId,
    required this.schedulerName,
    required this.shiftApprovalNote,
    required this.shiftCanceled,
    required this.shiftCanceledActionDate,
    required this.shiftCanceledById,
    required this.shiftCanceledByName,
    required this.shiftCanceledNote,
    required this.shiftCount,
    required this.shiftStatus,
    required this.shiftStatusDate,
    required this.specialRequirements,
    required this.state,
    required this.statusId,
    required this.usePremiumRate,
    required this.userId,
    required this.uuid,
    required this.weekStartDay,
    required this.woWorkOrderId,
    required this.workOrderId,
    required this.workOrderIdUuid,
    required this.workersCompCodeId,
    required this.workersCompType,
    required this.zipCode,
  }
  );

  final String addressLine1;
  final String? addressLine2;
  final String? agencyCancelCredit;
  final double agencyCancelLimit;
  final int asmWorkOrderId;
  final double billDblPlusRate;
  final double? billDblRate;
  final double billHolidayPlusRate;
  final double billHolidayRate;
  final double billMaxPlusRate;
  final double billMaxRate;
  final double billOTPlusRate;
  final double billOTRate;
  final bool bookShift;
  final int branchId;
  final String branchName;
  final String? burden;
  final String? canceledBy;
  final bool charge;
  final String clientCity;
  final String clientFCMToken;
  final List<String>?clientFcmTokens;
  final String clientHCPWorkOrderId;
  final int clientId;
  final String clientName;
  final String clientState;
  final String? clientUserEmail;
  final int clientUserId;
  final String? contract;
  final String? contractTemplateName;
  final Timestamp createdDate;
  final List<Date>dates;
  final int departmentId;
  final String departmentName;
  final String departmentNumber;
  final int disciplineCodes;
  final List<int> disciplineIds;
  final String disciplineName;
  final List<String>disciplineNames;
  final String email;
  final double? facilityCancelCharge;
  final List<String>?facilityCancelLimit;
  final bool flagShowPushNotifications;
  final List<String>hcpFcmTokens;
  final int? hcpId;
  final String? hcpName;
  final bool indexValue;
  final bool isGPOClient;
  final double latitude;
  final double longitude;
  final int orderId;
  final int? orderTypeOrderId;
  final bool orientation;
  final bool overrideBillModifiers;
  final bool overridePayModifiers;
  final double payDblPlusRate;
  final double payDblRate;
  final double payHolidayPlusRate;
  final double payHolidayRate;
  final double payMaxPlusRate;
  final double payMaxRate;
  final double payOTPlusRate;
  final double payOTRate;
  final double premiumRate;
  final String pushNotificationFrequencyRate;
  final String? quoteId;
  final int rateGroupId;
  final int? rateGroupTypeCodeId;
  final String? rateGroupTypeName;
  final String? rateGroupTypeValue;
  final String rateType;
  final int rateTypeCodeId;
  final String? scheduleNotes;
  final String? schedulerId;
  final String?schedulerName;
  final String? shiftApprovalNote;
  final bool shiftCanceled;
  final Timestamp? shiftCanceledActionDate;
  final int? shiftCanceledById;
  final String? shiftCanceledByName;
  final String? shiftCanceledNote;
  final int shiftCount;
  final String shiftStatus;
  final Timestamp shiftStatusDate;
  final String? specialRequirements;
  final String state;
  final String statusId;
  final double usePremiumRate;
  final int userId;
  final String? uuid;
  final String weekStartDay;
  final String? woWorkOrderId;
  final String? workOrderId;
  final String? workOrderIdUuid;
  final int? workersCompCodeId;
  final String? workersCompType;
  final String zipCode;

}