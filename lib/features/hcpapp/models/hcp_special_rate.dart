
class HCPSpecialRate {

  HCPSpecialRate({
    // required this.id, required this.mongodbId,
    required this.clientId, required this.hcpId, required this.disciplineId});

    // final ObjectId id;
    // final ObjectId mongodbId;  //special rate
    final int clientId;
    final int hcpId;
    final int disciplineId;
}