
class  HCPSkill {

  const HCPSkill({
  //  required this.id, required this.mongodbId,
    required this.skillId, required this.skillName,
    required this.skillDescription,required this.skillAcquiredDate,
    required this.skillExpirationDate, required this.doesSkillExpire
  });

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int skillId;
  final String skillName;
  final String? skillDescription;
  final DateTime? skillAcquiredDate;
  final DateTime? skillExpirationDate;
  final bool doesSkillExpire;
}