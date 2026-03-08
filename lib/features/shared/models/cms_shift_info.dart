

class CMSShiftInfo {
  CMSShiftInfo(
   //   this.shiftId,
      this.shiftDate,
      this.shiftNumber,
      this.shiftStatTime,
      this.shiftEndTime,
      this.shiftRate,
      this.meals,
      this.isAccepted,
      this.acceptedDate,
      this.acceptedRate,
      this.isApproved,
      this.approvedDate,
      this.isConfirmed,
      this.confirmedDate,
      this.confirmedRate,
      this.confirmedNote
      );
  //final ObjectId shiftId;

  final DateTime shiftDate;
  final int shiftNumber;
  final String shiftStatTime;
  final String shiftEndTime;
  final double shiftRate;
  final int meals;
  final bool isAccepted;
  final DateTime? acceptedDate;
  final double acceptedRate;
  final bool isApproved;
  final DateTime? approvedDate;
  final bool isConfirmed;
  final DateTime? confirmedDate;
  final double confirmedRate;
  final String? confirmedNote;
}

class ShiftInfo {

  ShiftInfo(
      this.shiftNumber,
      this.shiftStartPeriod,
      this.shiftEndPeriod,
      this.shiftStartTime,
      this.shiftEndTime,
      this.shiftTotalHours,
      this.shiftTotalMinutes,
      this.month,
      this.weekOfTheMonth,
      this.weekDay,
      this.shiftNow,
      this.shiftTotalBillingHours,
      this.shiftTotalBillingMinutes,
      this.isAccepted,
      this.acceptedDate,
      this.acceptedRate,
      this.isApproved,
      this.approvedDate,
      this.isConfirmed,
      this.confirmedDate,
      this.confirmedRate,
      this.confirmedNote
      );

  final int shiftNumber;
  final String? shiftStartPeriod;
  final String? shiftEndPeriod;
  final double shiftStartTime;
  final double shiftEndTime;
  final double shiftTotalHours;
  final double  shiftTotalMinutes;
  final int month;
  final int weekOfTheMonth;
  final int weekDay;
  final DateTime? shiftNow;
  final double shiftTotalBillingHours;
  final double shiftTotalBillingMinutes;
  final bool isAccepted;
  final DateTime? acceptedDate;
  final double acceptedRate;
  final bool isApproved;
  final DateTime? approvedDate;
  final bool isConfirmed;
  final DateTime? confirmedDate;
  final double confirmedRate;
  final String? confirmedNote;

//   Options.fromJson(Map<String, dynamic> json) {
//   name = json['name'];
//   text = json['text'];
//   }

//   Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['name'] = this.name;
//   data['text'] = this.text;
//   return data;
//   }

}
