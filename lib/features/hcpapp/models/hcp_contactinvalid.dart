

class HCPContact {
   const HCPContact({
    //    required this.id,     //)id
      //  required this.mongodbId,  //hcpprofessional
        required this.clientContactId,  //asm
        required this.contactTypeCodeId,
        required this.prefix,
        required this.firstName,
        required this.lastName,
        required this.middleName,
        required this.nickName,
        required this.fullName,
        required this.jobTitleCodeId,
        required this.birthday,
        required this.departmentId,
        required this.collectionsContact,
        required this.note,
        required this.workTelephoneNumber,
        required this.workExtensionNumber,
        required this.workTip,
        required this.telephoneCell,
        required this.mobileProviderCodeId,
        required this.cellTip,
        required this.telephoneFax,
        required this.extensionFax,
        required this.faxTip,
        required this.telephoneOther,
        required this.extensionOther,
        required this.otherTip,
        required this.email,
        required this.emailTip,
        required this.marketingContact,
        required this.noCalls,
        required this.noEmail,
        required this.noFax,
        required this.noMail,
        required this.emailSchedulingConfirmations,
        required this.textSchedulingConfirmations,
        required this.emailClientModule,
        required this.mobileProvider
   });
   
// final ObjectId mongodbId;
// final ObjectId id;
final int clientContactId;   //asm
final String contactTypeCodeId;
final String? prefix;
final String? firstName;
final String? lastName;
final String? middleName;
final String? nickName;
final String fullName;
final String? jobTitleCodeId;
final DateTime? birthday;
final int departmentId;
final bool collectionsContact;
final String note;
final String? workTelephoneNumber;
final String? workExtensionNumber;
final bool workTip;
final String? telephoneCell;
final String? mobileProviderCodeId;
final bool cellTip;
final String? telephoneFax;
final String? extensionFax;
final bool faxTip;
final dynamic telephoneOther;
final dynamic extensionOther;
final bool otherTip;
final dynamic email;
final bool emailTip;
final bool marketingContact;
final bool noCalls;
final bool noEmail;
final bool noFax;
final bool noMail;
final bool emailSchedulingConfirmations;
final bool textSchedulingConfirmations;
final bool emailClientModule;
final dynamic mobileProvider;

Map<String, dynamic> setCollection() {
  Map<String, dynamic> col = {};
  //0
  // col['id'] = id;
  // col['mongodbId'] = mongodbId;
  // //1
  col['clientContactId'] = clientContactId;
  //2
  col['contactTypeCodeId'] = contactTypeCodeId;
  if (prefix != null) {
    //3
    col['prefix'] = prefix;
  }
  if (firstName != '') {
    //4
    col['firstName'] = firstName;
  }
  if (lastName != '') {
    //5
    col['lastName'] = lastName;
  }
  if (middleName != '') {
    //6
    col['middleName'] = middleName;
  }
  if (nickName != '') {
    //7
    col['nickName'] = nickName;
  }
  if (fullName != '') {
    //8
    col['fullName'] = fullName;
  }
  if ( jobTitleCodeId != null) {
    //9
    col['jobTitleCodeId'] =  jobTitleCodeId;
  }
  if ( birthday != null) {
    //10
    col['birthday'] =  birthday;
  }
  //11
  col['departmentId'] = departmentId;
  //12
  col['collectionsContact'] = collectionsContact;
  if (note != '') {
    //13
    col['note'] = note;
  }
  if (workTelephoneNumber != '') {
    //14
    col['workTelephoneNumber'] = workTelephoneNumber;
  }
  if ( workExtensionNumber != '') {
    //15
    col['workExtensionNumber'] = workExtensionNumber;
  }
  //16
  col['workTip'] = workTip;
  if (telephoneCell != '') {
    //17
    col['telephoneCell'] = telephoneCell;
  }
  if (mobileProviderCodeId != null) {
    //18
    col['mobileProviderCodeId'] = mobileProviderCodeId;
  }
  //19
  col['cellTip'] = cellTip;
  if (telephoneFax != '') {
    //20
    col['telephoneFax'] = telephoneFax;
  }
  if (extensionFax != '') {
    //21
    col['extensionFax'] = extensionFax;
  }
  //22
  col['faxTip'] = faxTip;
  if (telephoneOther != '') {
    //23
    col['telephoneOther'] = telephoneOther;
  }
  if ( extensionOther != '') {
    //24
    col['extensionOther'] =  extensionOther;
  }
  //25
  col['otherTip'] = otherTip;
  if ( email != '') {
    //26
    col['email'] =  email;
  }
  //27
  col['emailTip'] = emailTip;
  //28
  col['marketingContact'] = marketingContact;
  //29
  col['noCalls'] = noCalls;
  //30
  col['noEmail'] = noEmail;
  //31
  col['noFax'] = noFax;
  //32
  col['noMail'] = noMail;
  //33
  col['emailSchedulingConfirmations'] = emailSchedulingConfirmations;
  //34
  col['textSchedulingConfirmations'] = textSchedulingConfirmations;
  //35
  col['emailClientModule'] = emailClientModule;
  //36
  col['mobileProvider'] = mobileProvider;
  return col;
}
}
