import 'package:cms_web/features/branchcorporateapp/models/cms_rate_override_info.dart';

class CMSShiftRateInfo {
  CMSShiftRateInfo(
    // this.shiftRateId,
    this.rateId,
    this.shiftCodeId,
    this.shiftCode,
    this.shiftCodeDesc,
    this.calcType,
    this.margin,
    this.marginWE,
    this.payRate,
    this.payRateWE,
    this.billRate,
    this.billRateWE,
    this.startTime,
    this.endTime,
    this.meals,
    this.overrideRates,
    this.rateOverrides,
  );

  // final ObjectId shiftRateId;
  final int rateId;
  final int shiftCodeId;
  final String shiftCode;
  final String shiftCodeDesc;
  final String calcType;
  final double margin;
  final double marginWE;
  final double payRate;
  final double payRateWE;
  final double billRate;
  final double billRateWE;
  final String startTime;
  final String endTime;
  final int meals;
  final bool overrideRates;
  final CMSRateOverrideInfo rateOverrides;
}
