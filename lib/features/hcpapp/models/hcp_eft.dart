

class HCPEFT {
  const HCPEFT({
         // required this.id,
         // required this.mongodbId,
         required this.eftId,     //asm
         required this.accountName,
         required this.accountNumber,
         required this.routingNumber,
         required this.calculationMethod,
         required this.eftTypeCodeId,
         required this.distributionOrder,
         required this.amount});

  // final ObjectId id;
  // final ObjectId mongodbId;
  final String eftId;
  final String accountName;
  final String accountNumber;
  final String routingNumber;
  final String calculationMethod;
  final int eftTypeCodeId;
  final int distributionOrder;
  final double amount;
}
