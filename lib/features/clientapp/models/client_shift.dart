
import 'client_requirements.dart';

class ShiftByDay {
  const ShiftByDay(
    this.dayNumber,
    this.shiftNumber,
    this.disciplineIds,
    this.disciplineNames,
    this.disciplineCounts,
    this.shiftRate,
    this.requiredCredentials,
    this.requiredShotsAndVaccines,
    this.requiredSkills,
    this.requiredSpecials);

  final int dayNumber;
  final int shiftNumber;
  final List<String>disciplineIds;
  final List<String>disciplineNames;
  final List<int>disciplineCounts;
  final double shiftRate;
  final List<ClientRequirements>requiredCredentials;
  final List<ClientRequirements>requiredShotsAndVaccines;
  final List<ClientRequirements>requiredSkills;
  final List<ClientRequirements>requiredSpecials;
}
class ClientShift {

    const ClientShift(
    this.clientShiftCode,
    this.clientCode,
    this.departmentCode,
    this.shiftNumber,
    this.shiftDayId, //1 = all, 2 = weekdays, 3 = weekends, 4 = individual
    this.primaryShiftDiscipline,
    this.secondaryDisciplines,
    this.shiftAmOrPm,
    this.shiftStartTime,
    this.shiftEndTime,
    this.shiftStartDate,
    this.shiftEndDate,
    this.shiftNumberOfSlots,
    this.shiftInstructions,
    this.shiftSupervisorId,
    this.shiftSupervisor,
    this.shiftSupervisorToken,
    this.shiftRate,
    this.shiftsByDay
  );

  final String clientShiftCode;
  final String clientCode;
  final String departmentCode;
  final int shiftNumber;
  final int shiftDayId; //1 = all, 2 = weekdays, 3 = weekends, 4 = individual
  final String primaryShiftDiscipline;
  final List<String>secondaryDisciplines;
  final String shiftAmOrPm;
  final DateTime shiftStartTime;
  final DateTime shiftEndTime;
  final DateTime shiftStartDate;
  final DateTime shiftEndDate;
  final int shiftNumberOfSlots;
  final String shiftInstructions;
  final int shiftSupervisorId;
  final String shiftSupervisor;
  final String shiftSupervisorToken;
  final double shiftRate;
  final List<ShiftByDay>shiftsByDay;


    //   {
    //      dayNumber: 0,
    //     "shiftDayNumber": 0,
    //     "shiftNumber": 0,
    //     "disciplineIds": [],
    //     "disciplineNames": [],
    //     "disciplineCount": [],
   //final List<ClientRequirements>requiredCredentials;
    //final List<ClientRequirements>requiredShotsAndVaccines;
    //final List<ClientRequirements>requiredSkills;
    //final List<ClientRequirements>requiredSpecials;
    //   }
    // ];
   // final List<Map<String, dynamic>> shiftInformationByDay;
// final List<Map<String, dynamic>> shiftInformationByDay = [
//   {
//     "shiftDayNumber": 0,
//     "shiftNumber": 0,
//     "shiftSupervisorId": '',
//     "shiftSupervisorName": '',
//     "shiftSupervisorTelephone": '',
//     "shiftSuperevisorEmail": '',
//     "shiftSupervisorToken": ''
//   }
// ];
}