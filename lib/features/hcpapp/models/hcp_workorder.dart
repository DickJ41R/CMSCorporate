

class WorkHistory {
  const WorkHistory({
   required this.workHistoryId,
   required this. workHistoryDate,
   required this.workHistoryShift,
   required this. workHistoreShiftStartTime,
   required this.workHistorhShiftEndTime});

   final int workHistoryId;
   final DateTime? workHistoryDate;
   final int workHistoryShift;
   final DateTime? workHistoreShiftStartTime;
   final DateTime? workHistorhShiftEndTime;
}
class OtherCredential {
    const OtherCredential({
      required this.credentialId,
      required this.credentialCode,
      required this.credentialDescription,
      required this.canExpire,
      required this.expirationDate,
      required this.initialDate,
    });
   final String credentialId;
   final String credentialCode;
   final String credentialDescription;
   final bool canExpire;
   final DateTime? expirationDate;
   final DateTime? initialDate;

}
class HCPWorkOrder {
  const HCPWorkOrder({
         // required this.id,
         // required this.mongodbId,
         required this.workOrderId, //asm
         required this.branchIds,
         required this.dateOfLicenseExpiration,
         required this.licenseStates,
         required this.hasCPR,
         required this.dateOfCPRExpiration,
         required this.hasTBShot,
         required this.dateOfTBExpiration,
         required this.hasHepBShot,
         required this.dateOfHEPBExpiration,
         required this.hasCOVVIDVaccine,
         required this.dateOfCOVVIDVaccine,
         required this.otherCredentials,
         required this.hasOrientation,
         required this.disciplines,
         required this.latitude,
         required this.longitude,
         required this.workHistories});

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int workOrderId;
  final List<int> branchIds;
  final DateTime dateOfLicenseExpiration;
  final List<String>licenseStates;
  final bool hasCPR;
  final DateTime dateOfCPRExpiration;
  final bool hasTBShot;
  final DateTime dateOfTBExpiration;
  final bool hasHepBShot;
  final DateTime? dateOfHEPBExpiration;
  final bool hasCOVVIDVaccine;
  final DateTime? dateOfCOVVIDVaccine;
  final List<OtherCredential>otherCredentials;
  final bool hasOrientation;
  final List<String> disciplines;
  final double latitude;
  final double longitude;
  final List<WorkHistory> workHistories;
}
