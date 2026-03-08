
class HCPPayrollInformation {
  const HCPPayrollInformation({
         // required this.id,
         // required this.mongodbId,
         required this.payrollInformationId,  //asm
         required this.benefitClassStatusCodeId,
         required this.benefitClassEffectiveDate,
         required this.use1099,
         required this.isEmployee,
         required this.allowDailyPay,
         required this.receivesOT,
         required this.payIncludeOnCallInOT,
         required this.fedFilingStatusCodeId,
         required this.fedFilingStatusCode,
         required this.fedAllow,
         required this.fedAdjustmentCodeId,
         required this.fedAdjustmentCode,
         required this.fedAmount,
         required this.taxCalculationMethodCodeId,
         required this.taxCalculationMethodCode,
         required this.payrollSUTAState,
         required this.advanceAllowed,
         required this.advancePercent,
         required this.taxExempt,
         required this.payrollCompanyId,
         required this.payrollCompany,
         required this.departmentId,
         required this.department,
         required this.paycheckNotice,
         required this.vendorName,
         required this.federalId,
         required this.defaultCheckType,
         required this.w4Enable2020,
         required this.w4TwoJobs,
         required this.w4DependentAmount,
         required this.w4OtherIncome,
         required this.w4Deductions,
         required this.ficaDeferred,
         required this.partimeData});

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int payrollInformationId; //asm
  final String benefitClassStatusCodeId;
  final DateTime benefitClassEffectiveDate;
  final bool use1099;
  final bool isEmployee;
  final bool allowDailyPay;
  final bool receivesOT;
  final bool payIncludeOnCallInOT;
  final String fedFilingStatusCodeId;
  final String fedFilingStatusCode;
  final int fedAllow;
  final String fedAdjustmentCodeId;
  final String fedAdjustmentCode;
  final double fedAmount;
  final String taxCalculationMethodCodeId;
  final String taxCalculationMethodCode;
  final String? payrollSUTAState;
  final bool advanceAllowed;
  final int advancePercent;
  final bool taxExempt;
  final String payrollCompanyId;
  final String payrollCompany;
  final String departmentId;
  final String department;
  final String? paycheckNotice;
  final String? vendorName;
  final String? federalId;
  final String defaultCheckType;
  final bool w4Enable2020;
  final bool w4TwoJobs;
  final double w4DependentAmount;
  final double w4OtherIncome;
  final double w4Deductions;
  final bool ficaDeferred;
  final Map<String, dynamic> partimeData;
  //bool isPartTime,
  //doulbe PartTimeMaximumHours,
  //String benefitClassStatusCodeId,
  //DateTime benefitClassEffectiveDate
}
