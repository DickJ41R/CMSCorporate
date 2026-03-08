

class TimeSheet {
  const TimeSheet(
  this.timeSheetId,
  this.orderId,
  this.campaignId,
  this.clientId,
  this.departmentI,
  this.branchId,
  this.hcpId,
  this.hcpFullName,
  this.clientName,
  this.departmentName,
  this.useDepartment,
  this.campaignMessage,
  this.timeSheetCreatedDate,
  this.shiftsStartDate,
  this.shiftsEndDate,
  this.disciplineCodeId,
  this.disciplineDescription,
  this.shiftsInfo,
  this.transportationNote,
  this.publicNote,
  this.caller,
  this.orderType,
  this.poNumber,
  this.workersCompCode,
  this.cancelReason,
  this.calculatedPayRate,
  this.calculatedBillRate,
  this.totalHours,
  this.totalPayAmount,
  this.totalBillAmount,
  this.grossMargin,
  this.registrantSpecialties,
  this.registrantBranchName,
  this.addressLine1,
  this.addressLine2,
  this.city,
  this.state,
  this.zipCode,
  this.addRessCount,
  this.rateId,
  this.rateIDPayRate,
  this.rateIDBillRate,
  this.createdDateTime
  );

  final dynamic timeSheetId;
  final dynamic orderId;
  final dynamic campaignId;
  final dynamic clientId;
  final dynamic departmentI;
  final dynamic branchId;
  final dynamic hcpId;
  final String hcpFullName;
  final String clientName;
  final String departmentName;
  final bool useDepartment;
  final String? campaignMessage;
  final DateTime timeSheetCreatedDate;
  final DateTime shiftsStartDate;
  final DateTime shiftsEndDate;
  final dynamic disciplineCodeId;
  final String disciplineDescription;
  final List<dynamic> shiftsInfo;
  final String? transportationNote;
  final String? publicNote;
  final String? caller;
  final String? orderType;
  final String? poNumber;
  final dynamic workersCompCode;
  final String? cancelReason;
  final double calculatedPayRate;
  final double calculatedBillRate;
  final double totalHours;
  final double totalPayAmount;
  final double totalBillAmount;
  final double grossMargin;
  final List<String> registrantSpecialties;
  final String registrantBranchName;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? zipCode;
  final dynamic addRessCount;
  final dynamic rateId;
  final double rateIDPayRate;
  final double rateIDBillRate;
  final DateTime? createdDateTime;

}