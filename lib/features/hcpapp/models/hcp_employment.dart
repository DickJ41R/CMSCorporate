

class HCPEmployment {
  const HCPEmployment({
         // required this.id,
         // required this.mongodbId,
         required this.employmentId,  //asm
         required this.facilityName,
         required this.address1,
         required this.address2,
         required this.city,
         required this.state,
         required this.zipCode,
         required this.fullAddress,
         required this.supervisorName,
         required this.supervisorTitle,
         required this.supervisorPhone,
         required this.supervisorPhoneExt,
         required this.supervisorEmail,
         required this.supervisorCanContact,
         required this.fromDate,
         required this.toDate,
         required this.isCurrent,
         required this.unitDescription,
         required this.jobTitle,
         required this.jobDescription,
         required this.reasonForLeaving,
         required this.startingSalary,
         required this.endingSalary,
         required this.isPerDiem,
         required this.isTravel,
         required this.isPermanent,
         required this.internalNote,
         required this.agencyName});

  // final ObjectId id;
  // final ObjectId mongodbId;  //hcp
  final String employmentId; //asm
  final String facilityName;
  final String? address1;
  final String? address2;
  final String? city;
  final String state;
  final String zipCode;
  final String fullAddress;
  final String supervisorName;
  final String? supervisorTitle;
  final String? supervisorPhone;
  final String? supervisorPhoneExt;
  final String? supervisorEmail;
  final bool supervisorCanContact;
  final DateTime fromDate;
  final DateTime? toDate;
  final bool isCurrent;
  final String? unitDescription;
  final String? jobTitle;
  final String? jobDescription;
  final String? reasonForLeaving;
  final double startingSalary;
  final double endingSalary;
  final bool isPerDiem;
  final bool isTravel;
  final bool isPermanent;
  final String? internalNote;
  final String? agencyName;
}
