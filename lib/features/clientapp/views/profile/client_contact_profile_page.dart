//Client Contact Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';

class ClientContactProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientContactProfilePage({super.key, required this.args});

  @override
  State<ClientContactProfilePage> createState() =>
      _ClientContactProfilePageState();
}

class _ClientContactProfilePageState extends State<ClientContactProfilePage> {
  final formKey = GlobalKey<FormState>();

  ClientServices clientServices = ClientServices();
  Map<String, dynamic>? arguments;
  List<Map<String, dynamic>> listOfContacts = [];
  List<Map<String, dynamic>>? menuContacts;
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];

  Future<List<dynamic>> _getDropDownMenuItems() async {
    print('line 30 get client contact Dropdownitems: $arguments');
    dropDownMenuEntries = [];
    menuContacts = [];
    try {
      if (listOfContacts.length == 0) {
        listOfContacts = await clientServices
            .getClientContactDataClass(arguments!['clientId']);
      }
      print('line 35: ${listOfContacts!.length}');

      if (listOfContacts.length > 0) {
        for (int i = 0; i < listOfContacts!.length; i++) {
          Map<String, dynamic> con = listOfContacts![i];
          Map<String, dynamic> mcon = {
            'contactTypeCode': con['contactTypeCode'].toString(),
            'contactTypeDescription': con['contactTypeDescription']
          };
          DropdownMenuEntry me = DropdownMenuEntry(
              value: mcon['contactTypeCode'].toString(),
              label: mcon['contactTypeDescription']);
          dropDownMenuEntries.add(me);
          menuContacts!.add(mcon);
        }
        print('line 48: ${dropDownMenuEntries}');
        return dropDownMenuEntries;
      } else {
        return [];
      }
      print('line 49: dropdownentries ${dropDownMenuEntries.length}');
    } catch (e) {
      print('line 49: error: ${e.toString()}');
      throw Exception('line 21 error getting dropdown menu items');
    }
  }

  String? localTitle;
  //section 1
  TextEditingController contactTypeDescriptionController =
      TextEditingController();
  TextEditingController contactTypeCodeController = TextEditingController();
  TextEditingController contactIdController = TextEditingController();
  TextEditingController departmentIdController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController clientIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController jobTitleCodeIdController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  //screen 2
  TextEditingController cellTipController = TextEditingController();
  TextEditingController collectionContactController = TextEditingController();
  TextEditingController faxTipController = TextEditingController();
  TextEditingController emailClientModuleController = TextEditingController();
  TextEditingController emailScheduleConfirmationsController =
      TextEditingController();
  TextEditingController emailTipController = TextEditingController();
  TextEditingController marketingContactController = TextEditingController();
  TextEditingController noCallsController = TextEditingController();
  TextEditingController noEmailsController = TextEditingController();
  TextEditingController noFaxController = TextEditingController();
  TextEditingController noMailController = TextEditingController();
  TextEditingController workTipController = TextEditingController();
  TextEditingController otherTipController = TextEditingController();

  //screen 3
  TextEditingController cellTelephoneController = TextEditingController();
  TextEditingController faxExtensionController = TextEditingController();
  TextEditingController faxTelephoneController = TextEditingController();
  TextEditingController otherExtensionController = TextEditingController();
  TextEditingController otherTelephoneController = TextEditingController();
  TextEditingController prefixController = TextEditingController();
  TextEditingController textSchedulingConfirmationsController =
      TextEditingController();
  TextEditingController workExtensionController = TextEditingController();
  TextEditingController workTelephoneController = TextEditingController();

  TextEditingController menuController = TextEditingController();

  int getSelectedMenuIndex(value) {
    print('line 57 getselected contact index : $value');
    int index = -1;

    for (int i = 0; i < dropDownMenuEntries.length; i++) {
      DropdownMenuEntry de = dropDownMenuEntries[i];
      if (de.value == value) {
        index = i;
        break;
      }
    }
    print('line 62: $index $arguments');
    if (index != -1) {
      Map<String, dynamic> con = listOfContacts![index];
      contactTypeDescriptionController.text = con['contactTypeDescription'];
      contactTypeCodeController.text = con['contactTypeCode'].toString();
      contactIdController.text = con['contactId'].toString();
      emailController.text = con['email'] == null ? "" : con['email'];
      clientIdController.text = con['clientId'].toString();
      firstNameController.text =
          con['firstName'] == null ? "" : con['firstName'];
      fullNameController.text = con['fullName'] == null ? "" : con['fullName'];
      jobTitleCodeIdController.text = con['jobTitleCodeId'] == null
          ? '0'
          : con['jobTitleCodeId'].toString();
      lastNameController.text = con['lastName'] == null ? "" : con['lastName'];
      middleNameController.text =
          con['middleName'] == null ? "" : con['middleName'];
      noteController.text = con['note'] == null ? "" : con['note'];

      cellTipController.text = con['cellTip'] == false ? 'false' : 'true';
      collectionContactController.text =
          con['collectionContact'] == false ? 'false' : 'true';
      faxTipController.text = con['faxTip'] == false ? 'false' : 'true';
      emailClientModuleController.text =
          con['emailClientModule'] == false ? 'false' : 'true';
      emailScheduleConfirmationsController.text =
          con['emailScheduleConfirmations'] == false ? 'false' : 'true';
      emailTipController.text = con['emailTip'] == false ? 'false' : 'true';
      marketingContactController.text =
          con['marketingContact'] == false ? 'false' : 'true';
      noCallsController.text = con['noCalls'] == false ? 'false' : 'true';
      noEmailsController.text = con['noEmails'] == false ? 'false' : 'true';
      noFaxController.text = con['noFax'] == false ? 'false' : 'true';
      noMailController.text = con['noMail'] == false ? 'false' : 'true';
      workTipController.text = con['workTip'] == false ? 'false' : 'true';
      otherTipController.text = con['otherTip'] == false ? 'false' : 'true';
      textSchedulingConfirmationsController.text =
          con['textSchedulingConfirmations'] == false ? 'false' : 'true';

      cellTelephoneController.text =
          con['cellTelephone'] == null ? "" : con['cellTelephone'];
      faxExtensionController.text =
          con['faxExtension'] == null ? "" : con['faxExtension'];
      faxTelephoneController.text =
          con['faxTelephone'] == null ? "" : con['faxTelephone'];
      otherExtensionController.text =
          con['otherExtension'] == null ? "" : con['otherExtension'];
      otherTelephoneController.text =
          con['otherTelephone'] == null ? "" : con['otherTelephone'];
      prefixController.text = con['prefix'] == null ? "" : con['prefix'];
      workExtensionController.text =
          con['workExtension'] == null ? "" : con['workExtension'];
      workTelephoneController.text =
          con['workTelephone'] == null ? "" : con['workTelephone'];
    }
    return index;
  }

  @override
  void dispose() {
    super.dispose();
    contactTypeDescriptionController.dispose();
    contactTypeCodeController.dispose();
    contactIdController.dispose();
    departmentIdController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    clientIdController.dispose();
    firstNameController.dispose();
    fullNameController.dispose();
    jobTitleCodeIdController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    noteController.dispose();
    cellTipController.dispose();
    collectionContactController.dispose();
    faxTipController.dispose();
    emailClientModuleController.dispose();
    emailScheduleConfirmationsController.dispose();
    emailTipController.dispose();
    marketingContactController.dispose();
    noCallsController.dispose();
    noEmailsController.dispose();
    noFaxController.dispose();
    noMailController.dispose();
    workTipController.dispose();
    otherTipController.dispose();
    cellTelephoneController.dispose();
    faxExtensionController.dispose();
    faxTelephoneController.dispose();
    otherExtensionController.dispose();
    otherTelephoneController.dispose();
    prefixController.dispose();
    textSchedulingConfirmationsController.dispose();
    workExtensionController.dispose();
    workTelephoneController.dispose();

    menuController.dispose();
  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    localTitle = 'Client Contacts for: ' + arguments!['clientName'];
    print('line 72 arguments $arguments');
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
    const title = 'Client Contact Form';
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    print('line 115: $screenWidth $screenHeight');
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
                                              'There are no contacts for this client.',
                                              style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: color2,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<dynamic> listH = snapshot.data![0];
                                    print('line 111 ${listH.length}');
                                    if (listH.length == 0) {
                                      return Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          child: Container(
                                            height: 100,
                                            width: screenWidth! - 10,
                                            child: Text(
                                                'There are no contacts for this client.',
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
                                      print('line 260 ${listD.length}');

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
                                                  'Client Contact Menu'),
                                              onSelected: (dynamic value) {
                                                print(
                                                    'line 278 on selected $value');
                                                selectedMenu = value;
                                                selectedMenuIndex =
                                                    getSelectedMenuIndex(value);
                                                print(
                                                    'line 283: $selectedMenuIndex');
                                                selectedMenuName = menuContacts![
                                                        selectedMenuIndex!]
                                                    ['contactTypeDescription'];
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
                              const Text('Please select a Client Contact.'),
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
                                          controller: contactTypeCodeController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Contact Type Code')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter a contact type code";
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
                                          controller: cellTipController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Cell Tip')),
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
                                          controller: cellTelephoneController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Cell Telephone')),
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
                                              contactTypeDescriptionController,
                                          maxLength: 200,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Contact Description')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter a contact description";
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
                                              collectionContactController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Collection Contact')),
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
                                          controller: faxExtensionController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Fax Extension')),
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
                                          controller: contactIdController,
                                          maxLength: 5,
                                          decoration: InputDecoration(
                                              label: Text('Contact Id')),
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
                                          controller: faxTipController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Fax Tip')),
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
                                          controller: faxTelephoneController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Fax Telephone')),
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
                                          controller: departmentIdController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Department Id')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter a department Id";
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
                                              emailClientModuleController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label:
                                                  Text('Email Client Module')),
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
                                          controller: otherExtensionController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Other Extension')),
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
                                          controller: birthDateController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Birth Date')),
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
                                              emailScheduleConfirmationsController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Email Schedule Confirmations')),
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
                                          controller: otherTelephoneController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Other Telephone')),
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
                                          controller: emailController,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                              label: Text('Email')),
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
                                          controller: emailTipController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Email Tip')),
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
                                          controller: prefixController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Prefix')),
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
                                          controller: clientIdController,
                                          maxLength: 6,
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
                                          controller:
                                              marketingContactController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Marketing Contact')),
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
                                          controller: workExtensionController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Work Extension')),
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
                                          controller: firstNameController,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                              label: Text('First Name')),
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
                                          controller: noCallsController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('No Calls')),
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
                                          controller: workTelephoneController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              label: Text('Work Telephone')),
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
                                          controller: fullNameController,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                              label: Text('Full Name')),
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
                                          controller: noEmailsController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('No Emails')),
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
                                          controller: jobTitleCodeIdController,
                                          maxLength: 6,
                                          decoration: InputDecoration(
                                              label: Text('Job Title Id')),
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
                                          controller: noFaxController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('No Fax')),
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
                                          controller: lastNameController,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                              label: Text('Last Name')),
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
                                          controller: noMailController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('No Mail')),
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
                                          controller: middleNameController,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                              label: Text('Middle Name')),
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
                                          controller: workTipController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Work Tip')),
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
                                          controller: noteController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Note')),
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
                                          controller: otherTipController,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                              label: Text('Other Tip')),
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
                                          controller:
                                              textSchedulingConfirmationsController,
                                          maxLength: 6,
                                          decoration: InputDecoration(
                                              label: Text(
                                                  'Text Scheduling Confirmations')),
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
    print('line 99: $_ratio');
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
