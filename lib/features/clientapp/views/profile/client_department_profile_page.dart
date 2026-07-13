//Client Department Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientDepartmentProfilePage extends StatefulWidget {
  final Map<String, String> args;
  const ClientDepartmentProfilePage({super.key, required this.args});

  @override
  State<ClientDepartmentProfilePage> createState() =>
      _ClientDepartmentProfilePageState();
}

class _ClientDepartmentProfilePageState
    extends State<ClientDepartmentProfilePage> {
  final formKey = GlobalKey<FormState>();
  ClientServices clientServices = ClientServices();
  Map<String, String>? arguments;
  List<Map<String, dynamic>>? listOfDepartments;
  List<Map<String, dynamic>>? menuDepartments;
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
  UtilitiesServices utilityServices = UtilitiesServices();
  int? clientId;
  Future<List<dynamic>> _getDropDownMenuItems() async {
    debugPrint('line 30 get client department Dropdownitems: $arguments');
    dropDownMenuEntries = [];
    menuDepartments = [];
    try {
      clientId = int.parse(arguments!['clientId'].toString());
      if (listOfDepartments!.length == 0) {
        listOfDepartments = await clientServices
            .getClientDepartmentDataClass(clientId!);
      }
      debugPrint('line 35: ${listOfDepartments!.length}');

      if (listOfDepartments!.length > 0) {
        for (int i = 0; i < listOfDepartments!.length; i++) {
          Map<String, dynamic> dep = listOfDepartments![i];
          Map<String, dynamic> mdep = {
            'departmentId': dep['departmentId'].toString(),
            'departmentName': dep['departmentName']
          };
          DropdownMenuEntry me = DropdownMenuEntry(
              value: mdep['departmentId'], label: mdep['departmentName']);
          dropDownMenuEntries.add(me);
          menuDepartments!.add(mdep);
        }
        debugPrint('line 48: ${dropDownMenuEntries}');
        return dropDownMenuEntries;
      } else {
        return [];
      }
      debugPrint('line 49: dropdownentries ${dropDownMenuEntries.length}');
    } catch (e) {
      debugPrint('line 57: error: ${e.toString()}');
      throw Exception('line 58 error getting dropdown menu items');
    }
  }

  String? localTitle;
  //section 1
  TextEditingController departmentIdController = TextEditingController();
  TextEditingController departmentNumberController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController statusIdController = TextEditingController();
  TextEditingController clientIdController = TextEditingController();
  TextEditingController branchIdController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController billingAddress1Controller = TextEditingController();
  TextEditingController billingAddress2Controller = TextEditingController();
  TextEditingController billingAddressAttentionController =
      TextEditingController();
  TextEditingController billingAddressNameController = TextEditingController();
  TextEditingController billingCityController = TextEditingController();
  TextEditingController billingStateController = TextEditingController();
  TextEditingController billingZipCodeController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController chargeIncrementController = TextEditingController();
  TextEditingController chargeWhenInvoicedController = TextEditingController();
  TextEditingController costCenterController = TextEditingController();
  TextEditingController creditCardNumberController = TextEditingController();
  TextEditingController creditCardTypeCodeIdController =
      TextEditingController();
  TextEditingController mailingAddress1Controller = TextEditingController();
  TextEditingController mailingAddress2Controller = TextEditingController();
  TextEditingController mailingCityController = TextEditingController();
  TextEditingController mailingStateController = TextEditingController();
  TextEditingController mailingZipCodeController = TextEditingController();
  TextEditingController municipalityIdController = TextEditingController();
  TextEditingController municipalityNameController = TextEditingController();
  TextEditingController salesTaxIdController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  //section  2
  TextEditingController paymentMethodCodeIdController = TextEditingController();
  TextEditingController paymentTermsCodeIdController = TextEditingController();
  TextEditingController payorIdController = TextEditingController();
  TextEditingController payrollLocationIdController = TextEditingController();
  TextEditingController acceptsOTController = TextEditingController();
  TextEditingController billDblPlusRateController = TextEditingController();
  TextEditingController billDblRateController = TextEditingController();
  TextEditingController billingSameAsPhysicalController =
      TextEditingController();
  TextEditingController billHolidayPlusRateController = TextEditingController();
  TextEditingController billHolidayRateController = TextEditingController();
  TextEditingController billMaxPlusRateController = TextEditingController();
  TextEditingController billMaxRateController = TextEditingController();
  TextEditingController billOTPlusRateController = TextEditingController();
  TextEditingController billOTRateController = TextEditingController();
  TextEditingController payDoubleTimePlusRateController =
      TextEditingController();
  TextEditingController payDoubleTimeRateController = TextEditingController();
  TextEditingController payHolidayPlusRateController = TextEditingController();
  TextEditingController payHolidayRateController = TextEditingController();
  TextEditingController payMaxPlusRateController = TextEditingController();
  TextEditingController payMaxRateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController emailQueueController = TextEditingController();
  TextEditingController emailQueuePDFController = TextEditingController();
  TextEditingController emailQueueXLSController = TextEditingController();
  TextEditingController weekStartDayController = TextEditingController();
  TextEditingController weekStartTimeController = TextEditingController();
  TextEditingController weekendEndTimeController = TextEditingController();
  TextEditingController weekendStartTimeController = TextEditingController();

  //section 3

  TextEditingController imagesPerPageController = TextEditingController();
  TextEditingController lastServicedDateController = TextEditingController();
  TextEditingController locationCodeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController omrQueueController = TextEditingController();
  TextEditingController otTemplateIdController = TextEditingController();
  TextEditingController debugPrintImagesController = TextEditingController();
  TextEditingController debugPrintQueueController = TextEditingController();
  TextEditingController debugPrintQueueCopiesController = TextEditingController();
  TextEditingController splitHolidaysController = TextEditingController();
  TextEditingController splitShiftsController = TextEditingController();
  TextEditingController splitWeekendsController = TextEditingController();
  TextEditingController timeTypeController = TextEditingController();
  TextEditingController timeTypeDescriptionController = TextEditingController();
  TextEditingController useClientBillModifiersController =
      TextEditingController();
  TextEditingController useClientBillingAddressController =
      TextEditingController();
  TextEditingController useClientCreditCardController = TextEditingController();
  TextEditingController useClientInvoicingController = TextEditingController();
  TextEditingController useClientPayModifiersController =
      TextEditingController();
  TextEditingController useClientPaymentController = TextEditingController();
  TextEditingController useClientPhysicalAddressController =
      TextEditingController();
  TextEditingController useClientTaxController = TextEditingController();
  TextEditingController useClientWeekController = TextEditingController();
  TextEditingController weekendEndDayController = TextEditingController();
  TextEditingController weekendStartDayController = TextEditingController();
  TextEditingController schoolDistrictIdController = TextEditingController();
  TextEditingController schoolDistrictNameController = TextEditingController();

  TextEditingController menuController = TextEditingController();

  int getSelectedMenuIndex(value) {
    debugPrint('line 57 getselected department index : $value');
    int index = -1;

    for (int i = 0; i < dropDownMenuEntries.length; i++) {
      DropdownMenuEntry de = dropDownMenuEntries[i];
      debugPrint('line 171: $de $value');
      if (de.value == value) {
        index = i;
        break;
      }
    }
    debugPrint('line 62: $index $arguments');
    if (index != -1) {
      Map<String, dynamic> dep = listOfDepartments![index];
      //section 1
      departmentIdController.text = dep['departmentId'].toString();
      departmentNumberController.text = dep['departmentNumber'];
      departmentNameController.text = dep['departmentName'];
      statusIdController.text = dep['statusId'];
      clientIdController.text = dep['clientId'].toString();
      branchIdController.text =
          dep['branchId'] == null ? "0" : dep['branchId'].toString();
      branchNameController.text =
          dep['branchName'] == null ? "" : dep['branchName'];
      billingAddress1Controller.text =
          dep['billingAddress1'] == null ? "" : dep['billingAddress1'];
      billingAddress2Controller.text =
          dep['billingAddress2'] == null ? "" : dep['billingAddress2'];
      billingAddressAttentionController.text =
          dep['billingAddressAttention'] == null
              ? ""
              : dep['billingAddressAttention'];
      billingAddressNameController.text =
          dep['billingAddressName'] == null ? "" : dep['billingAddressName'];
      billingCityController.text =
          dep['billingCity'] == null ? "" : dep['billingCity'];
      billingStateController.text =
          dep['billingState'] == null ? "" : dep['billingState'];
      billingZipCodeController.text =
          dep['billingZipCode'] == null ? "" : dep['billingZipCode'];
      cardHolderNameController.text =
          dep['cardHolderName'] == null ? "" : dep['cardHolderName'];
      chargeIncrementController.text =
          dep['cardHolderName'] == null ? "" : dep['cardHolderName'];
      chargeWhenInvoicedController.text =
          dep['chargedWhenInvoiced'] == false ? 'false' : 'true';
      costCenterController.text =
          dep['costCenter'] == null ? "" : dep['costCenter'];
      creditCardNumberController.text =
          dep['creditCardNumber'] == null ? "" : dep['creditCardNumber'];
      creditCardTypeCodeIdController.text = dep['creditCardTypeCodeId'] == null
          ? ""
          : dep['creditCardTypeCodeId'];
      mailingAddress1Controller.text =
          dep['mailingAddress1'] == null ? "" : dep['mailingAddress1'];
      mailingAddress2Controller.text =
          dep['mailingAddress2'] == null ? "" : dep['mailingAddress2'];
      mailingCityController.text =
          dep['mailingCity'] == null ? "" : dep['mailingCity'];
      mailingStateController.text =
          dep['mailingState'] == null ? "" : dep['mailingState'];
      mailingZipCodeController.text =
          dep['zipCode'] == null ? "" : dep['zipCode'];
      municipalityIdController.text =
          dep['municipalityId'] == null ? "" : dep['municipalityId'];
      municipalityNameController.text =
          dep['municipalityName'] == null ? "" : dep['municipalityName'];
      salesTaxIdController.text =
          dep['salesTaxId'] == null ? "" : dep['salesTaxId'];
      expirationDateController.text =
          utilityServices.convertDateFromUnknown(dep['ExpirationDate']);
      //section 2
      paymentMethodCodeIdController.text =
          dep['paymentMethodCodeId'] == null ? "" : dep['paymentMethodCodeId'];
      paymentTermsCodeIdController.text =
          dep['paymentTermsCodeId'] == null ? "" : dep['paymentTermsCodeId'];
      payorIdController.text = dep['payorId'] == null ? "" : dep['payorId'];
      payrollLocationIdController.text =
          dep['payrollLocationId'] == null ? "" : dep['payrollLocationId'];
      acceptsOTController.text = dep['acceptsOT'] == false ? 'false' : 'true';
      billDblPlusRateController.text = dep['billDblPlusRate'] == null
          ? '0.0'
          : dep['billDblPlusRate'].toString();
      billDblRateController.text =
          dep['billDblRate'] == null ? '0.0' : dep['billDblRate'].toString();
      billingSameAsPhysicalController.text =
          dep['billRateSameAsPhysical'] == false ? 'false' : 'true';
      billHolidayPlusRateController.text = dep['billHolidayPlusRate'] == null
          ? '0.0'
          : dep['billHolidayPlusRate'].toString();
      billHolidayRateController.text = dep['billHolidayRate'] == null
          ? '0.0'
          : dep['billHolidayRate'].toString();
      billMaxPlusRateController.text = dep['billMaxPlusRate'] == null
          ? '0.0'
          : dep['billMaxPlusRate'].toString();
      billMaxRateController.text =
          dep['billMaxRate'] == null ? '0.0' : dep['bilMaxRate'].toString();
      billOTPlusRateController.text = dep['billOTPlusRate'] == null
          ? '0.0'
          : dep['billOTPlusRate'].toString();
      billOTRateController.text =
          dep['billOTRate'] == null ? '0.0' : dep['billOTRate'].toString();
      payDoubleTimePlusRateController.text = dep['payDoubleimePlusRate'] == null
          ? '0.0'
          : dep['payDoubleimePlusRate'].toString();
      payDoubleTimeRateController.text = dep['payDoubletimeRate'] == null
          ? '0.0'
          : dep['payDoubletimeRate'].toString();
      payHolidayPlusRateController.text = dep['payHolidayPlusRate'] == null
          ? '0.0'
          : dep['payHolidayPlusRate'].toString();
      payHolidayRateController.text = dep['payHolidayRate'] == null
          ? '0.0'
          : dep['payHolidayRate'].toString();
      payMaxPlusRateController.text = dep['payMaxPlusRate'] == null
          ? '0.0'
          : dep['payMaxPlusRate'].toString();
      payMaxRateController.text = dep['payMaxRate'] == null
          ? '0.0'
          : dep['payHolidayPlusRate'].toString();
      emailQueueController.text = dep['emailQueue'] == false ? 'false' : 'true';
      emailQueuePDFController.text =
          dep['emailQueuePDF'] == false ? 'false' : 'true';
      emailQueueXLSController.text =
          dep['emailQueueXLS'] == false ? 'false' : 'true';

      //section 3
      imagesPerPageController.text =
          dep['imagesPerPage'] == null ? '0' : dep['imagesPerPage'].toString();
      lastServicedDateController.text =
          utilityServices.convertDateFromUnknown(dep['lastServicedDate']);
      locationCodeController.text =
          dep['locationCode'] == null ? "" : dep['locationCode'];
      latitudeController.text =
          dep['latitude'] == null ? '0.0' : dep['latitude'].toString();
      longitudeController.text =
          dep['longitude'] == null ? '0.0' : dep['longitude'].toString();
      omrQueueController.text = dep['omrQueue'] == false ? 'false' : 'true';
      otTemplateIdController.text =
          dep['otTemplateId'] == null ? "" : dep['otTemplateId'];
      debugPrintImagesController.text =
          dep['debugPrintImages'] == false ? 'false' : 'true';
      debugPrintQueueController.text =
          dep['debugPrintQueue'] == null ? "" : dep['debugPrintQueue'];
      debugPrintQueueCopiesController.text = dep['debugPrintQueueCopies'] == null
          ? '0'
          : dep['debugPrintQueueCopies'].toString();
      splitHolidaysController.text =
          dep['splitHolidays'] == false ? 'false' : 'true';
      splitShiftsController.text =
          dep['splitShifts'] == false ? 'false' : 'true';
      splitWeekendsController.text =
          dep['splitWeekends'] == false ? 'false' : 'true';
      timeTypeController.text = dep['timeType'] == null ? "" : dep['timeType'];
      timeTypeDescriptionController.text =
          dep['timeTypeDescription'] == null ? "" : dep['timeTypeDescription'];
      useClientBillModifiersController.text =
          dep['useClientBillModifiers'] == false ? 'false' : 'true';
      useClientBillingAddressController.text =
          dep['useClientBillingAddress'] == false ? 'false' : 'true';
      useClientCreditCardController.text =
          dep['useClientCreditCard'] == false ? 'false' : 'true';
      useClientInvoicingController.text =
          dep['useClientInvoicing'] == false ? 'false' : 'true';
      useClientPayModifiersController.text =
          dep['useClientPayModifiers'] == false ? 'false' : 'true';
      useClientPaymentController.text =
          dep['useClientPayment'] == false ? 'false' : 'true';
      useClientPhysicalAddressController.text =
          dep['useClientPhysicalAddress'] == false ? 'false' : 'true';
      useClientTaxController.text =
          dep['useClientTax'] == false ? 'false' : 'true';
      useClientWeekController.text =
          dep['useClientWeek'] == false ? 'false' : 'true';
      weekendEndDayController.text =
          dep['weekendEndDay'] == null ? "" : dep['weekendEndDy'];
      weekendStartDayController.text =
          dep['weekendStartDay'] == null ? "" : dep['weekendStartDay'];
      schoolDistrictIdController.text =
          dep['schoolDistrictId'] == null ? "" : dep['schoolDistrictId'];
      schoolDistrictNameController.text =
          dep['schoolDistrictName'] == null ? "" : dep['schoolDistrictName'];
      noteController.text = dep['note'] == null ? "" : dep['note'];
    }
    return index;
  }

  @override
  void dispose() {
    super.dispose();
    //SECTION 1
    departmentIdController.dispose();
    departmentNumberController.dispose();
    departmentNameController.dispose();
    statusIdController.dispose();
    clientIdController.dispose();
    branchIdController.dispose();
    branchNameController.dispose();
    billingAddress1Controller.dispose();
    billingAddress2Controller.dispose();
    billingAddressAttentionController.dispose();
    billingAddressNameController.dispose();
    billingCityController.dispose();
    billingStateController.dispose();
    billingZipCodeController.dispose();
    cardHolderNameController.dispose();
    chargeIncrementController.dispose();
    chargeWhenInvoicedController.dispose();
    costCenterController.dispose();
    creditCardNumberController.dispose();
    creditCardTypeCodeIdController.dispose();
    mailingAddress1Controller.dispose();
    mailingAddress2Controller.dispose();
    mailingCityController.dispose();
    mailingStateController.dispose();
    mailingZipCodeController.dispose();
    municipalityIdController.dispose();
    municipalityNameController.dispose();
    salesTaxIdController.dispose();

    //section 2
    expirationDateController.dispose();
    paymentMethodCodeIdController.dispose();
    paymentTermsCodeIdController.dispose();
    payorIdController.dispose();
    payrollLocationIdController.dispose();
    acceptsOTController.dispose();
    billDblPlusRateController.dispose();
    billDblRateController.dispose();
    billingSameAsPhysicalController.dispose();
    billHolidayPlusRateController.dispose();
    billHolidayRateController.dispose();
    billMaxPlusRateController.dispose();
    billMaxRateController.dispose();
    billOTPlusRateController.dispose();
    billOTRateController.dispose();
    payDoubleTimePlusRateController.dispose();
    payDoubleTimeRateController.dispose();
    payHolidayPlusRateController.dispose();
    payHolidayRateController.dispose();
    payMaxPlusRateController.dispose();
    payMaxRateController.dispose();
    noteController.dispose();
    emailQueueController.dispose();
    emailQueuePDFController.dispose();
    emailQueueXLSController.dispose();
    weekStartDayController.dispose();
    weekStartTimeController.dispose();
    weekendEndTimeController.dispose();
    weekendStartTimeController.dispose();
    //section 3
    imagesPerPageController.dispose();
    lastServicedDateController.dispose();
    locationCodeController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    omrQueueController.dispose();
    otTemplateIdController.dispose();
    debugPrintImagesController.dispose();
    debugPrintQueueController.dispose();
    debugPrintQueueCopiesController.dispose();
    splitHolidaysController.dispose();
    splitShiftsController.dispose();
    splitWeekendsController.dispose();
    timeTypeController.dispose();
    timeTypeDescriptionController.dispose();
    useClientBillModifiersController.dispose();
    useClientBillingAddressController.dispose();
    useClientCreditCardController.dispose();
    useClientInvoicingController.dispose();
    useClientPayModifiersController.dispose();
    useClientPaymentController.dispose();
    useClientPhysicalAddressController.dispose();
    useClientTaxController.dispose();
    useClientWeekController.dispose();
    weekendEndDayController.dispose();
    weekendStartDayController.dispose();
    schoolDistrictIdController.dispose();
    schoolDistrictNameController.dispose();
    menuController.dispose();
  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    localTitle = 'Client Departments for: ' + arguments!['clientName'].toString();
    listOfDepartments = [];
    debugPrint('line 72 arguments $arguments');
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
    const title = 'Client Department Form';
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    debugPrint('line 115: $screenWidth $screenHeight');
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 16 / h;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localTitle!,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: VerticalSplitView(
          left: Container(
              decoration: BoxDecoration(
                color: color1,
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  SizedBox(width: screenWidth - 10, height: 5),
                  Row(
                    children: [
                      Container(
                        height: 200,
                        width: 340,
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: FutureBuilder(
                                future: Future.wait([
                                  _getDropDownMenuItems(),
                                ]),
                                builder: (context,
                                    AsyncSnapshot<List<dynamic>> snapshot) {
                                  debugPrint(
                                      'line 417 building FB ${snapshot.connectionState}');
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30),
                                        child: Container(
                                          height: 110,
                                          child: Text(
                                              'Error: ${snapshot.error}',
                                              style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.data == [[]] &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 30),
                                        child: Container(
                                          height: 100,
                                          width: screenWidth! - 10,
                                          child: Text(
                                              overflow: TextOverflow.visible,
                                              'There are no departments for this client.',
                                              style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: color2,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<dynamic> listH = snapshot.data![0];
                                    debugPrint('line 111 ${listH.length}');
                                    if (listH.length == 0) {
                                      return Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          child: Container(
                                            height: 100,
                                            width: screenWidth! - 10,
                                            child: Text(
                                                'There are no departments for this client.',
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: color2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      );
                                    } else {
                                      List<dynamic> listD = snapshot.data![0]!;
                                      debugPrint('line 260 ${listD.length}');

                                      return Container(
                                        height: 80,
                                        width: screenWidth! - 10,
                                        child: Column(
                                          children: [
                                            DropdownMenu<dynamic>(
                                              initialSelection: null,
                                              controller: menuController,
                                              requestFocusOnTap: true,
                                              label: const Text(
                                                  'Client Department Menu'),
                                              onSelected: (dynamic value) {
                                                debugPrint(
                                                    'line 278 on selected $value');
                                                selectedMenu = value;
                                                selectedMenuIndex =
                                                    getSelectedMenuIndex(value);
                                                debugPrint(
                                                    'line 283: $selectedMenuIndex');
                                                selectedMenuName =
                                                    menuDepartments![
                                                            selectedMenuIndex!]
                                                        ['departmentName'];
                                                setState(() {
                                                  dropDownMenuOptionEntries =
                                                      [];
                                                  showRightSide = true;
                                                  genericTitle =
                                                      'Client Profile Menu';
                                                });
                                              },
                                              dropdownMenuEntries:
                                                  dropDownMenuEntries,
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            if (selectedMenu != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Selected: ${selectedMenuName}'),
                                ],
                              )
                            else
                              const Text('Please select a Client Department.'),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
          right: showRightSide == true
              ? Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
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
                                          controller: departmentIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Department Id')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter a departmentId";
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
                                          controller:
                                              paymentMethodCodeIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Payment Method Code')),
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
                                          maxLength: 5,
                                          decoration: InputDecoration(
                                              label: Text('Images Per Page')),
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
                                          controller:
                                              departmentNumberController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Department Number')),
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
                                              paymentTermsCodeIdController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Payment Terms Code')),
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
                                              lastServicedDateController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Last Serviced Date')),
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
                                          controller: departmentNameController,
                                          maxLength: 200,
                                          decoration: InputDecoration(
                                              label: Text('Department Name')),
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
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Payer Id')),
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
                                          controller: locationCodeController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Location Code')),
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
                                          controller: statusIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Status Id')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter a status Id";
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
                                          controller:
                                              payrollLocationIdController,
                                          maxLength: 30,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Payroll Location Id')),
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
                                          controller: latitudeController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Latitude')),
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
                                          controller: clientIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Client Id')),
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
                                          controller: acceptsOTController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Accepts OT')),
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
                                          controller: longitudeController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Longitude')),
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
                                          controller: branchIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Branch Id')),
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
                                          controller: billDblPlusRateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Bill Double Plus Rate')),
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
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('OMR Queue')),
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
                                          controller: branchNameController,
                                          maxLength: 200,
                                          decoration: InputDecoration(
                                              label: Text('Branch Name')),
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
                                          controller: billDblRateController,
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
                                          controller: otTemplateIdController,
                                          maxLength: 50,
                                          decoration: InputDecoration(
                                              label: Text('OT Template Id')),
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
                                          controller: billingAddress1Controller,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Billing Address 1')),
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
                                              billingSameAsPhysicalController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Billing Same As Physical')),
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
                                          decoration: InputDecoration(
                                              label: Text('Print Images')),
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
                                          controller: billingAddress2Controller,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Billing Address 2')),
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
                                              billHolidayPlusRateController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Bill Holiday Plus Rate')),
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
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Print Queue')),
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
                                          controller:
                                              billingAddressAttentionController,
                                          maxLength: 200,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Billing Address Attention')),
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
                                          controller: billHolidayRateController,
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
                                          controller:
                                              debugPrintQueueCopiesController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Print Queue Copies')),
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
                                          controller:
                                              billingAddressNameController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Billing Address Name')),
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
                                          controller: billMaxPlusRateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Bill Max Plus Rate')),
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
                                          decoration: InputDecoration(
                                              label: Text('Split Holidays')),
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
                                          controller: billingCityController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Billing City')),
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
                                          controller: billMaxRateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Bill Max Rate')),
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
                                          decoration: InputDecoration(
                                              label: Text('Split Shifts')),
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
                                          controller: billingStateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Billing State')),
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
                                          controller: billOTPlusRateController,
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
                                          controller: splitWeekendsController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Split Weekends')),
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
                                          controller: billingZipCodeController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Billing ZipCode')),
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
                                          controller: billOTRateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Bill OT Rate')),
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
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Time Type')),
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
                                          controller: cardHolderNameController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Card Holder Name')),
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
                                              payDoubleTimePlusRateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Pay Double Time Plus')),
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
                                              timeTypeDescriptionController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Time Type Description')),
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
                                          controller: chargeIncrementController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Charge Increment')),
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
                                              payDoubleTimeRateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Pay Double Time')),
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
                                              useClientBillModifiersController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Client Bill Modifier')),
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
                                          controller:
                                              chargeWhenInvoicedController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Charge When Invoiced')),
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
                                              payHolidayPlusRateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Pay Holiday Plus Rate')),
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
                                              useClientBillingAddressController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Use Client Billing Address')),
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
                                          controller: costCenterController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Cost Center')),
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
                                          controller:
                                              useClientCreditCardController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Use Client Credit Card')),
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
                                          controller:
                                              creditCardNumberController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Credit Card Number')),
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
                                          controller:
                                              useClientInvoicingController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Use Client Invoicing')),
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
                                          controller:
                                              creditCardTypeCodeIdController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Credit Card Type Code')),
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
                                          decoration: InputDecoration(
                                              label: Text('Pay Max Rate')),
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
                                              useClientPayModifiersController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Use Client Pay Modifier')),
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
                                          controller: mailingAddress1Controller,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Mailing Address Line 1')),
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
                                          decoration: InputDecoration(
                                              label: Text('Email Queue')),
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
                                              useClientPaymentController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Use Client Payment')),
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
                                          controller: mailingAddress2Controller,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Mailing Address Line 2')),
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
                                          decoration: InputDecoration(
                                              label: Text('Email Queue PDF')),
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
                                              useClientPhysicalAddressController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Use Client Physical Address')),
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
                                          controller: mailingCityController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Mailing City')),
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
                                          decoration: InputDecoration(
                                              label: Text('Email Queue XLS')),
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
                                          controller: useClientTaxController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Use Client Tax')),
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
                                          controller: mailingStateController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Mailing State')),
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
                                              paymentMethodCodeIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Payment Method Code Id')),
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
                                          controller: useClientWeekController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Use Client Week')),
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
                                          controller: mailingZipCodeController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Mailing Zip Code')),
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
                                              paymentTermsCodeIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Payment Terms Code Id')),
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
                                              label: Text('Weekend End Day')),
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
                                          controller: municipalityIdController,
                                          maxLength: 30,
                                          decoration: InputDecoration(
                                              label: Text('Municipality Id')),
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
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Payer Id')),
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
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Weekend Start Day')),
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
                                          controller:
                                              municipalityNameController,
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
                                          controller:
                                              payrollLocationIdController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Payroll Locatiion Id')),
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
                                              schoolDistrictIdController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('School District Id')),
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
                                          controller: salesTaxIdController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Sales Tax Id')),
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
                                          controller: acceptsOTController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Accepts OT')),
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
                                              schoolDistrictNameController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('School District Name')),
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
                                          controller: expirationDateController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Expiration Date')),
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
                                          controller: billDblRateController,
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
                                          controller: noteController,
                                          maxLength: 200,
                                          decoration: InputDecoration(
                                              label: Text('Note')),
                                          validator: (value) {
                                            return null;
                                          }),
                                    ),
                                  ],
                                ),
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
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            formKey.currentState?.reset();
                          },
                          child: Text('Reset From'),
                        ),
                      ],
                    ),
                  ))
              : Container(),
        ),
      ),
    );
  }
}

class VerticalSplitView extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double ratio;

  const VerticalSplitView(
      {Key? key, required this.left, required this.right, this.ratio = 0.5});

  @override
  _VerticalSplitViewState createState() => _VerticalSplitViewState();
}

class _VerticalSplitViewState extends State<VerticalSplitView> {
  final _dividerWidth = 16.0;

  double? _ratio;
  double? _maxWidth;

  get _width1 => _ratio! * _maxWidth!;

  get _width2 => (1 - _ratio!) * _maxWidth!;

  @override
  void initState() {
    super.initState();

    _ratio = widget.ratio;
    _ratio = .25;
    debugPrint('line 99: $_ratio');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      if (_maxWidth == null) _maxWidth = constraints.maxWidth - _dividerWidth;
      if (_maxWidth != constraints.maxWidth) {
        _maxWidth = constraints.maxWidth - _dividerWidth;
      }

      return SizedBox(
        width: constraints.maxWidth,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: _width1,
              child: widget.left,
            ),
            SizedBox(
              width: _width2,
              child: widget.right,
            ),
          ],
        ),
      );
    });
  }
}
