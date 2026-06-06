import 'package:cloud_firestore/cloud_firestore.dart';


class ClientDepartment {
  ClientDepartment(

  {
  required this.id,
  required this.ownerId,  
  required this.departmentId,
  required this.departmentAsOwnerId,
  required this.clientId,
  required this.departmentNumber,
  required this.departmentName,
  required this.costCenter,
  required this.branchId,
  required this.branchName,
  required this.note,
  required this.statusId,
  required this.statusDescription,
  required this.firstServicedDate,
  required this.lastServicedDate,
  required this.useClientPhysicalAddress,
  required this.mailingAddress1,
  required this.mailingAddress2,
  required this.mailingCounty,
  required this.mailingCity,
  required this.mailingState,
  required this.mailingZipCode,
  required this.useClientBillingAddress,
  required this.billingSameAsPhysical,
  required this.billingAddressName,
  required this.billingAddressAttention,
  required this.billingAddress1,
  required this.billingAddress2,
  required this.billingCity,
  required this.billingState,
  required this.billingZipCode,
  required this.useClientPayment,
  required this.paymentMethodCodeId,
  required this.paymentTermsCodeId,
  required this.useClientWeek,
  required this.weekStartTime,
  required this.weekStartDay,
  required this.weekendStartTime,
  required this.weekendStartDay,
  required this.weekendEndTime,
  required this.weekendEndDay,
  required this.OTTemplateID,
  required this.acceptsOT,
  required this.timeType,
  required this.timeTypeDescription,
  required this.splitShifts,
  required this.splitWeekends,
  required this.splitHolidays,
  required this.useClientPayModifiers,
  required this.payHolidayRate,
  required this.payHolidayPlusRate,
  required this.useClientBillModifiers,
  required this.billOTRate,
  required this.billOTPlusRate,
  required this.billDblRate,
  required this.billDblPlusRate,
  required this.billHolidayRate,
  required this.billHolidayPlusRate,
  required this.billMaxRate,
  required this.salesTaxId,
  required this.useClientCreditCard,
  required this.creditCardTypeCodeId,
  required this.creditCardNumber,
  required this.creditCardExpirationDate,
  required this.cardHolderName,
  required this.chargeIncrement,
  required this.chargeWhenInvoiced,
  required this.invoiceFormatCodeId,
  required this.debugPrintQueue,
  required this.debugPrintQueueCopies,
  required this.omrQueue,
  required this.emailQueue,
  required this.emailQueuePDF,
  required this.emailQueueXLS,
  required this.debugPrintImages,
  required this.imagesPerPage,
  required this.invoiceComments,
  required this.invoiceEmailTemplateId,
  required this.payrollLocationId,
  required this.municipalityId,
  required this.municipalityName,
  required this.schoolDistrictId,
  required this.schoolDistrictName,
  required this.latitude,
  required this.longitude,
  required this.billMaxPlusRate,
  required this.useClientInvoicing,
  required this.payMaxRate,
  required this.useClientTax,
  required this.rateGroups
});

final String id;
final String ownerId;
final int departmentId;
final String departmentAsOwnerId;
final int clientId;
final String departmentNumber;
final String departmentName;
final String? costCenter;
final int branchId;
final String branchName;
final String? note;
final String statusId;
final String statusDescription;
final DateTime firstServicedDate;
final DateTime lastServicedDate;
final bool useClientPhysicalAddress;
final String? mailingAddress1;
final String? mailingAddress2;
final String? mailingCounty;
final String? mailingCity;
final String? mailingState;
final String? mailingZipCode;
final bool useClientBillingAddress;
final bool billingSameAsPhysical;
final String? billingAddressName;
final String? billingAddressAttention;
final String? billingAddress1;
final String? billingAddress2;
final String? billingCity;
final String? billingState;
final String? billingZipCode;
final bool useClientPayment;
final int? paymentMethodCodeId;
final int? paymentTermsCodeId;
final bool useClientWeek;
final DateTime? weekStartTime;
final int? weekStartDay;
final DateTime? weekendStartTime;
final int? weekendStartDay;
final DateTime? weekendEndTime;
final int? weekendEndDay;
final String? OTTemplateID;
final bool acceptsOT;
final String? timeType;
final String? timeTypeDescription;
final bool splitShifts;
final bool splitWeekends;
final bool splitHolidays;
final bool useClientPayModifiers;
final double? payHolidayRate;
final double? payHolidayPlusRate;
final bool useClientBillModifiers;
final double? billOTRate;
final double? billOTPlusRate;
final double? billDblRate;
final double? billDblPlusRate;
final double? billHolidayRate;
final double? billHolidayPlusRate;
final double? billMaxRate;
final String? salesTaxId;
final bool useClientCreditCard;
final String? creditCardTypeCodeId;
final String? creditCardNumber;
final DateTime? creditCardExpirationDate;
final String? cardHolderName;
final double? chargeIncrement;
final bool chargeWhenInvoiced;
final String? invoiceFormatCodeId;
final String? debugPrintQueue;
final int? debugPrintQueueCopies;
final bool omrQueue;
final bool emailQueue;
final bool emailQueuePDF;
final bool emailQueueXLS;
final bool debugPrintImages;
final int? imagesPerPage;
final String? invoiceComments;
final String? invoiceEmailTemplateId;
final String? payrollLocationId;
final String? municipalityId;
final String? municipalityName;
final String? schoolDistrictId;
final String? schoolDistrictName;
final double? latitude;
final double? longitude;
final double? billMaxPlusRate;
final bool useClientInvoicing;
final double? payMaxRate;
final bool useClientTax;
final List<dynamic>?rateGroups;

    factory  ClientDepartment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,) {
      final lc = snapshot.data();
      return ClientDepartment(
        id: lc?['clientId'],
        ownerId: lc?['ownerId'],
        departmentId: lc?['departmentId'],
        departmentAsOwnerId: lc?['deptId'],
        clientId: lc?['clientId'],
        departmentNumber: lc?['departmentNumber'],
        departmentName: lc?['departmentName'],
        costCenter: lc?['costCenter'],
        branchId: lc?['branchId'],
        branchName: lc?['branchName'],
        note: lc?['note'],
        statusId: lc?['statusId'],
        statusDescription: lc?['statusDescription'],
        firstServicedDate: lc?['firstServicedDate'],
        lastServicedDate: lc?['lastServicedDate'],
        useClientPhysicalAddress: lc?['useClientPhysicalAddress'],
        mailingAddress1: lc?['mailingAddress1'],
        mailingAddress2: lc?['mailingAddress2'],
        mailingCounty: lc?['mailingCounty'],
        mailingCity: lc?['mailingCity'],
        mailingState: lc?['mailingState'],
        mailingZipCode: lc?['mailingZipCode'],
        useClientBillingAddress: lc?['useClientBillingAddress'],
        billingSameAsPhysical: lc?['billingSameAsPhysical'],
        billingAddressName: lc?['billingAddressName'],
        billingAddressAttention: lc?['billingAddressAttention'],
        billingAddress1: lc?['billingAddress1'],
        billingAddress2: lc?['billingAddress2'],
        billingCity: lc?['billingCity'],
        billingState: lc?['billingState'],
        billingZipCode: lc?['billingZipCode'],
        useClientPayment: lc?['useClientPayment'],
        paymentMethodCodeId: lc?['paymentMethodCodeId'],
        paymentTermsCodeId: lc?['paymentTermsCodeId'],
        useClientWeek: lc?['useClientWeek'],
        weekStartTime: lc?['weekStartTime'],
        weekStartDay: lc?['weekStartDay'],
        weekendStartTime: lc?['weekendStartTime'],
        weekendStartDay: lc?['weekendStartDay'],
        weekendEndTime: lc?['weekendEndTime'],
        weekendEndDay: lc?['weekendEndDay'],
        OTTemplateID: lc?['OTTemplateID'],
        acceptsOT: lc?['acceptsOT'],
        timeType: lc?['timeType'],
        timeTypeDescription: lc?['timeTypeDescription'],
        splitShifts: lc?['splitShifts'],
        splitWeekends: lc?['splitWeekends'],
        splitHolidays: lc?['splitHolidays'],
        useClientPayModifiers: lc?['useClientPayModifiers'],
        payHolidayRate: lc?['payHolidayRate'],
        payHolidayPlusRate: lc?['PayHolidayPlusRate'],
        useClientBillModifiers: lc?['useClientBillModifiers'],
        billOTRate: lc?['billOTRate'],
        billOTPlusRate: lc?['billOTPlusRate'],
        billDblRate: lc?['billDblRate'],
        billDblPlusRate: lc?['billDblPlusRate'],
        billHolidayRate: lc?['billHolidayRate'],
        billHolidayPlusRate: lc?['billHolidayPlusRate'],
        billMaxRate: lc?['billMaxRate'],
        salesTaxId: lc?['salesTaxId'],
        useClientCreditCard: lc?['useClientCreditCard'],
        creditCardTypeCodeId: lc?['creditCardTypeCodeId'],
        creditCardNumber: lc?['creditCardNumber'],
        creditCardExpirationDate: lc?['creditCardExpirationDate'],
        cardHolderName: lc?['cardHolderName'],
        chargeIncrement: lc?['chargeIncrement'],
        chargeWhenInvoiced: lc?['chargeWhenInvoiced'],
        invoiceFormatCodeId: lc?['invoiceFormatCodeId'],
        debugPrintQueue: lc?['debugPrintQueue'],
        debugPrintQueueCopies: lc?['debugPrintQueueCopies'],
        omrQueue: lc?['omrQueue'],
        emailQueue: lc?['emailQueue'],
        emailQueuePDF: lc?['emailQueuePDF'],
        emailQueueXLS: lc?['emailQueueXLS'],
        debugPrintImages: lc?['debugPrintImages'],
        imagesPerPage: lc?['imagesPerPage'],
        invoiceComments: lc?['invoiceComments'],
        invoiceEmailTemplateId: lc?['invoiceEmailTemplateId'],
        payrollLocationId: lc?['payrollLocationId'],
        municipalityId: lc?['municipalityId'],
        municipalityName: lc?['municipalityName'],
        schoolDistrictId: lc?['schoolDistrictId'],
        schoolDistrictName: lc?['schoolDistrictName'],
        latitude: lc?['latitude'],
        longitude: lc?['longitude'],
        billMaxPlusRate: lc?['billMaxPlusRate'],
        useClientInvoicing: lc?['useClientInvoicing'],
        payMaxRate: lc?['payMaxRate'],
        useClientTax: lc?['useClientTax'],
        rateGroups: null,
      );
    }

  Map<String,dynamic> toFirestore() {
    return {
      "id" : id,
      "departmentId" : departmentId,
      "departmentAsOwnerId" : departmentAsOwnerId,
      "clientId" : clientId,
      "departmentNumber" : departmentNumber,
      "departmentName" : departmentName,
      "costCenter" : costCenter,
      "branchId" : branchId,
      "branchName" : branchName,
      "note" : note,
      "statusId" : statusId,
      "statusDescription" : statusDescription,
      "firstServicedDate" : firstServicedDate,
      "lastServicedDate" : lastServicedDate,
      "useClientPhysicalAddress" : useClientPhysicalAddress,
      "mailingAddress1" : mailingAddress1,
      "mailingAddress2" : mailingAddress2,
      "mailingCounty" : mailingCounty,
      "mailingCity" : mailingCity,
      "mailingState" : mailingState,
      "mailingZipCode" : mailingZipCode,
      "useClientBillingAddress" : useClientBillingAddress,
      "billingSameAsPhysical" : billingSameAsPhysical,
      "billingAddressName" : billingAddressName,
      "billingAddressAttention" : billingAddressAttention,
      "billingAddress1" : billingAddress1,
      "billingAddress2" : billingAddress2,
      "billingState" : billingState,
      "billingZipCode" : billingZipCode,
      "useClientPayment" : useClientPayment,
      "paymentMethodCodeId" : paymentMethodCodeId,
      "paymentTermsCodeId" : paymentTermsCodeId,
      "useClientWeek" : useClientWeek,
      "weekStartTime" : weekStartTime,
      "weekStartDay" : weekStartDay,
      "weekendStartTime" : weekendStartTime,
      "weekendStartDay" : weekendStartDay,
      "weekendEndTime" : weekendEndTime,
      "weekendEndDay" : weekendEndDay,
      "OTTemplateID" : OTTemplateID,
      "acceptsOT" : acceptsOT,
      "timeType" : timeType,
      "timeTypeDescription" : timeTypeDescription,
      "splitShifts" : splitShifts,
      "splitWeekends" : splitWeekends,
      "splitHolidays" : splitHolidays,
      "useClientPayModifiers" : useClientPayModifiers,
      "payHolidayRate" : payHolidayRate,
      "payHolidayPlusRate" : payHolidayPlusRate,
      "useClientBillModifiers" : useClientBillModifiers,
      "billOTRate" : billOTRate,
      "billOTPlusRate" : billOTPlusRate,
      "billDblRate" : billDblRate,
      "billDblPlusRate" : billDblPlusRate,
      "billHolidayRate" : billHolidayRate,
      "billHolidayPlusRate" : billHolidayPlusRate,
      "billMaxRate" : billMaxRate,
      "salesTaxId" : salesTaxId,
      "useClientCreditCard" : useClientCreditCard,
      "creditCardTypeCodeId" : creditCardTypeCodeId,
      "creditCardNumber" : creditCardNumber,
      "creditCardExpirationDate" : creditCardExpirationDate,
      "cardHolderName" : cardHolderName,
      "chargeIncrement" : chargeIncrement,
      "chargeWhenInvoiced" : chargeWhenInvoiced,
      "invoiceFormatCodeId" : invoiceFormatCodeId,
      "debugPrintQueue" : debugPrintQueue,
      "debugPrintQueueCopies" : debugPrintQueueCopies,
      "omrQueue" : omrQueue,
      "emailQueue" : emailQueue,
      "emailQueuePDF" : emailQueuePDF,
      "emailQueueXLS" : emailQueueXLS,
      "debugPrintImages" : debugPrintImages,
      "imagesPerPage" : imagesPerPage,
      "invoiceComments" : invoiceComments,
      "invoiceEmailTemplateId" : invoiceEmailTemplateId,
      "payrollLocationId" : payrollLocationId,
      "municipalityId" : municipalityId,
      "municipalityName" : municipalityName,
      "schoolDistrictId" : schoolDistrictId,
      "schoolDistrictName" : schoolDistrictName,
      "latitude" : latitude,
      "longitude" : longitude,
      "ownerId" : ownerId,
      "billingCity" : billingCity,
      "billMaxPlusRate" : billMaxPlusRate,
      "useClientInvoicing" : useClientInvoicing,
      "payMaxRate" : payMaxRate,
      "useClientTax" : useClientTax,
      "rateGroups" : rateGroups
    };
  }
// @override
// String toString() {
//   return 'ClientDepartment(name: $departmentName, id: $departmentId)';
// }
int get departmentID {
  return departmentId;
}
String get departmentNAME {
  return departmentName;
}
List<dynamic> get rateGROUPS {
  return rateGroups!;
}
}


