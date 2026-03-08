

class HCPDiscipline {
  const HCPDiscipline({
         // required this.id,
         // required this.mongodbId,
         required this.disciplineId,
         required this.disciplineName,
         required this.disciplineDescription,
         required this.licenseState,
         required this.licenseDate,
         required this.licenseExpirationDate,
         required this.reciprocalState});

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int disciplineId;   //asm
  final String disciplineName;
  final String disciplineDescription;
  final String licenseState;
  final DateTime? licenseDate;
  final DateTime? licenseExpirationDate;
  final String? reciprocalState;
}
