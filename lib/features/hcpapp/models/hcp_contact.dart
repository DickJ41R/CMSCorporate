

class HCPContact {
  const HCPContact({
         // required this.id,     //0
         // required this.mongodbId,    //1
         required this.contactId,  //2
         required this.contactTypeCodeId, //3
         required this.contactType, //4
         required this.contactEntry, //5
         required this.contactNote, //6
         required this.contactExtension, //7
         required this.isEmail, //8
         required this.isTelephone, //9
         required this.webAccess, //10
         required this.emailCredStatusNotifications, //11
         required this.emailSchedulingConfirmations,  //12
         required this.mobileProviderCodeId, //13
         required this.emailRegistryModule, //14
         required this.emailShiftAvailable});  //15

  // final ObjectId id; //0
  // final ObjectId mongodbId; //1
  final int contactId; //2
  final int contactTypeCodeId; //3
  final String contactType; //4
  final String contactEntry; //5
  final String? contactNote; //6
  final String? contactExtension; //7
  final bool isEmail; //8
  final bool isTelephone; //0
  final bool webAccess; //10
  final bool emailCredStatusNotifications; //11
  final bool emailSchedulingConfirmations; //12
  final String mobileProviderCodeId; //13
  final bool emailRegistryModule; //14
  final bool emailShiftAvailable; //145

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    // col['id'] = id;
    // col['mongodbId'] = mongodbId;
    col['contactId'] = contactId;
    col['contactTypeCodeId'] = contactTypeCodeId;
    col['contactType'] = contactType;
    col['contactEntry'] = contactEntry;
    if (contactNote != null) {
      col['contactNote'] = contactNote;
    }
    if (contactExtension != '') {
      col['contactExtension'] = contactExtension;
    }
    col['isEmail'] = isEmail;
    col['isTelephone'] = isEmail;
    col['webAccess'] = webAccess;
    col['emailCredStatusNotifications'] = emailCredStatusNotifications;
    col['emailSchedulingConfirmations'] = emailSchedulingConfirmations;
    if (mobileProviderCodeId != '') {
      col['mobileProviderCodeId'] = mobileProviderCodeId;
    }
    col['emailRegistryModule'] = emailRegistryModule;
    col['emailShiftAvailable'] = emailShiftAvailable;
    return col;
  }
}
