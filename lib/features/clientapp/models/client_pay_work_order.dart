class ClientPayWorkOrder {
  const ClientPayWorkOrder(
      this.orderID,
      this.clientFacilityID,
      this.clientFacilityName,
      this.departmentID,
      this.departmentName,
      this.branchID,
      this.branchName,
      this.areaID,
      this.areaName,
      this.disciplineIDs,
      this.disciplineNames,
      this.specialtyIDs,
      this.specialtyNames,
      this.status,
      this.cmsId,
      this.registrantName,
      this.shiftDate,
      this.endShiftDate,
      this.shiftDateString,
      this.shiftCode,
      this.startTime,
      this.endTime,
      this.meals,
      this.isWeekend,
      this.isHoliday,
      this.charge,
      this.orientation,
      this.lateCancel,
      this.anticipatedNeed,
      this.calcType,
      this.contract,
      this.contractStartDate,
      this.contractEndDate,
      this.contractPattern,
      this.contractGuarantee,
      this.contractWeeks,
      this.contractDaysPerWeek,
      this.createdDate,
      this.confirmedClient,
      this.confirmedClientUserID,
      this.confirmedClientDate,
      this.confirmedClientNote,
      this.confirmedEmployee,
      this.confirmedEmployeeUserID,
      this.confirmedEmployeeDate,
      this.confirmedEmployeeNote,
      this.internalNote,
      this.invoiceNote,
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
      this.clientFacilityAddressLine1,
      this.clientFacilityAddressLine2,
      this.clientFacilityCity,
      this.clientFacilityState,
      this.clientFacilityZipCode,
      this.clientFacilityCounty);

  final String? orderID;
  final String? clientFacilityID;
  final String clientFacilityName;
  final String departmentID;
  final String departmentName;
  final String branchID;
  final String branchName;
  final String? areaID;
  final String? areaName;
  final List<String> disciplineIDs;
  final List<String> disciplineNames;
  final List<String?> specialtyIDs;
  final List<String?> specialtyNames;
  final String status;
  final String cmsId;
  final String registrantName;
  final DateTime shiftDate;
  final DateTime endShiftDate;
  final String shiftDateString;
  final int shiftCode;
  final String startTime;
  final String endTime;
  final int meals;
  final bool isWeekend;
  final bool isHoliday;
  final bool charge;
  final bool orientation;
  final bool lateCancel;
  final bool anticipatedNeed;
  final String calcType;
  final bool contract;
  final DateTime? contractStartDate;
  final DateTime? contractEndDate;
  final String? contractPattern;
  final double contractGuarantee;
  final int contractWeeks;
  final int contractDaysPerWeek;
  final DateTime createdDate;
  final bool confirmedClient;
  final String? confirmedClientUserID;
  final DateTime? confirmedClientDate;
  final String? confirmedClientNote;
  final bool confirmedEmployee;
  final String? confirmedEmployeeUserID;
  final DateTime? confirmedEmployeeDate;
  final String? confirmedEmployeeNote;
  final String? internalNote;
  final String? invoiceNote;
  final String? transportationNote;
  final String? publicNote;
  final String? caller;
  final String orderType;
  final String? poNumber;
  final String? workersCompCode;
  final String? cancelReason;
  final double calculatedPayRate;
  final double calculatedBillRate;
  final int totalHours;
  final double totalPayAmount;
  final double totalBillAmount;
  final String grossMargin;
  final List<String?> registrantSpecialties;
  final String registrantBranchName;
  final String clientFacilityAddressLine1;
  final String? clientFacilityAddressLine2;
  final String clientFacilityCity;
  final String clientFacilityState;
  final String clientFacilityZipCode;
  final String clientFacilityCounty;
}
