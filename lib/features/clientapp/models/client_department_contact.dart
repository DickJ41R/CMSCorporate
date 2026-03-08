import 'package:uuid/uuid.dart';

class ClientContact {
  const ClientContact(
      this.uid,
      this.clientId,
      this.departmentId,
      this.contactId,
      this.contactTypeCodeId,
      this.contactType,
      this.contactEntry,
      this.contactNote,
      this.contactExtension,
      this.isEmail,
      this.webAccess,
      this.emailCredStatusNotifications,
      this.emailSchedulingConfirmations,
      this.mobileProviderCodeId,
      this.emailRegistryModule,
      this.emailShiftAvailable);

  final Uuid uid; //0
  final dynamic clientId; //1
  final dynamic departmentId;
  final int contactId; //2
  final int contactTypeCodeId; //3
  final String contactType; //4
  final String contactEntry; //5
  final String? contactNote; //6
  final String? contactExtension; //7
  final bool isEmail; //8
  final bool webAccess; //9
  final bool emailCredStatusNotifications; //10
  final bool emailSchedulingConfirmations; //11
  final dynamic mobileProviderCodeId; //12
  final bool emailRegistryModule; //13
  final bool emailShiftAvailable; //14

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    col['uid'] = uid;
    col['clientId'] = clientId;
    col['departmentId'] = departmentId;
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
