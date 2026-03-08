

class HCPDNU {

   HCPDNU({
   required this.clientId, required this.clientName, required this.departmentId, required this.departmentName,
    required this.hcpId, required this.hcpName, required this.branchId, required this.branchName, required this.isClientDNS,
    this.clientDNSDate, required this.isHCPDNS,this.hcpDNSDate,required this.isBranchDNS, this.branchDNSDate, required this.isCMSDNS,
    this.cmsDNSDate, this.dnsComments, this.createdDate});

 // final ObjectId id;
  final int clientId;
  final String clientName;
  final int departmentId;
  final String departmentName;
  final int branchId;
  final String branchName;
  final int hcpId;
  final String hcpName;
  final bool isClientDNS;
  DateTime? clientDNSDate;
  final bool isHCPDNS;
  DateTime? hcpDNSDate;
  final bool isBranchDNS;
  DateTime? branchDNSDate;
  final bool isCMSDNS;
  DateTime? cmsDNSDate;
  String? dnsComments;
  DateTime? createdDate;


}