
class  ShiftDiscipline {

  const ShiftDiscipline(
    this.disciplineId,
    this.disciplineName,
    this.weekDayPayRate,
    this.weenEndPayRate,
    this.shiftBonus,
    this.numberOfDisciplinesPerShift
      );
  final String disciplineId;
  final String disciplineName;
  final double weekDayPayRate;
  final double weenEndPayRate;
  final double shiftBonus;
  final int numberOfDisciplinesPerShift;

}
class ShiftInformation {
    const ShiftInformation(
      this.shiftSupervisorId,
      this.shiftSupervisorName,
      this.shiftSupervisorTelephone,
      this.shiftSupervisorEmail,
      this.shiftSupervisorToken,
        );

    final int shiftSupervisorId;
    final String shiftSupervisorName;
    final String shiftSupervisorTelephone;
    final String shiftSupervisorEmail;
    final String? shiftSupervisorToken;

}
class ClientShiftData {
  const ClientShiftData(
    this.shiftNumber,
    this.shiftName,
    this.shiftDate,
    this.dayOfTheWeek,
    this.shiftStartTime,
    this.shiftEndTime,
    this.shiftHours,
    this.shiftAMPMCode,
    this.isWeekendShift,
    this.isHolidayShift,
    this.disciplinesForShift,
    this. shiftInformationByDay
  );

  final int shiftNumber;
  final String shiftName;
  final DateTime shiftDate;
  final int dayOfTheWeek;
  final DateTime shiftStartTime;
  final DateTime shiftEndTime;
  final int shiftHours;
  final String shiftAMPMCode;
  final bool? isWeekendShift;
  final bool? isHolidayShift;
  final List<ShiftDiscipline> disciplinesForShift;
  final List<ShiftInformation> shiftInformationByDay;

}
