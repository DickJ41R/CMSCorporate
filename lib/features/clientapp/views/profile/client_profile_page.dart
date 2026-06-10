//Client Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:flutter/services.dart';

class ClientProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientProfilePage({super.key, required this.args});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final formKey = GlobalKey<FormState>();
  ClientServices clientServices = ClientServices();
  Map<String, dynamic>? arguments;
  Map<String, dynamic> clientMap = {};
  UtilitiesServices utilityServices = UtilitiesServices();

  String? localTitle;
  //section 1
//section 1
  TextEditingController clientIdController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientNumberController = TextEditingController();
  TextEditingController clientGroupCodeController = TextEditingController();
  TextEditingController clientGroupDescriptionController =
      TextEditingController();
  TextEditingController startWeekendDayController = TextEditingController();
  TextEditingController statusIdController = TextEditingController();
  TextEditingController deletedController = TextEditingController();
  TextEditingController clientRatingController = TextEditingController();
  TextEditingController clientRatingCodeIdController = TextEditingController();
  TextEditingController clientStatusController = TextEditingController();
  TextEditingController clientStatusDescriptionController =
      TextEditingController();
  TextEditingController clientTypeController = TextEditingController();
  TextEditingController clientTypeCodeIdController = TextEditingController();
  TextEditingController branchIdController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController numberOfBedsController = TextEditingController();
  TextEditingController numberOfFacilitiesController = TextEditingController();
  TextEditingController disciplinesServicedController = TextEditingController();
  TextEditingController acceptsOTController = TextEditingController();
  TextEditingController accountManagerController = TextEditingController();
  TextEditingController accountManagerUserIdController =
      TextEditingController();
  TextEditingController businessLineCodeIdController = TextEditingController();
  TextEditingController consolidatedController = TextEditingController();
  TextEditingController createdDateController = TextEditingController();
  TextEditingController dateLastServicedController = TextEditingController();
  TextEditingController daylightSavingsController = TextEditingController();
  TextEditingController defaultWorkersCompCodeDescriptionController =
      TextEditingController();
  TextEditingController defaultWorkersCompCodeIdController =
      TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController sicCodeController = TextEditingController();
//section 2
  TextEditingController discountController = TextEditingController();
  TextEditingController billByCodeDescriptionController =
      TextEditingController();
  TextEditingController billByCodeIdController = TextEditingController();
  TextEditingController billingDblPlusRateController = TextEditingController();
  TextEditingController billingDblRateController = TextEditingController();
  TextEditingController billingHolidayPlusRateController =
      TextEditingController();
  TextEditingController billingHolidayRateController = TextEditingController();
  TextEditingController billingMaxPlusRateController = TextEditingController();
  TextEditingController billingMaxRateController = TextEditingController();
  TextEditingController billingOTPlusRateController = TextEditingController();
  TextEditingController billingOTRateController = TextEditingController();
  TextEditingController billingSameAsPhysicalController =
      TextEditingController();
  TextEditingController boFirstInvoiceController = TextEditingController();
  TextEditingController boLastInvoiceController = TextEditingController();
  TextEditingController boLastPaidDateController = TextEditingController();
  TextEditingController payHolidayPlusRateController = TextEditingController();
  TextEditingController payHolidayRateController = TextEditingController();
  TextEditingController payMaxPlusRateController = TextEditingController();
  TextEditingController payMaxRateController = TextEditingController();
  TextEditingController paymentTermsCodeIdController = TextEditingController();
  TextEditingController payorIdController = TextEditingController();
  TextEditingController payorNameController = TextEditingController();
  TextEditingController payrollLocationIdController = TextEditingController();
  TextEditingController imagesPerPageController = TextEditingController();
  TextEditingController includeTimesheetsOnInvoicesController =
      TextEditingController();
  TextEditingController invoiceCommentsController = TextEditingController();
  TextEditingController invoiceEmailTemplateIdController =
      TextEditingController();
  TextEditingController invoiceFormatCodeIdController = TextEditingController();
  TextEditingController invoiceFrequencyCodeIdController =
      TextEditingController();
  TextEditingController invoiceProfileIdController = TextEditingController();
  TextEditingController zoneValueController = TextEditingController();
  //section 3
  TextEditingController endWeekendDayController = TextEditingController();
  TextEditingController endWeekendTimeController = TextEditingController();
  TextEditingController lastUpdatedController = TextEditingController();
  TextEditingController migrationClientIdController = TextEditingController();
  TextEditingController municipalityIdController = TextEditingController();
  TextEditingController municipalityNameController = TextEditingController();
  TextEditingController nationalClientController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController noteHTMLController = TextEditingController();
  TextEditingController otTemplateIdController = TextEditingController();
  TextEditingController overtimeRuleController = TextEditingController();
  TextEditingController debugPrintImagesController = TextEditingController();
  TextEditingController debugPrintQueueController = TextEditingController();
  TextEditingController salesTaxIdController = TextEditingController();
  TextEditingController schoolDistrictController = TextEditingController();
  TextEditingController schoolDistrictIdController = TextEditingController();
  TextEditingController schoolDistrictNameController = TextEditingController();
  TextEditingController splitHolidaysController = TextEditingController();
  TextEditingController splitShiftsController = TextEditingController();
  TextEditingController splitWeekendsController = TextEditingController();
  TextEditingController startWeekDayController = TextEditingController();
  TextEditingController startWeekEndTimeController = TextEditingController();
  TextEditingController startWeekTimeController = TextEditingController();
  TextEditingController timeTypeController = TextEditingController();
  TextEditingController timeTypeDescriptionController = TextEditingController();
  TextEditingController timeclockEnabledController = TextEditingController();
  TextEditingController timeclockGeoFenceEnforcedController =
      TextEditingController();
  TextEditingController timeclockLatitudeController = TextEditingController();
  TextEditingController timeclockLocationServicesRequiredController =
      TextEditingController();
  TextEditingController timeclockLongitudeController = TextEditingController();
  TextEditingController timeclockRadiusController = TextEditingController();
  //section 4
  TextEditingController facilityCancelChargeController =
      TextEditingController();
  TextEditingController facilityCancelLimitController = TextEditingController();
  TextEditingController ficaExemptController = TextEditingController();
  TextEditingController financeChargeController = TextEditingController();
  TextEditingController financeChargeRateController = TextEditingController();
  TextEditingController fsmBillingController = TextEditingController();
  TextEditingController fsmFacilityIdController = TextEditingController();
  TextEditingController fsmFacilityNameController = TextEditingController();
  TextEditingController fsmLinkedController = TextEditingController();
  TextEditingController gpoClientController = TextEditingController();
  TextEditingController groupCodeDescriptionController =
      TextEditingController();
  TextEditingController groupCodeIdController = TextEditingController();
  TextEditingController orientationController = TextEditingController();
  TextEditingController agencyCancelCreditController = TextEditingController();
  TextEditingController agencyCancelLimitController = TextEditingController();
  TextEditingController maxAmountPerInvoiceController = TextEditingController();
  TextEditingController maxShiftsPerInvoiceController = TextEditingController();
  TextEditingController noQueueController = TextEditingController();
  TextEditingController omrQueueController = TextEditingController();
  TextEditingController emailQueueController = TextEditingController();
  TextEditingController emailQueuePDFController = TextEditingController();
  TextEditingController emailQueueXLSController = TextEditingController();
  TextEditingController verifyTimeSheetsController = TextEditingController();
  TextEditingController verifyTimesheetsBySignatureController =
      TextEditingController();
  TextEditingController weekStartDayController = TextEditingController();
  TextEditingController weekStartTimeController = TextEditingController();
  TextEditingController weekendEndDayController = TextEditingController();
  TextEditingController weekendEndTimeController = TextEditingController();
  TextEditingController weekendStartDayController = TextEditingController();
  TextEditingController weekendStartTimeController = TextEditingController();
  TextEditingController allowTimeSheetsController = TextEditingController();

  int? clientId;

  Future<void> getClientMap() async {
    debugPrint('line 57 get client : $clientId');
    List<Map<String, dynamic>>? listClients;
    Map<String, dynamic>? cli = await clientServices.getClient(clientId!);
    //   debugPrint('line 177: ${cli!}');
    clientIdController.text = cli!['clientId'].toString();
    clientNameController.text = cli['clientName'];
    clientNumberController.text = cli['clientNumber'];
    clientGroupCodeController.text =
        cli['clientGroupCode'] == null ? "" : cli['clientGroupCode'];
    clientGroupDescriptionController.text =
        cli['clientGroupCodeDescription'] == null
            ? ""
            : cli['clientGroupCodeDescription'];
    startWeekendDayController.text = cli['startWeekendDay'];
    statusIdController.text = cli['statusId'];
    deletedController.text = cli['deleted'] == false ? 'false' : 'true';
    clientRatingController.text =
        cli['clientRating'] == null ? "" : cli['clientRating'];
    clientRatingCodeIdController.text = cli['clientRatingCodeId'] == null
        ? "0"
        : cli['clientRatingCodeId'].toString();
    clientStatusController.text =
        cli['clientStatus'] == null ? "" : cli['clientStatus'];
    clientStatusDescriptionController.text = cli['clientStatusDescription'];
    clientTypeController.text =
        cli['clientType'] == null ? "" : cli['clientType'];
    clientTypeCodeIdController.text = cli['clientTypeCodeId'].toString();
    branchIdController.text = cli['branchId'].toString();
    branchNameController.text = cli['branchName'];
    numberOfBedsController.text = cli['numberOfBeds'].toString();
    numberOfFacilitiesController.text = cli['numberOfFacilities'].toString();
    disciplinesServicedController.text = cli['disciplinesServiced'];
    acceptsOTController.text = cli['acceptsOT'] == false ? 'false' : 'true';
    accountManagerController.text =
        cli['accountManager'] == null ? "" : cli['accountManager'];
    accountManagerUserIdController.text = cli['accountManagerUserId'] == null
        ? ""
        : cli['accountManagerUserId'].toString();
    businessLineCodeIdController.text = cli['businessLineCodeId'] == null
        ? ""
        : cli['businessLineCodeId'].toString();
    consolidatedController.text =
        cli['consolidated'] == false ? 'false' : 'true';
    createdDateController.text =
        utilityServices.convertFromTimestamp(cli['createdDate']);
    dateLastServicedController.text =
        utilityServices.convertFromTimestamp(cli['dateLastServiced']);
    daylightSavingsController.text =
        cli['dayLightSavings'] == false ? 'false' : 'true';
    defaultWorkersCompCodeDescriptionController.text =
        cli['defaultWorkersCompCodeDescription'] == null
            ? ""
            : cli['defaultWorkersCompCodeDescription'].toString();
    defaultWorkersCompCodeIdController.text =
        cli['defaultWorkersCompCodeId'] == null
            ? "0"
            : cli['defaultWorkersCompCodeId'].toString();
    latitudeController.text =
        cli['latitude'] == null ? "0.0" : cli['latitude'].toString();
    longitudeController.text =
        cli['longitude'] == null ? "0.0" : cli['longitude'].toString();
    sicCodeController.text = cli['sicCode'] == null ? "" : cli['sicCode'];
    //section 2
    discountController.text =
        cli['discount'] == null ? "0.0" : cli['discount'].toString();
    billByCodeDescriptionController.text = cli['billByCodeDescription'] == null
        ? ""
        : cli['billByCodeDescription'];
    billByCodeIdController.text =
        cli['billByCodeId'] == null ? "0" : cli['billByCodeId'].toString();
    billingDblPlusRateController.text = cli['billingDblPlusRate'] == null
        ? "0.0"
        : cli['billingDblPlusRate'].toString();
    billingDblRateController.text = cli['billingDblRate'] == null
        ? "0.0"
        : cli['billingDblRate'].toString();
    billingHolidayPlusRateController.text =
        cli['billingHolidayPlusRate'] == null
            ? "0.0"
            : cli['billingHolidayPlusRate'].toString();
    billingHolidayRateController.text = cli['billingHolidayRate'] == null
        ? "0.0"
        : cli['billingHolidayRate'].toString();
    billingMaxPlusRateController.text = cli['billingMaxPlusRate'] == null
        ? "0.0"
        : cli['billingMaxPlusRate'].toString();
    billingMaxRateController.text = cli['billingMaxRate'] == null
        ? "0.0"
        : cli['billingMaxRate'].toString();
    billingOTPlusRateController.text = cli['billingOTPlusRate'] == null
        ? "0.0"
        : cli['billingOTPlusRate'].toString();
    billingOTRateController.text =
        cli['billingOTRate'] == null ? "0.0" : cli['billingOTRate'].toString();
    billingSameAsPhysicalController.text =
        cli['billingSameAsPhysical'] == false ? 'false' : 'true';
    boFirstInvoiceController.text =
        utilityServices.convertFromTimestamp(cli['boFirstInvoice']);
    boLastInvoiceController.text =
        utilityServices.convertFromTimestamp(cli['boLastInvoice']);
    boLastPaidDateController.text =
        utilityServices.convertFromTimestamp(cli['boLastPaidDate']);
    payHolidayPlusRateController.text = cli['payHolidayPlusRate'] == null
        ? "0.0"
        : cli['payHolidayPlusRate'].toString();
    payHolidayRateController.text = cli['payHolidayRate'] == null
        ? "0.0"
        : cli['payHolidayRate'].toString();
    payMaxPlusRateController.text = cli['payMaxPlusRate'] == null
        ? "0.0"
        : cli['payMaxPlusRate'].toString();
    payMaxRateController.text =
        cli['payMaxRate'] == null ? "0.0" : cli['payMaxRate'].toString();
    paymentTermsCodeIdController.text =
        cli['paymentTermsCodeId'] == null ? "" : cli['paymentTermsCodeId'];
    payorIdController.text = cli['payorId'] == null ? "" : cli['payorId'];
    payorNameController.text = cli['payorName'] == null ? "" : cli['payorName'];
    payrollLocationIdController.text =
        cli['payrollLocationId'] == null ? "" : cli['payrollLocationId'];
    imagesPerPageController.text =
        cli['imagesPerPage'] == null ? "0" : cli['imagesPerPage'].toString();
    includeTimesheetsOnInvoicesController.text =
        cli['includeTimesheetsOnInvoices'] == false ? 'false' : 'true';
    invoiceCommentsController.text =
        cli['invoiceComments'] == null ? "" : cli['invoiceComments'];
    invoiceEmailTemplateIdController.text =
        cli['invoiceEmailTemplateId'] == null
            ? "0"
            : cli['invoiceEmailTemplateId'].toString();
    invoiceFormatCodeIdController.text = cli['invoiceFormatCodeId'] == null
        ? "0"
        : cli['invoiceFormatCodeId'].toString();
    invoiceFrequencyCodeIdController.text =
        cli['invoiceFrequencyCodeId'] == null
            ? "0"
            : cli['invoiceFrequencyCodeId'].toString();
    invoiceProfileIdController.text = cli['invoiceProfileId'] == null
        ? "0"
        : cli['invoiceProfileId'].toString();
    zoneValueController.text =
        cli['zoneValue'] == null ? "" : cli['zoneValue'].toString();
    ;
    //section 3
    endWeekendDayController.text =
        cli['endWeekendDay'] == null ? "" : cli['endWeekendDay'];
    endWeekendTimeController.text =
        utilityServices.convertDateFromUnknown(cli['endWeekendTime']);
    lastUpdatedController.text =
        utilityServices.convertDateFromUnknown(cli['lastUpdated']);
    migrationClientIdController.text =
        cli['migrationClientId'] == null ? "" : cli['migrationClientId'];
    municipalityIdController.text =
        cli['municipalityId'] == null ? "" : cli['municipalityId'];
    municipalityNameController.text =
        cli['municipalityName'] == null ? "" : cli['municipalityName'];
    nationalClientController.text =
        cli['nationalClient'] == false ? 'false' : 'true';
    String stn = cli['note'] == null ? "" : cli['note'];
    if (stn.length > 30) {
      stn = stn.substring(0, 27) + '...';
    }
    noteController.text = stn;
    String sth = cli['noteHTML'] == null ? "" : cli['noteHTML'];
    if (sth.length > 30) {
      sth = sth.substring(0, 27) + '...';
    }
    noteHTMLController.text = sth;

    otTemplateIdController.text =
        cli['otTemplateId'] == null ? "0" : cli['otTemplateId'].toString();
    overtimeRuleController.text =
        cli['overtimeRule'] == null ? "" : cli['overtimeRule'];
    debugPrintImagesController.text = cli['debugPrintImages'] == false ? 'false' : 'true';
    debugPrintQueueController.text = cli['debugPrintQueue'] == false ? 'false' : 'true';
    salesTaxIdController.text =
        cli['salesTaxId'] == null ? "" : cli['salesTaxId'];
    schoolDistrictController.text =
        cli['schoolDistrict'] == null ? "" : cli['schoolDistrict'];
    schoolDistrictIdController.text =
        cli['schoolDistrictId'] == null ? "" : cli['schoolDistrictId'];
    schoolDistrictNameController.text =
        cli['schoolDistrictName'] == null ? "" : cli['schoolDistrictName'];
    splitHolidaysController.text =
        cli['splitHolidays'] == false ? 'false' : 'true';
    splitShiftsController.text = cli['splitShifts'] == false ? 'false' : 'true';
    splitWeekendsController.text =
        cli['splitWeekends'] == false ? 'false' : 'true';
    startWeekDayController.text =
        cli['startWeekDay'] == null ? "" : cli['startWeekDay'];
    startWeekEndTimeController.text =
        utilityServices.convertDateFromUnknown(cli['startWeekEndTime']);
    startWeekTimeController.text =
        utilityServices.convertDateFromUnknown(cli['startWeekTime']);
    timeTypeController.text = cli['timeType'] == null ? "" : cli['timeType'];
    timeTypeDescriptionController.text =
        cli['timeTypeDescription'] == null ? "" : cli['timeTypeDescription'];
    timeclockEnabledController.text =
        cli['timeClockEnabled'] == false ? 'false' : 'true';
    timeclockGeoFenceEnforcedController.text =
        cli['timeClockGeoFenceEnforced'] == false ? 'false' : 'true';
    timeclockLatitudeController.text = cli['timeClockLatitude'] == null
        ? "0.0"
        : cli['timeClockLatitude'].toString();
    timeclockLocationServicesRequiredController.text =
        cli['timeClockLocationServicesRequired'] == false ? 'false' : 'true';
    timeclockLongitudeController.text = cli['timeClockLongitude'] == null
        ? "0.0"
        : cli['timeClockLongitude'].toString();
    timeclockRadiusController.text = cli['timeClockRadius'] == null
        ? "0"
        : cli['timeClockRadius'].toString();
    //section 4
    facilityCancelChargeController.text = cli['facilityCancelCharge'] == null
        ? "0.0"
        : cli['facilityCancelCharge'].toString();
    facilityCancelLimitController.text = cli['facilityCancelLimit'] == null
        ? "0.0"
        : cli['facilityCancelLimit'].toString();
    ficaExemptController.text = cli['ficaExempt'] == false ? 'false' : 'true';
    financeChargeController.text =
        cli['financeCharge'] == false ? 'false' : 'true';
    financeChargeRateController.text = cli['financeChargeRate'] == null
        ? "0.0"
        : cli['financeChargeRate'].toString();
    fsmBillingController.text = cli['fsmBilling'] == false ? 'false' : 'true';
    fsmFacilityIdController.text =
        cli['fsmFacilityId'] == null ? "0" : cli['fsmFacilityId'].toString();
    fsmFacilityNameController.text =
        cli['fsmFacilityName'] == null ? "" : cli['fsmFacilityName'];
    fsmLinkedController.text = cli['fsmLinked'] == false ? 'false' : 'true';
    gpoClientController.text = cli['gpoClient'] == false ? 'false' : 'true';
    groupCodeDescriptionController.text =
        cli['groupCodeDescription'] == null ? "" : cli['groupCodeDescription'];
    groupCodeIdController.text =
        cli['groupCodeId'] == null ? "" : cli['groupCodeId'];
    orientationController.text = cli['orientation'] == false ? 'false' : 'true';
    agencyCancelCreditController.text = cli['agencyCancelCredit'] == null
        ? "0.0"
        : cli['agencyCancelCredit'].toString();
    agencyCancelLimitController.text = cli['agencyCancelLimit'] == null
        ? "0.0"
        : cli['agencyCancelLimit'].toString();
    maxAmountPerInvoiceController.text = cli['maxAmountPerInvoice'] == null
        ? "0.0"
        : cli['maxAmountPerInvoice'].toString();
    maxShiftsPerInvoiceController.text = cli['maxShiftsPerInvoice'] == null
        ? "0"
        : cli['maxShiftsPerInvoice'].toString();
    noQueueController.text = cli['noQueue'] == false ? 'false' : 'true';
    omrQueueController.text = cli['omrQueue'] == false ? 'false' : 'true';
    emailQueueController.text = cli['emailQueue'] == false ? 'false' : 'true';
    emailQueuePDFController.text =
        cli['emailQueuePDF'] == false ? 'false' : 'true';
    emailQueueXLSController.text =
        cli['emailQueueXLS'] == false ? 'false' : 'true';
    verifyTimeSheetsController.text =
        cli['verifyTimeSheets'] == false ? 'false' : 'true';
    verifyTimesheetsBySignatureController.text =
        cli['verifyTimeSheetsBySignature'] == false ? 'false' : 'true';
    weekStartDayController.text =
        cli['weekStartDay'] == null ? "0" : cli['weekStartDay'].toString();
    weekStartTimeController.text =
        utilityServices.convertDateFromUnknown(cli['weekStartTime']);
    weekendEndDayController.text =
        cli['weekendEndDay'] == null ? "0" : cli['weekendEndDay'].toString();
    weekendEndTimeController.text =
        utilityServices.convertDateFromUnknown(cli['weekStartTime']);
    weekendStartDayController.text = cli['weekendStartDay'] == null
        ? "0"
        : cli['weekendStartDay'].toString();
    weekendStartTimeController.text =
        utilityServices.convertDateFromUnknown(cli['weekendStartTime']);
    allowTimeSheetsController.text =
        cli['allowTimeSheets'] == false ? 'false' : 'true';
  }

  @override
  void dispose() {
    super.dispose();
    //section 1
    clientIdController.dispose();
    clientNameController.dispose();
    clientNumberController.dispose();
    clientGroupCodeController.dispose();
    clientGroupDescriptionController.dispose();
    startWeekendDayController.dispose();
    statusIdController.dispose();
    deletedController.dispose();
    clientRatingController.dispose();
    clientRatingCodeIdController.dispose();
    clientStatusController.dispose();
    clientStatusDescriptionController.dispose();
    clientTypeController.dispose();
    clientTypeCodeIdController.dispose();
    branchIdController.dispose();
    branchNameController.dispose();
    numberOfBedsController.dispose();
    numberOfFacilitiesController.dispose();
    disciplinesServicedController.dispose();
    acceptsOTController.dispose();
    accountManagerController.dispose();
    accountManagerUserIdController.dispose();
    businessLineCodeIdController.dispose();
    consolidatedController.dispose();
    createdDateController.dispose();
    dateLastServicedController.dispose();
    daylightSavingsController.dispose();
    defaultWorkersCompCodeDescriptionController.dispose();
    defaultWorkersCompCodeIdController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    sicCodeController.dispose();
    //section 2
    discountController.dispose();
    billByCodeDescriptionController.dispose();
    billByCodeIdController.dispose();
    billingDblPlusRateController.dispose();
    billingDblRateController.dispose();
    billingHolidayPlusRateController.dispose();
    billingHolidayRateController.dispose();
    billingMaxPlusRateController.dispose();
    billingMaxRateController.dispose();
    billingOTPlusRateController.dispose();
    billingOTRateController.dispose();
    billingSameAsPhysicalController.dispose();
    boFirstInvoiceController.dispose();
    boLastInvoiceController.dispose();
    boLastPaidDateController.dispose();
    payHolidayPlusRateController.dispose();
    payHolidayRateController.dispose();
    payMaxPlusRateController.dispose();
    payMaxRateController.dispose();
    paymentTermsCodeIdController.dispose();
    payorIdController.dispose();
    payorNameController.dispose();
    payrollLocationIdController.dispose();
    imagesPerPageController.dispose();
    includeTimesheetsOnInvoicesController.dispose();
    invoiceCommentsController.dispose();
    invoiceEmailTemplateIdController.dispose();
    invoiceFormatCodeIdController.dispose();
    invoiceFrequencyCodeIdController.dispose();
    invoiceProfileIdController.dispose();
    zoneValueController.dispose();
    //section 3
    endWeekendDayController.dispose();
    endWeekendTimeController.dispose();
    lastUpdatedController.dispose();
    migrationClientIdController.dispose();
    municipalityIdController.dispose();
    municipalityNameController.dispose();
    nationalClientController.dispose();
    noteController.dispose();
    noteHTMLController.dispose();
    otTemplateIdController.dispose();
    overtimeRuleController.dispose();
    debugPrintImagesController.dispose();
    debugPrintQueueController.dispose();
    salesTaxIdController.dispose();
    schoolDistrictController.dispose();
    schoolDistrictIdController.dispose();
    schoolDistrictNameController.dispose();
    splitHolidaysController.dispose();
    splitShiftsController.dispose();
    splitWeekendsController.dispose();
    startWeekDayController.dispose();
    startWeekEndTimeController.dispose();
    startWeekTimeController.dispose();
    timeTypeController.dispose();
    timeTypeDescriptionController.dispose();
    timeclockEnabledController.dispose();
    timeclockGeoFenceEnforcedController.dispose();
    timeclockLatitudeController.dispose();
    timeclockLocationServicesRequiredController.dispose();
    timeclockLongitudeController.dispose();
    timeclockRadiusController.dispose();
    //section 4
    facilityCancelChargeController.dispose();
    facilityCancelLimitController.dispose();
    ficaExemptController.dispose();
    financeChargeController.dispose();
    financeChargeRateController.dispose();
    fsmBillingController.dispose();
    fsmFacilityIdController.dispose();
    fsmFacilityNameController.dispose();
    fsmLinkedController.dispose();
    gpoClientController.dispose();
    groupCodeDescriptionController.dispose();
    groupCodeIdController.dispose();
    orientationController.dispose();
    agencyCancelCreditController.dispose();
    agencyCancelLimitController.dispose();
    maxAmountPerInvoiceController.dispose();
    maxShiftsPerInvoiceController.dispose();
    noQueueController.dispose();
    omrQueueController.dispose();
    emailQueueController.dispose();
    emailQueuePDFController.dispose();
    emailQueueXLSController.dispose();
    verifyTimeSheetsController.dispose();
    verifyTimesheetsBySignatureController.dispose();
    weekStartDayController.dispose();
    weekStartTimeController.dispose();
    weekendEndDayController.dispose();
    weekendEndTimeController.dispose();
    weekendStartDayController.dispose();
    weekendStartTimeController.dispose();
    allowTimeSheetsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 588: ${arguments!}');
    clientId = arguments!['clientId'];
    localTitle = 'Client Profile for: ' + arguments!['clientName'];
    debugPrint('line 72 arguments $arguments');
    getClientMap();
  }

  double? screenHeight;
  double? fontSize;
  String? selectedMenu;
  String? selectedMenuName;
  int? selectedMenuNumber;
  int? selectedMenuIndex;
  bool flagHaveData = false;

  bool showRightSide = false;
  String genericTitle = '';
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double totalCurrentBalance = 0.0;
  double h = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = 'Client Profile Form ' + arguments!['clientName'];
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    debugPrint('line 115: $screenWidth $screenHeight');
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 16 / h;
    double smallFontSize = 12 / h;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localTitle!,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientIdController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Client Id')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "You must enter a Client Id";
                              }
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: discountController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Discount')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: endWeekendDayController,
                            maxLength: 5,
                            decoration:
                                InputDecoration(label: Text('Weekend End Day')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: facilityCancelChargeController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Facility Cancel Change')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 2
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            style: TextStyle(
                              fontSize: smallFontSize,
                            ),
                            controller: clientNameController,
                            maxLength: 100,
                            decoration:
                                InputDecoration(label: Text('Client Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billByCodeDescriptionController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Bill Code Description')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: endWeekendTimeController,
                            maxLength: 40,
                            decoration: InputDecoration(
                                label: Text('End Weekend Time')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: facilityCancelLimitController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Facility Cancel Limit')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 3
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientNumberController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Client Number')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billByCodeIdController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Bill By Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: lastUpdatedController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Last Updated')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: ficaExemptController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('FICA Exempt')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 4
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientGroupCodeController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Client Group Code')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingDblPlusRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Bill Double Plus Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: migrationClientIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Migration Client Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: financeChargeController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Finance Charge')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 5
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientGroupDescriptionController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Client Group Description')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingDblRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Bill Double Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: municipalityIdController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Municipality Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: financeChargeRateController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Finance Charge Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 6
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: sicCodeController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('SIC Code')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingHolidayPlusRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Bill Holiday Plus Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: municipalityNameController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Municipality Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: fsmBillingController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('FSM Billing')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 7
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: statusIdController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Status Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingHolidayRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Bill Holiday Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: nationalClientController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('National Client')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: fsmFacilityIdController,
                            maxLength: 30,
                            decoration:
                                InputDecoration(label: Text('FSM Facility Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 8
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: deletedController,
                            maxLength: 10,
                            decoration: InputDecoration(label: Text('Deleted')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingMaxPlusRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Bill Max Plus Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: noteController,
                            maxLength: 250,
                            decoration: InputDecoration(
                                label: Text(
                              'Note',
                            )),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: fsmFacilityNameController,
                            maxLength: 200,
                            decoration:
                                InputDecoration(label: Text('Facility Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 9
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientRatingController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Client Rating')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingMaxRateController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Bill Max Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: noteHTMLController,
                            maxLength: 250,
                            decoration: InputDecoration(
                                label: Text(
                              'Note HTML',
                            )),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: fsmLinkedController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('FSM Linked')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 10
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientRatingCodeIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Client Rating Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingOTPlusRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Bill OT Plus Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: otTemplateIdController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('OT Template Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: gpoClientController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('GPO Client')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 11
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientStatusController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Client Status')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingOTRateController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Bill OT Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: overtimeRuleController,
                            maxLength: 100,
                            decoration:
                                InputDecoration(label: Text('Overtime Rule')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: groupCodeDescriptionController,
                            maxLength: 200,
                            decoration: InputDecoration(
                                label: Text('Group Code Description')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 12
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientStatusDescriptionController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Client Status Description')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: billingSameAsPhysicalController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Billing Same as Physical')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: debugPrintImagesController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Print Images')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: groupCodeIdController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Group Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 13
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientTypeController,
                            maxLength: 50,
                            decoration:
                                InputDecoration(label: Text('Client Type')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: boFirstInvoiceController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('BO First Invoice ')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: debugPrintQueueController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Print Queue')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: orientationController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Orientation')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 14
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientTypeCodeIdController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Type Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: boLastInvoiceController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('BO Last Invoice')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: salesTaxIdController,
                            maxLength: 30,
                            decoration:
                                InputDecoration(label: Text('Sales Tax Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: agencyCancelCreditController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Cancel Credit')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 15
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: branchIdController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Branch Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: boLastPaidDateController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('BO Last Paid Date')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: schoolDistrictController,
                            maxLength: 100,
                            decoration:
                                InputDecoration(label: Text('School District')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: agencyCancelLimitController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Cancel Limit')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 16
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            style: TextStyle(
                              fontSize: smallFontSize,
                            ),
                            controller: branchNameController,
                            maxLength: 100,
                            decoration:
                                InputDecoration(label: Text('Branch Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payHolidayPlusRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Pay Holiday Plus Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: schoolDistrictIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('School District Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: maxAmountPerInvoiceController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Max Amount Per Invoice')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 17
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: numberOfBedsController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Number Of Beds')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payHolidayRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Pay Holiday Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: schoolDistrictNameController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('School District Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: maxShiftsPerInvoiceController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Max Shifts Per Invoice')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 18
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: numberOfFacilitiesController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Number of Facilities')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payMaxPlusRateController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Pay Max Plus Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: splitHolidaysController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Split Holidays')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: noQueueController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('No Queue')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 19
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: disciplinesServicedController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Disciplines Serviced')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payMaxRateController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Pay Max Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: splitShiftsController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Split Shifts')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: omrQueueController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('OMR Queue')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 20
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: acceptsOTController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Accepts OT')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: paymentTermsCodeIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Payment Terms Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: splitWeekendsController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Split Weekends')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: emailQueueController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Email Queue')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 21
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: accountManagerController,
                            maxLength: 100,
                            decoration:
                                InputDecoration(label: Text('Account Manager')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payorIdController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Payer Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: startWeekDayController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Start Week Day')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: emailQueuePDFController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Email Queue PDF')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 22
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: accountManagerUserIdController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Account Manager User Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payorNameController,
                            maxLength: 100,
                            decoration:
                                InputDecoration(label: Text('Payer Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: startWeekEndTimeController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Start Weekend Time')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: emailQueueXLSController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Email Queue XLS')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 23
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: businessLineCodeIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Business Line Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payrollLocationIdController,
                            maxLength: 50,
                            decoration: InputDecoration(
                                label: Text('Payroll Location Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: startWeekTimeController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Start Week Time')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: verifyTimeSheetsController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Verify Timesheets')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 24
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: consolidatedController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Consolidated')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: imagesPerPageController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Images Per Page')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: timeTypeController,
                            maxLength: 30,
                            decoration:
                                InputDecoration(label: Text('Time Type')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: verifyTimesheetsBySignatureController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Verify Timesheets By Signature')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 25
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: createdDateController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Created Date')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: includeTimesheetsOnInvoicesController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Include Timesheets on Invoice')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: timeTypeDescriptionController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Time Type Description')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: weekStartDayController,
                            maxLength: 10,
                            decoration:
                                InputDecoration(label: Text('Week Start Day')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 26
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: dateLastServicedController,
                            maxLength: 30,
                            decoration: InputDecoration(
                                label: Text('Date Last Serviced')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: invoiceCommentsController,
                            maxLength: 200,
                            decoration: InputDecoration(
                                label: Text('Invoice Comments')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: timeclockEnabledController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Timeclock Enabled')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: weekStartTimeController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Week Start Time')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 27
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: daylightSavingsController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Daylight Savings')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: invoiceEmailTemplateIdController,
                            maxLength: 30,
                            decoration: InputDecoration(
                                label: Text('Invoice Email Template Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: timeclockGeoFenceEnforcedController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Timeclock Geo Fence Enforced')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: weekendEndDayController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Timeclock Enabled')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 28
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller:
                                defaultWorkersCompCodeDescriptionController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text(
                                    'Default Workers Comp Code Description')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: invoiceFormatCodeIdController,
                            maxLength: 200,
                            decoration: InputDecoration(
                                label: Text('Invoice Format Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: timeclockLatitudeController,
                            maxLength: 30,
                            decoration: InputDecoration(
                                label: Text('Timeclock Latitude')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: weekendEndDayController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Weekend Week Day')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 29
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: defaultWorkersCompCodeIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Default Workers Comp Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: invoiceFrequencyCodeIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Invoice Frequency Code Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller:
                                timeclockLocationServicesRequiredController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text(
                                    'Timeclock Location Services Required')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: weekendStartDayController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Weekend Start Day')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 30
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: latitudeController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Latitude')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: invoiceProfileIdController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Invoice Profile Id')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: timeclockLongitudeController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Timeclock Longitude')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: weekendStartTimeController,
                            maxLength: 20,
                            decoration: InputDecoration(
                                label: Text('Weekend Start Time')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 31
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: longitudeController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Longitude')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: zoneValueController,
                            maxLength: 20,
                            decoration:
                                InputDecoration(label: Text('Zone Value')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: allowTimeSheetsController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Allow Timesheets')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final navigator = Navigator.of(context)
                        .pushNamed(clientMenu, arguments: arguments!);
                  },
                  child: Text('Exit'),
                ),
                // SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     formKey.currentState?.reset();
                //   },
                //   child: Text('Reset From'),
                // ),
              ],
            )),
      ),
    );
  }
}
