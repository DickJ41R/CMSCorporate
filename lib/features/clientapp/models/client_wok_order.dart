
//Client WorkOrder is the scheduling workorder used to create a campaign.
//Each client workorder is unique for a discipline.  It can have multiple days and shifts

class ClientWorkOrder {

  const ClientWorkOrder({
        required this.id,
        required this.workOrderId,
        required this.orderId,
        required this.clientId,
        required this.departmentId,
        required this.branchId,
        required this.orderType,
        required this.clientName,
        required this.departmentName,
        required this.branchName,
        required this.schedulerName,
        required this.workOrderDescription,
        required this.areaId,
        required this.areaName,
        required this.campaignMessage,
        required this.disciplineIds,
        required this.disciplineNames,
        required this.specialtyIds,
        required this.specialtyNames,
        required this.statusId,
        required this.status,
        required this.hcpId,
        required this.hcpName,
        required this.shiftsStartDate,
        required this.shiftsEndDate,
        required this.numberOfShiftsPerDay,
        required this.scheduleShifts,
        required this.tinePerShifts,
        required this.numberOfDisciplinesPerShift,
        required this.disciplinesPerShift,
        required this.shiftsTimeCodes,
        required this.shiftsStartTimes,
        required this.shiftsEndTimes,
        required this.doNotScheduleIds,
        required this.campaignMessages,
        required this.meals,
        required this.isWeekend,
        required this.isHoliday,
        required this.charge,
        required this.requiresOrientation,
        required this.userOT,
        required this.useDblTime,
        required this.createdDate,
        required this.hourlyRate,
        required this.overtimeRateFactor,
        required this.doubleTimeRateFactor,
        required this.holidayRateFactor,
        required this.startingDayOfWeek,
        required this.endingDayOfWeek,
        required this.startingWeekendDay,
        required this.endingWeekendDay,
        required this.startingShiftTimeWeekend,
        required this.endingShiftTimeWeekend,
        required this.addressLine1,
        required this.addressLine2,
        required this.city,
        required this.state,
        required this.county,
        required this.latitude,
        required this.longitude
  });

  final String id;
  final int workOrderId;
  final int orderId;
  final int clientId;
  final int departmentId;
  final int branchId;
  final String orderType;
  final String clientName;
  final String? departmentName;
  final String branchName;
  final String schedulerName;
  final String workOrderDescription;
  final dynamic areaId;
  final dynamic areaName;
  final String? campaignMessage;
  final List<dynamic> disciplineIds;
  final List<String> disciplineNames;
  final List<dynamic> specialtyIds;
  final List<String?> specialtyNames;
  final dynamic statusId;
  final String status;
  final dynamic hcpId;
  final String? hcpName;
  final DateTime shiftsStartDate;
  final DateTime shiftsEndDate;
  final int numberOfShiftsPerDay;
  final List<int> scheduleShifts;
  final List<double> tinePerShifts;
  final List<int> numberOfDisciplinesPerShift;
  final List<List<String>> disciplinesPerShift;
  final List<String> shiftsTimeCodes;
  final List<String> shiftsStartTimes;
  final List<String> shiftsEndTimes;
  final List<dynamic> doNotScheduleIds;
  final List<String> campaignMessages;
  final int meals;
  final bool isWeekend;
  final bool isHoliday;
  final bool charge;
  final bool requiresOrientation;
  final bool userOT;
  final bool useDblTime;
  final DateTime createdDate;
  final double hourlyRate;
  final double overtimeRateFactor;
  final double doubleTimeRateFactor;
  final double holidayRateFactor;
  final int startingDayOfWeek;
  final int endingDayOfWeek;
  final int startingWeekendDay;
  final int endingWeekendDay;
  final String startingShiftTimeWeekend;
  final String endingShiftTimeWeekend;
  final String? addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String county;
  final double latitude;
  final double longitude;
}