import 'package:cloud_firestore/cloud_firestore.dart';

// Client clientFromJson(String str) => Client,fromJson(json,decode(str));
//
// String clientToJson(Client data) => json,encode(data,toJson());

class Client {
  const Client(
      {
      //   required this.mongodbId,
      required this.id,
      required this.clientId,
      required this.clientNumber,
      required this.clientName,
      required this.clientTypeCodeId,
      required this.clientType,
      required this.sicCodeId,
      required this.sicCodeDescription,
      required this.groupCodeId,
      required this.groupCodeDescription,
      required this.statusId,
      required this.clientStatusDescription,
      required this.branchId,
      required this.branchName,
      required this.note,
      required this.overtimeRule,
      required this.dateFirstServiced,
      required this.dateLastServiced,
      required this.billingSameAsPhysical,
      required this.payrollLocationId,
      required this.billByCodeId,
      required this.billByCodeDescription,
      required this.splitShifts,
      required this.acceptsOT,
      required this.timeType,
      required this.timeTypeDescription, //added
      required this.billingOTRate,
      required this.billingOTPlusRate,
      required this.billingDblRate,
      required this.billingDblPlusRate,
      required this.billingHolidayRate,
      required this.billingHolidayPlusRate,
      required this.billingMaxRate,
      required this.billingMaxPlusRate,
      required this.facilityCancelLimit,
      required this.facilityCancelCharge,
      required this.agencyCancelLimit,
      required this.agencyCancelCharge,
      required this.weekStartDay,
      required this.weekStartTime,
      required this.weekendStartDay,
      required this.weekendStartTime,
      required this.weekendEndDay,
      required this.weekendDayStartTime,
      required this.otTemplateId,
      required this.nationalClient,
      required this.billingGroupCodeId,
      required this.billingGroupDescription,
      required this.discount,
      required this.discountTypeCodeId,
      required this.discountTypeDescription,
      required this.timeCardImageOptionId,
      required this.consolidated, //added
      required this.salesTaxId,
      required this.payorId,
      required this.paymentMethodCodeId,
      required this.paymentMethodDescription,
      required this.paymentTermsCodeId,
      required this.paymentTermsDescription,
      required this.financeCharge,
      required this.financeChargeRate,
      required this.creditCardTypeCodeId,
      required this.creditCardTypeDescription,
      required this.creditCardNumber,
      required this.expirationDate,
      required this.cardHolderName,
      required this.chargeIncrement,
      required this.chargeWhenInvoiced,
      required this.invoiceSeparationCodeId,
      required this.maxShiftsPerInvoice,
      required this.maxAmountPerInvoice,
      required this.debugPrintQueue,
      required this.omrQueue,
      required this.emailQueue,
      required this.debugPrintQueueCopies,
      required this.emailQueuePDF,
      required this.emailQueueXLS,
      required this.debugPrintImages,
      required this.imagesPerPage,
      required this.invoiceComments,
      required this.creditStatusCodeId,
      required this.creditStatusDescription,
      required this.creditLimit,
      required this.creditDeclineReasonCodeId,
      required this.creditDeclineReasonDescription,
      required this.creditPreApprovedAmount,
      required this.creditScoreCodeId,
      required this.creditScoreDescription,
      required this.creditWarn,
      required this.creditSuspend,
      required this.warnCreditLimitAmount,
      required this.suspendCreditLimitAmount,
      required this.weeklyCreditLimit,
      required this.weekCreditLimitAmount,
      required this.weekCreditLimitReasonCodeId,
      required this.weeklyCreditLimitReasonDescription,
      required this.schoolDistrictId,
      required this.schoolDistrictName,
      required this.municipalityId,
      required this.municipalityName,
      required this.boCurrentBalance,
      required this.boOpenCredit,
      required this.boMTDBilling,
      required this.boMTDPaid,
      required this.boYTDBilling,
      required this.boYTDPaid,
      required this.boFirstInvoiced,
      required this.boLastInvoiced,
      required this.gpoClient,
      required this.invoiceFrequencyCodeId,
      required this.invoiceFrequencyDescription,
      required this.billingGroupMaster,
      required this.boLastPaidAmount,
      required this.lastPaidDate,
      required this.billIncludeOnCallOT,
      required this.invoiceEmailTemplateId,
      required this.defaultWorkersCompCodeId,
      required this.defaultWorkersCompDescription,
      required this.accountManagerUserId,
      required this.accountManageName,
      required this.numberOfBeds,
      required this.numberOfFacilities,
      required this.businessLineCodeId,
      required this.businessLineDescription,
      required this.billingGroup,
      required this.billingClientName,
      required this.billingAttention,
      required this.billingCodeName,
      required this.payorName,
      required this.startWeekDay,
      required this.startWeekTime,
      required this.startWeekendDay,
      required this.startWeekEndTime,
      required this.endWeekendDay,
      required this.endWeekEndTime,
      required this.overTimeRule,
      required this.schoolDistrict,
      required this.clientGroupCode,
      required this.clientGroupDescription,
      required this.createdDate,
      required this.clientRating,
      required this.disciplinesServiced,
      required this.splitWeekends, //added
      required this.splitHolidays, //added
      required this.payOT,
      required this.payOTPlus,
      required this.payDbl,
      required this.payDblPlus,
      required this.FICAExempt,
      required this.noQueue,
      required this.allowTimesheets,
      required this.verifyTimesheets,
      required this.includeTimesheetsOnInvoices,
      required this.clientRatingCodeId,
      required this.latitude,
      required this.longitude,
      required this.lastUpdated,
      required this.verifyTimesheetsBySignature,
      required this.timeclockEnabled,
      required this.timeclockRadius,
      required this.timeclockGeoFenceEnforced,
      required this.timeclockLocationServicesRequired, //added
      required this.creditDeclinedReasonCodeId,
      required this.creditDeclinedReason,
      required this.weeklyCreditLimitAmount,
      required this.weeklyCreditLimitReasonCodeId,
      required this.weeklyCreditLimitReason,
      required this.businessLineDesc,
      required this.accountManagerTitle, //moved
      required this.administratorUserId, //added
      required this.administrator, //added
      required this.administratorTitle});
  // final ObjectId mongodbId;
  final String id;
  final int clientId;
  final String clientNumber;
  final String clientName;
  final int clientTypeCodeId;
  final String? clientType;
  final int sicCodeId;
  final String? sicCodeDescription;
  final dynamic groupCodeId;
  final String? groupCodeDescription;
  final String statusId;
  final String? clientStatusDescription;
  final int branchId;
  final String? branchName;
  final String? note;
  final String? overtimeRule;
  final Timestamp? dateFirstServiced;
  final Timestamp? dateLastServiced;
  final bool billingSameAsPhysical;
  final String? payrollLocationId;
  final int? billByCodeId;
  final String? billByCodeDescription;
  final bool splitShifts;
  final bool acceptsOT;
  final String timeType;
  final String timeTypeDescription; //added
  final double billingOTRate;
  final double billingOTPlusRate;
  final double billingDblRate;
  final double billingDblPlusRate;
  final double billingHolidayRate;
  final double billingHolidayPlusRate;
  final double billingMaxRate;
  final double billingMaxPlusRate;
  final double facilityCancelLimit;
  final double facilityCancelCharge;
  final double agencyCancelLimit;
  final double agencyCancelCharge;
  final int weekStartDay;
  final Timestamp? weekStartTime;
  final int weekendStartDay;
  final Timestamp? weekendStartTime;
  final int weekendEndDay;
  final Timestamp? weekendDayStartTime;
  final int otTemplateId;
  final bool nationalClient;
  final String? billingGroupCodeId;
  final String? billingGroupDescription;
  final double discount;
  final String? discountTypeCodeId;
  final String? discountTypeDescription;
  final int timeCardImageOptionId;
  final bool consolidated; //added
  final String? salesTaxId;
  final String? payorId;
  final String? paymentMethodCodeId;
  final String? paymentMethodDescription;
  final String? paymentTermsCodeId;
  final String? paymentTermsDescription;
  final bool financeCharge;
  final double financeChargeRate;
  final String? creditCardTypeCodeId;
  final String? creditCardTypeDescription;
  final String? creditCardNumber;
  final Timestamp? expirationDate;
  final String? cardHolderName;
  final double chargeIncrement;
  final bool chargeWhenInvoiced;
  final int invoiceSeparationCodeId;
  final int maxShiftsPerInvoice;
  final double maxAmountPerInvoice;
  final bool debugPrintQueue;
  final bool omrQueue;
  final bool emailQueue;
  final int debugPrintQueueCopies;
  final bool emailQueuePDF;
  final bool emailQueueXLS;
  final bool debugPrintImages;
  final int imagesPerPage;
  final String? invoiceComments;
  final int creditStatusCodeId;
  final String? creditStatusDescription;
  final double creditLimit;
  final String? creditDeclineReasonCodeId;
  final String? creditDeclineReasonDescription;
  final double creditPreApprovedAmount;
  final String? creditScoreCodeId;
  final String? creditScoreDescription;
  final bool creditWarn;
  final bool creditSuspend;
  final double warnCreditLimitAmount;
  final double suspendCreditLimitAmount;
  final bool weeklyCreditLimit;
  final double weekCreditLimitAmount;
  final String? weekCreditLimitReasonCodeId;
  final String? weeklyCreditLimitReasonDescription;
  final String? schoolDistrictId;
  final String? schoolDistrictName;
  final String? municipalityId;
  final String? municipalityName;
  final double boCurrentBalance;
  final double boOpenCredit;
  final double boMTDBilling;
  final double boMTDPaid;
  final double boYTDBilling;
  final double boYTDPaid;
  final Timestamp? boFirstInvoiced;
  final Timestamp? boLastInvoiced;
  final bool gpoClient;
  final int invoiceFrequencyCodeId;
  final String? invoiceFrequencyDescription;
  final bool billingGroupMaster;
  final double boLastPaidAmount;
  final Timestamp? lastPaidDate;
  final bool billIncludeOnCallOT;
  final int invoiceEmailTemplateId;
  final int defaultWorkersCompCodeId;
  final String? defaultWorkersCompDescription;
  final String? accountManagerUserId;
  final String? accountManageName;
  final int numberOfBeds;
  final int numberOfFacilities;
  final int? businessLineCodeId;
  final String? businessLineDescription;
  final String? billingGroup;
  final String? billingClientName;
  final String? billingAttention;
  final String? billingCodeName;
  final String? payorName;
  final String? startWeekDay;
  final Timestamp? startWeekTime;
  final String? startWeekendDay;
  final String? startWeekEndTime;
  final String? endWeekendDay;
  final String? endWeekEndTime;
  final String? overTimeRule;
  final String? schoolDistrict;
  final String? clientGroupCode;
  final String? clientGroupDescription;
  final Timestamp? createdDate;
  final String? clientRating;
  final List<String> disciplinesServiced;
  final bool splitWeekends; //added
  final bool splitHolidays; //added
  final double payOT;
  final double payOTPlus;
  final double payDbl;
  final double payDblPlus;
  final bool FICAExempt;
  final bool noQueue;
  final bool allowTimesheets;
  final bool verifyTimesheets;
  final bool includeTimesheetsOnInvoices;
  final int? clientRatingCodeId;
  final double latitude;
  final double longitude;
  final Timestamp? lastUpdated;
  final bool verifyTimesheetsBySignature;
  final bool timeclockEnabled;
  final int? timeclockRadius;
  final bool timeclockGeoFenceEnforced;
  final bool timeclockLocationServicesRequired; //added
  final String? creditDeclinedReasonCodeId;
  final String? creditDeclinedReason;
  final double weeklyCreditLimitAmount;
  final String? weeklyCreditLimitReasonCodeId;
  final String? weeklyCreditLimitReason;
  final String? businessLineDesc;
  final String? accountManagerTitle; //moved
  final String? administratorUserId; //added
  final String? administrator; //added
  final String? administratorTitle;

  factory Client.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Client(
        id: data?["id"],
        clientId: data?["clientId"],
        clientNumber: data?["clientNumber"],
        clientName: data?["clientName"],
        clientTypeCodeId: data?["clientTypeCodeId"],
        clientType: data?["clientType"],
        sicCodeId: data?["sicCodeId"] ?? 0,
        sicCodeDescription: data?["sicCodeDescription"],
        groupCodeId: data?["groupCodeId"],
        groupCodeDescription: data?["groupCodeDescription"],
        statusId: data?["statusId"],
        clientStatusDescription: data?["clientStatusDescription"],
        branchId: data?["branchId"],
        branchName: data?["branchName"],
        note: data?["note"],
        overtimeRule: data?["overtimeRule"],
        dateFirstServiced: data?["dateFirstServiced"],
        dateLastServiced: data?["dateLastServiced"],
        billingSameAsPhysical: data?["billingSameAsPhysical"],
        payrollLocationId: data?["payrollLocationId"],
        billByCodeId: data?["billByCodeId"],
        billByCodeDescription: data?["billByCodeDescription"],
        splitShifts: data?["splitShifts"],
        acceptsOT: data?["acceptsOT"],
        timeType: data?["timeType"],
        timeTypeDescription: data?["timeTypeDescription"], //added
        billingOTRate: data?["billingOTRate"],
        billingOTPlusRate: data?["billingOTPlusRate"],
        billingDblRate: data?["billingDblRate"],
        billingDblPlusRate: data?["billingDblPlusRate"],
        billingHolidayRate: data?["billingHolidayRate"],
        billingHolidayPlusRate: data?["billingHolidayPlusRate"],
        billingMaxRate: data?["billingMaxRate"],
        billingMaxPlusRate: data?["billingMaxPlusRate"],
        facilityCancelLimit: data?["facilityCancelLimit"],
        facilityCancelCharge: data?["facilityCancelCharge"],
        agencyCancelLimit: data?["agencyCancelLimit"],
        agencyCancelCharge: data?["agencyCancelCharge"] ?? 0,
        weekStartDay: data?["weekStartDay"],
        weekStartTime: data?["weekStartTime"],
        weekendStartDay: data?["weekendStartDay"],
        weekendStartTime: data?["weekendStartTime"],
        weekendEndDay: data?["weekendEndDay"],
        weekendDayStartTime: data?["weekendDayStartTime"],
        otTemplateId: data?["otTemplateId"],
        nationalClient: data?["nationalClient"],
        billingGroupCodeId: data?["billingGroupCodeId"],
        billingGroupDescription: data?[" billingGroupDescription"],
        discount: data?["discount"],
        discountTypeCodeId: data?["discountTypeCodeId"],
        discountTypeDescription: data?["discountTypeDescription"],
        timeCardImageOptionId: data?["timeCardImageOptionId"] ?? 0,
        consolidated: data?["consolidated"], //added
        salesTaxId: data?["salesTaxId"],
        payorId: data?["payorId"],
        paymentMethodCodeId: data?["paymentMethodCodeId"],
        paymentMethodDescription: data?["paymentMethodDescription"],
        paymentTermsCodeId: data?[" paymentTermsCodeId:"],
        paymentTermsDescription: data?["paymentTermsDescription"],
        financeCharge: data?["financeCharge"],
        financeChargeRate: data?["financeChargeRate"],
        creditCardTypeCodeId: data?["creditCardTypeCodeId"],
        creditCardTypeDescription: data?["creditCardTypeDescription"],
        creditCardNumber: data?["creditCardNumber"],
        expirationDate: data?["expirationDate"],
        cardHolderName: data?["cardHolderName"],
        chargeIncrement: data?["chargeIncrement"] ?? 0,
        chargeWhenInvoiced: data?["chargeWhenInvoiced"] ?? false,
        invoiceSeparationCodeId: data?["invoiceSeparationCodeId"] ?? 0,
        maxShiftsPerInvoice: data?["maxShiftsPerInvoice"] ?? 0,
        maxAmountPerInvoice: data?["maxAmountPerInvoice"] ?? 0,
        debugPrintQueue: data?["debugPrintQueue"] ?? false,
        omrQueue: data?["omrQueue"] ?? false,
        emailQueue: data?["emailQueue"] ?? false,
        debugPrintQueueCopies: data?["debugPrintQueueCopies"] ?? 0,
        emailQueuePDF: data?["emailQueuePDF"] ?? false,
        emailQueueXLS: data?["emailQueueXLS"] ?? false,
        debugPrintImages: data?["debugPrintImages"] ?? false,
        imagesPerPage: data?["imagesPerPage"] ?? 0,
        invoiceComments: data?["invoiceComments"],
        creditStatusCodeId: data?["creditStatusCodeId"] ?? 0,
        creditStatusDescription: data?["creditStatusDescription"],
        creditLimit: data?["creditLimit"] ?? 0,
        creditDeclineReasonCodeId: data?["creditDeclineReasonCodeId"],
        creditDeclineReasonDescription: data?["creditDeclineReasonDescription"],
        creditPreApprovedAmount: data?["creditPreApprovedAmount"] ?? 0,
        creditScoreCodeId: data?["creditScoreCodeId"],
        creditScoreDescription: data?["creditScoreDescription"],
        creditWarn: data?["creditWarn"] ?? false,
        creditSuspend: data?["creditSuspend"] ?? false,
        warnCreditLimitAmount: data?["warnCreditLimitAmount"] ?? 0,
        suspendCreditLimitAmount: data?["suspendCreditLimitAmount"] ?? 0,
        weeklyCreditLimit: data?["weeklyCreditLimit"] ?? false,
        weekCreditLimitAmount: data?["weekCreditLimitAmount"] ?? 0,
        weekCreditLimitReasonCodeId: data?["weekCreditLimitReasonCodeId"],
        weeklyCreditLimitReasonDescription:
            data?["weeklyCreditLimitReasonDescription"],
        schoolDistrictId: data?["schoolDistrictId"],
        schoolDistrictName: data?[" schoolDistrictName"],
        municipalityId: data?["municipalityId:"],
        municipalityName: data?["municipalityName"],
        boCurrentBalance: data?["boCurrentBalance"] ?? 0,
        boOpenCredit: data?["boOpenCredit"] ?? 0,
        boMTDBilling: data?["oMTDBilling"] ?? 0,
        boMTDPaid: data?["boMTDPaid:"] ?? 0,
        boYTDBilling: data?["boYTDBilling"] ?? 0,
        boYTDPaid: data?["boYTDPaid"] ?? 0,
        boFirstInvoiced: data?["boFirstInvoiced:"],
        boLastInvoiced: data?["boLastInvoiced"],
        gpoClient: data?["gpoClient"],
        invoiceFrequencyCodeId: data?["invoiceFrequencyCodeId"],
        invoiceFrequencyDescription: data?["invoiceFrequencyDescription"],
        billingGroupMaster: data?["billingGroupMaster"] ?? false,
        boLastPaidAmount: data?["boLastPaidAmount"] ?? 0,
        lastPaidDate: data?["lastPaidDate"],
        billIncludeOnCallOT: data?["billIncludeOnCallOT"] ?? false,
        invoiceEmailTemplateId: data?["invoiceEmailTemplateId"] ?? 0,
        defaultWorkersCompCodeId: data?["defaultWorkersCompCodeId"] ?? 0,
        defaultWorkersCompDescription: data?["defaultWorkersCompDescription"],
        accountManagerUserId: data?["accountManagerUserId"],
        accountManageName: data?["accountManageName"],
        numberOfBeds: data?["numberOfBeds"] ?? 0,
        numberOfFacilities: data?["numberOfFacilities"] ?? 0,
        businessLineCodeId: data?["businessLineCodeId"] ?? 0,
        businessLineDescription: data?["businessLineDescription"],
        billingGroup: data?["billingGroup"],
        billingClientName: data?["billingClientName"],
        billingAttention: data?["billingAttention"],
        billingCodeName: data?["billingCodeName"],
        payorName: data?["payorName"],
        startWeekDay: data?["startWeekDay"],
        startWeekTime: data?["startWeekTime"],
        startWeekendDay: data?["startWeekendDay"],
        startWeekEndTime: data?["startWeekEndTime"],
        endWeekendDay: data?["endWeekendDay"],
        endWeekEndTime: data?["endWeekEndTime"],
        overTimeRule: data?["overTimeRule"],
        schoolDistrict: data?["schoolDistrict"],
        clientGroupCode: data?["clientGroupCode"],
        clientGroupDescription: data?["clientGroupDescription"],
        createdDate: data?["createdDate"],
        clientRating: data?["clientRating"],
        disciplinesServiced: data?["disciplinesServiced"] == ""
            ? []
            : [data?["disciplinesServiced"]],
        splitWeekends: data?["splitWeekends"] ?? false,
        splitHolidays: data?["splitHolidays"] ?? false,
        payOT: data?["payOT"] ?? 0,
        payOTPlus: data?["payOTPlus"] ?? 0,
        payDbl: data?["payDbl"] ?? 0,
        payDblPlus: data?["payDblPlus"] ?? 0,
        FICAExempt: data?["FICAExempt"] ?? false,
        noQueue: data?["noQueue"] ?? false,
        allowTimesheets: data?["allowTimesheets"] ?? false,
        verifyTimesheets: data?["verifyTimesheets"] ?? false,
        includeTimesheetsOnInvoices:
            data?["includeTimesheetsOnInvoices"] ?? false,
        clientRatingCodeId: data?["clientRatingCodeId"] ?? 0,
        latitude: data?["latitude"],
        longitude: data?["longitude"],
        lastUpdated: data?["lastUpdated"],
        verifyTimesheetsBySignature:
            data?["verifyTimesheetsBySignature"] ?? false,
        timeclockEnabled: data?["timeclockEnabled"] ?? false,
        timeclockRadius: data?[" timeclockRadius"] ?? 0,
        timeclockGeoFenceEnforced: data?["timeclockGeoFenceEnforced"] ?? false,
        timeclockLocationServicesRequired:
            data?["timeclockLocationServicesRequired"] ?? false,
        creditDeclinedReasonCodeId: data?["creditDeclinedReasonCodeId"],
        creditDeclinedReason: data?["creditDeclinedReason"],
        weeklyCreditLimitAmount: data?["weeklyCreditLimitAmount"] ?? 0,
        weeklyCreditLimitReasonCodeId: data?["weeklyCreditLimitReasonCodeId"],
        weeklyCreditLimitReason: data?["weeklyCreditLimitReason"],
        businessLineDesc: data?["businessLineDesc"],
        accountManagerTitle: data?["accountManagerTitle"], //moved
        administratorUserId: data?["administratorUserId"], //added
        administrator: data?["administrator"], //added
        administratorTitle: data?["administratorTitle"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      //0
      'id': id,
      'clientId': clientId,
      //1
      'clientNumber': clientNumber,
      //2
      'clientName': clientName,
      //3
      'clientTypeCodeId': clientTypeCodeId,
      //4
      // if (clientTypeDescription  !=  '') {
      //   'clientTypeDescription': clientTypeDescription,
      // }
      if (sicCodeId != '') 'sicCodeId': sicCodeId,
      if (sicCodeDescription != null && sicCodeDescription != '')
        //6
        'sicCodeDescription': sicCodeDescription,

      if (groupCodeId != '' && groupCodeId != null)
        //7
        'groupCodeId': int.tryParse(groupCodeId.toString()),
      if (groupCodeDescription != '')
        //8
        'groupCodeDescription': groupCodeDescription,

      //9
      'statusId': statusId,
      //10
      if (clientStatusDescription != '')
        'clientStatusDescription': clientStatusDescription,

      // 'clientStatusDescription': clientStatusDescription,
      //11
      ' branchId': branchId,
      //12
      'branchName': branchName,
      //13
      'note': note,
      //14
      'overTimeRule': note,
      if (dateFirstServiced != null)
        //15
        'dateFirstServiced': dateFirstServiced,

      if (dateLastServiced != null)
        //16
        'dateLastServiced': dateLastServiced,

      if (payrollLocationId != '')
        //17
        'payrollLocationId': payrollLocationId,

      if (billByCodeId != null && billByCodeId != '')
        //18
        'billByCodeId': billByCodeId,

      if (billByCodeDescription != null && billByCodeDescription != '')
        //19
        '(billByCodeDescription': billByCodeDescription,

      //20
      'splitShifts': splitShifts,
      //21
      'acceptsOt': acceptsOT,
      //22
      'timeType': timeType,
      //23
      'timeTypeDescription': timeTypeDescription,
      //24
      'billingOTRate': billingOTRate,
      //25
      'billingOTPlusRate': billingOTPlusRate,
      //26
      'billingDblRate': billingDblRate,
      //27
      'billingDblPlusRate': billingDblPlusRate,
      //28
      'billingHolidayRate': billingHolidayRate,
      //29
      'billingHolidayPlusRate': billingHolidayPlusRate,
      //30
      'billingMaxRate': billingMaxRate,
      //31
      'billingMaxPlusRate': billingMaxPlusRate,
      //32
      'facilityCancelLimit': facilityCancelLimit,
      //33
      'facilityCancelCharge': facilityCancelCharge,
      //34
      'agencyCancelLimit': agencyCancelLimit,
      //35
      'agencyCancelCharge': agencyCancelCharge,
      //36
      'weekStartDay': weekStartDay,
      //37
      'weekStartTime': weekStartTime,
      //38
      'weekendStartDay': weekendStartDay,
      //39
      'weekendStartTime': weekendStartTime,
      //40
      'weekendEndDay': weekendEndDay,
      //41
      'weekendDayStartTime': weekendDayStartTime,
      //42
      'nationalClient': nationalClient,
      //43
      'consolidated': consolidated,
      //44
      'billingSameAsPhysical': billingSameAsPhysical,
      //45
      'splitWeekends': splitWeekends,
      //46
      'splitHolidays': splitHolidays,
      //47
      if (defaultWorkersCompCodeId != '')
        'defaultWorkersCompId': defaultWorkersCompCodeId,

      //48
      'payOT': payOT,
      //49
      'payOTPlus': payOTPlus,
      //50
      'payDbl': payDbl,
      //51
      'payDblPlus': payDblPlus,
      //52
      'FICAExempt': FICAExempt,
      //53
      'NOQueue': noQueue,
      //54
      'allowTimesheets': allowTimesheets,
      //55
      'verifyTimesheets': verifyTimesheets,
      //56
      'includeTimesheetsOnInvoices': includeTimesheetsOnInvoices,
      //57
      'createdDate': createdDate,
      //58
      if (clientRatingCodeId != '') 'clientRatingCodeId': clientRatingCodeId,

      //59
      'numberOfBeds': numberOfBeds,
      //60
      'numberOfFacilities': numberOfFacilities,
      //61
      'latitude': latitude,
      //62
      'longitude': longitude,
      //63
      'businessLineCodeId': businessLineCodeId,
      //64
      'lastUpdated': lastUpdated,
      //65
      'verifyTimesheetsBySignature': verifyTimesheetsBySignature,
      //66
      'timeclockEnabled': timeclockEnabled,
      //67
      'timeclockRadius': timeclockRadius,
      //68
      'timeclokcGeoFenceEnforced': timeclockGeoFenceEnforced,
      //69
      'timeclockLocationServicesRequired': timeclockLocationServicesRequired,
      //70
      //   if (creditStatusCodeId != '') {
      //     'creditStatusCodeId': creditStatusCodeId,
      //     //71
      //     'creditStatusCodeDescription': creditStatusCodeDescription,
      //
      //   }
      //72
      'creditLimit': creditLimit,
      //73
      if (creditDeclinedReasonCodeId != '')
        'creditDeclinedReasonCodeId': creditDeclinedReasonCodeId,
      //74
      'creditDeclinedReason': creditDeclinedReason,

      //75
      'creditPreApprovedAmount': creditPreApprovedAmount,
      //76
      if (creditScoreCodeId != '') 'creditScoreCodeId': creditScoreCodeId,

      //77
      'creditWarn': creditWarn,
      //78
      'creditSuspend': creditSuspend,
      //79
      'warnCreditLimitAmount': warnCreditLimitAmount,
      //80
      'suspendCreditLimitAmount': suspendCreditLimitAmount,
      //81
      'weeklyCreditLimitAmount': weeklyCreditLimitAmount,
      //82
      if (weeklyCreditLimitReasonCodeId != '')
        'weeklyCreditLimitReasonCodeId': weeklyCreditLimitReasonCodeId,

      //83
      'weeklyCreditLimitReason': weeklyCreditLimitReason,
      //84
      if (disciplinesServiced != []) 'disciplinesServiced': disciplinesServiced,

      //85
      if (businessLineDesc != '') 'businessLineDesc': businessLineDesc,

      //86
      if (accountManagerUserId != '')
        'accountManagerUserId': accountManagerUserId,

      //87
      // if (accountManager != '') {
      //   'accountManager': accountManager,
      // }
      //88

      if (accountManagerTitle != '') 'accountManagerTitle': accountManagerTitle,

      //89
      if (administratorUserId != '') 'administratorUserId': administratorUserId,
      //90
      if (administrator != '') 'administrator': administrator,

      //91
      if (administratorTitle != '') 'administratorTitle': administratorTitle
    };
  }
}
