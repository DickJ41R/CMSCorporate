

class HCPSpecialty {

  HCPSpecialty({
         // required this.id,
         // required this.mongodbId,
         required this.specialtyId,
         required this.specialtyName,
         required this.specialtyDescription,
         this.specialtyAcquiredDate,
         this.specialtyExpirationDate,
         required this.doesSpecialtyExpire
  });

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int specialtyId;
  final String specialtyName;
  final String specialtyDescription;
  late DateTime? specialtyAcquiredDate;
  late DateTime? specialtyExpirationDate;
  final bool doesSpecialtyExpire;
}
