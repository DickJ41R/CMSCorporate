import 'package:cloud_firestore/cloud_firestore.dart';


class ClientContact {
  const ClientContact({
    required this.id,
    required this.clientContactId,
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
    required this.mobileProvider,
    required this.isDepartment
  });

  final String id;
  final dynamic clientContactId;
  final dynamic contactTypeCodeId;
  final dynamic prefix;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? nickName;
  final String fullName;
  final dynamic jobTitleCodeId;
  final DateTime? birthday;
  final dynamic departmentId;
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
  final bool isDepartment;

  factory ClientContact.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    return ClientContact(
        id: data?['id'],
        clientContactId: data?["clientContactId"],
        contactTypeCodeId: data?["contactTypeCodeId"],
        prefix: data?["prefix"],
        firstName: data?["firstName"],
        lastName: data?["lastName"],
        middleName: data?["middleName"],
        nickName: data?["nickName"],
        fullName: data?["fullName"],
        jobTitleCodeId: data?["jobTitleCodeId"],
        birthday: data?["birthDay"],
        departmentId: data?["departmentId"],
        collectionsContact: data?["collectionContact"],
        note: data?["note"],
        workTelephoneNumber: data?["workTelephoneNumber"],
        workExtensionNumber: data?["workExtensionNumber"],
        workTip: data?["workTipe"],
        telephoneCell: data?["telephoneCell"],
        mobileProviderCodeId: data?["mobleProviderCodeId"],
        cellTip: data?["cellTip"],
        telephoneFax: data?["telephoneFax"],
        extensionFax: data?["extensionFax"],
        faxTip: data?["faxTip"],
        telephoneOther: data?["telephoneOther"],
        extensionOther: data?["extensionOther"],
        otherTip: data?["otherTip"],
        email: data?["email"],
        emailTip: data?["emailTip"],
        marketingContact: data?["marketingContact"],
        noCalls: data?["noCalls"],
        noEmail: data?["noEmail"],
        noFax: data?["noFax"],
        noMail: data?["noMail"],
        emailSchedulingConfirmations: data?["emailSchedulingConfirmations"],
        textSchedulingConfirmations: data?["textSchedulingConfirmations"],
        emailClientModule: data?[" emailClientModule"],
        mobileProvider: data?["mobileProvider"],
        isDepartment: data?["isDepartment"]
    );
  }


  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    //0
    col['id'] = id;
    //1
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
    if ( departmentId != null) {
      //11
      col['departmentId'] = departmentId;
    }
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
    col['isDepartment'] = isDepartment;
    return col;
  }
}
