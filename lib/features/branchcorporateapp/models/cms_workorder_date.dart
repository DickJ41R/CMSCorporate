import 'package:cms_web/features/branchcorporateapp/models/cms_shift_info.dart';
import 'package:cms_web/features/branchcorporateapp/models/cms_shift_rate_info.dart';

class CMSWorkorderDate {
  CMSWorkorderDate(
      //    this.dateId,
      this.shiftDate,
      this.isWeekend,
      this.rateType,
      this.shifts,
      this.shiftRates);

//  final ObjectId dateId;
  final DateTime shiftDate;
  final bool isWeekend;
  final String rateType;
  final List<CMSShiftInfo> shifts;
  final List<CMSShiftRateInfo> shiftRates;
}
