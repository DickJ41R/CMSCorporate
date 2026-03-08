import 'package:cloud_firestore/cloud_firestore.dart';

class HCPTimeCard {

   HCPTimeCard({required this.id,required this.shiftDate,required this.scheduleWorkOrderId,
      required this.orderId,required this.clientId,required this.departmentId,required this.branchId,
      required this.orderType,required this.clientName,required this.departmentName,required this.branchName,
      required this.workOrderDescription,required this.areaId,this.areaName,this.campaignMessage,
      required this.disciplineId,required this.disciplineNames,required this.status,
      required this.hcpId,required this.hcpName,required this.shiftId,required this.shiftCode,
      required this.ShiftDescription,required this.shiftType,required this.shiftTypeDescription,
      required this.shiftStartDate,required this.shiftEndDate,required this.shiftTimeCode,
      required this.shiftStartTime,required this.shiftEndTime,required this.shiftSignedIn,
      required this.shiftSignedOut,this.shiftDateTimeSignedIn,this.shiftDateTimedSignedOut,
      required this.shiftCanceledByHCP,this.ShiftCanceledHCPDateTime,required this.shiftCanceledByClient,
      this.shiftClientCanceledById,this.shiftClientCancelByName,required this.meals,required this.isWeekend,
      required this.isHoliday,required this.useOT,required this.useDblTime,required this.useHolidayTime,
      required this.createdDate,required this.payRate,required this.payRateWE,required this.overtimeRateFactor,
      required this.doubleTimeRateFactor,required this.holidayRateFactor,required this.latitude,
      required this.longitude,required this.clientLatitude,required this.clientLongitude,required this.shiftPayRate,
      required this.shiftBillWeekend,required this.shiftMarginWeekend,required this.signedInGeofenceVerified,
      required this.signedInGeofenceAvailable,required this.verifiedWorkHours,required this.shiftHoursOverTime,
      required this.signedInHCPNotes,
      required this.signedOutShiftDateTime,required this.signedOutGeofenceVerified,
      required this.signedOutGeofenceAvailable,required this.signedOutInitialVerification,
      required this.signedOutSupervisorSignature,this.signedOutSupervisorName,
      required this.signedOutHCPNotes,  required this.signedOutInitialVerificationNotes,
         });

   final String id;
   final DateTime shiftDate;
   final int scheduleWorkOrderId;
   final int orderId;
   final int clientId;
   final int departmentId;
   final int branchId;
   final String orderType;
   final String clientName;
   final String departmentName;
   final String branchName;
   final String workOrderDescription;
   final int areaId;
   String? areaName;
   String? campaignMessage;
   final int disciplineId;
   final String disciplineNames;
   final String status;
   final int hcpId;
   final String hcpName;
   final int shiftId;
   final String shiftCode;
   final String ShiftDescription;
   final String shiftType;
   final String shiftTypeDescription;
   final DateTime shiftStartDate;
   final DateTime shiftEndDate;
   final String shiftTimeCode;
   final String shiftStartTime;
   final String shiftEndTime;
   final bool shiftSignedIn;
   final bool shiftSignedOut;
   Timestamp? shiftDateTimeSignedIn;
   Timestamp? shiftDateTimedSignedOut;
   final bool shiftCanceledByHCP;
   Timestamp? ShiftCanceledHCPDateTime;
   final bool shiftCanceledByClient;
   int? shiftClientCanceledById;
   String? shiftClientCancelByName;
   final int meals;
   final bool isWeekend;
   final bool isHoliday;
   final bool useOT;
   final bool useDblTime;
   final bool useHolidayTime;
   final Timestamp? createdDate;
   final double payRate;
   final double payRateWE;
   final double overtimeRateFactor;
   final double doubleTimeRateFactor;
   final double holidayRateFactor;
   final double latitude;
   final double longitude;
   final double clientLatitude;
   final double clientLongitude;
   final double shiftPayRate;
   final double shiftBillWeekend;
   final double shiftMarginWeekend;
   final bool signedInGeofenceAvailable;
   final bool signedInGeofenceVerified;
   final String signedInHCPNotes;
   final double verifiedWorkHours;
   final double shiftHoursOverTime;
   final bool signedOutGeofenceAvailable;
   final bool signedOutGeofenceVerified;
   final bool signedOutHCPNotes;
   bool? signedOutInitialVerification;
   String? signedOutInitialVerificationNotes;
   String? signedOutSupervisorSignature;
   Timestamp? signedOutShiftDateTime;
   String? signedOutSupervisorName;

}