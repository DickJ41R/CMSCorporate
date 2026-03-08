class HCPReference {
  const HCPReference({
         // required this.id,
         // required this.mongodbId,
         required this.personalReferenceId,
         required this.referenceName,
         required this.referenceTitle,
         required this.referenceEmployer,
         required this.address1,
         required this.address2,
         required this.city,
         required this.state,
         required this.zipCode,
         required this.referencePhone,
         required this.referencePhoneExt,
         required this.referenceEmail,
         required this.referenceCanContact,
         required this.internalNote,
         required this.partTime,
         required this.partTimeMaximumHours});

  // final ObjectId id;
  // final ObjectId mongodbId;
  final int personalReferenceId;
  final String referenceName;
  final String referenceTitle;
  final String referenceEmployer;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? referencePhone;
  final String? referencePhoneExt;
  final String? referenceEmail;
  final bool referenceCanContact;
  final String? internalNote;
  final bool partTime;
  final int partTimeMaximumHours;
}
