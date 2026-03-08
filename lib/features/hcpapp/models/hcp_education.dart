

class HCPEducation {
  const HCPEducation(
      // this.id,
       this.ownerId,  //hcp
      this.educationId,  //asm
      this.hcpId,
      this.schoolName,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.zip,
      this.degree,
      this.statusAttending,
      this.statusGraduated,
      this.statusOther,
      this.statusOtherDesc,
      this.graduationDate,
      this.major,
      this.internalNote);

 // final ObjectId id;
  final String ownerId;
  final String educationId;  //asm;
  final int hcpId;
  final String schoolName;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String zip;
  final String degree;
  final bool statusAttending;
  final bool statusGraduated;
  final bool statusOther;
  final String? statusOtherDesc;
  final DateTime graduationDate;
  final String major;
  final String? internalNote;
}
