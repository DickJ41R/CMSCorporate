

import 'client_requirements.dart';
import 'client_shift.dart';

class ClientSchedule {
  const ClientSchedule({
        required this.id,
        required this.scheduleId,
        required this.scheduleName,
        required this.clientId,
        required this.clientName,
        required this.isPrimary,
        required this.departmentId,
        required this.departmentName,
        required this.scheduleDates,
        required this.scheduleType,
        required this.scheduleStatus,
        required this.requiresOrientation,
        required this.orientationInstructions,
        required this.dateCreated,
        required this.payMeals,
        required this.timeMeals,
        required this.payOT,
        required this.payHoliday,
        required this.payDouble,
        required this.otRate,
        required this.holidayRate,
        required this.doubleRate,
        required this.internalInstructions,
        required this.externalInstructions,
        required this.disciplines,
        required this.requiredCredentials,
        required this.requiredShotsAndVaccines,
        required this.requiredSkills,
        required this.requiredSpecials,
        required this.shifts,
  });
  final String id;
  final String scheduleId;
  final String scheduleName;
  final int clientId;
  final String clientName;
  final bool isPrimary;
  final int? departmentId;
  final String? departmentName;
  final List<DateTime>scheduleDates;
  final String scheduleType;
  final String scheduleStatus;
  final bool requiresOrientation;
  final String? orientationInstructions;
  final DateTime dateCreated;
  final bool payMeals;
  final List<int> timeMeals;
  final bool payOT;
  final bool payHoliday;
  final bool payDouble;
  final double otRate;
  final double holidayRate;
  final double doubleRate;
  final String? internalInstructions;
  final String? externalInstructions;
  final List<String>disciplines;
  final List<ClientRequirements>requiredCredentials;
  final List<ClientRequirements>requiredShotsAndVaccines;
  final List<ClientRequirements>requiredSkills;
  final List<ClientRequirements>requiredSpecials;
  final List<ClientShift>shifts;
}
//for all of the next four requirements
//categoryid id, description, special instructions, months limit eg less than  24
//credential 261 CPR Cardiopulmonary none resuscitation 12
//special 234 TB Tuberculosis 'Tested' 12
//special 235 Orientation 'Must have orientaiton.  Sessions every wednesday 1-2; must register 24
//special 286 Hoyer 'must be trained to used hoyer lift' 60
//required credentials  CPR, etc
//required shotsandvaccines Tetanus HEPB, COVID
//required Skills  Hoyer, patient level
//required specials  orientation
//sifts
//shift number, shift start time, shift end time,shift supervisor
