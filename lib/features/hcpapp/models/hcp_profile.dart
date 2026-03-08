

class HCPPersonalProfile {
  const HCPPersonalProfile({
         // required this.id,
         // required this.mongodbId,
         required this.personalProfileId,
         required this.gender,
         required this.socialSecurityNumber,
         required this.firstDateOfWork,
         required this.lastDateOfWork,
         required this.eeoMaritalStatus});

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int personalProfileId;
  final String gender;
  final String socialSecurityNumber;
  final DateTime firstDateOfWork;
  final DateTime? lastDateOfWork;
  final String eeoMaritalStatus;
}
