
class  HCPSchedulingStatistics {

  const HCPSchedulingStatistics({
    // required this.id, required this.mongodbId,
    required this.numberOfShifts, required this.numberOfShiftsAccepted,
    required this.numberOfShiftsApproved, required this.numberOfShiftsConfirmed,
    required this.numberOfHCPCanceledShifts, required this.numberOfClientCanceledShifts,
    required this.initialShiftDateTime, required this.lastShiftDatetime
  });

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int numberOfShifts;
  final int numberOfShiftsAccepted;
  final int numberOfShiftsApproved;
  final int numberOfShiftsConfirmed;
  final int numberOfHCPCanceledShifts;
  final int numberOfClientCanceledShifts;
  final DateTime initialShiftDateTime;
  final DateTime lastShiftDatetime;

}
