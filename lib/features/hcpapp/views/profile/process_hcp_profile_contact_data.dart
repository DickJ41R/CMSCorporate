import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPProfileContactData extends StatefulWidget {
  final Map<String, String> args;
  const ProcessHCPProfileContactData({super.key, required this.args});

  @override
  State<ProcessHCPProfileContactData> createState() =>
      _ProcessHCPProfileContactDataState();
}

class _ProcessHCPProfileContactDataState
    extends State<ProcessHCPProfileContactData> {
  _ProcessHCPProfileContactDataState();
  final formKey = GlobalKey<FormState>();
  var hcpContact;
  AuthService authService = AuthService();
  HCPServices hcpServices = HCPServices();
  DropDownCodes dropDownCodes = DropDownCodes();
  int? hcpId;

  List<Map<String, dynamic>>? listOfContacts = [];
  List<Map<String, dynamic>>? menuContacts;
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
  String? currentContactId;

  Future<List<dynamic>> _getDropDownMenuItems() async {
    debugPrint(
        'line 30 get client contact Dropdownitems: ${listOfContacts!.length}');
    dropDownMenuEntries = [];
    menuContacts = [];

      listOfContacts = [];

    try {

        listOfContacts = await hcpServices.getHCPContacts(hcpId!);
      debugPrint('line 46: ${listOfContacts!.length}');
      if (listOfContacts!.length > 0) {
        dropDownMenuEntries = [];
        for (int i = 0; i < listOfContacts!.length; i++) {
          Map<String, dynamic> con = listOfContacts![i];
          if (con['contactTypeCodeDescription'] == null) {
            if (con['contactTypeCodeId'] == 2367 || con['contactTypeCodeId'] == 2370) {
              con['contactTypeCodeDescription'] = 'Email Contact';
            } else if (con['contactTypeCodeId'] == 2371) {
              con['contactTypeCodeDescription'] = 'Mobile Phone Contact';
            } else {
              con['contactTypeCodeDescription'] = "Unknown";
            }
          }
          Map<String, dynamic> mcon = {
            'contactTypeCodeDescription': con['contactTypeCodeDescription'],
            'contactName': con['contactTypeCodeDescription']
          };
          DropdownMenuEntry me = DropdownMenuEntry(
              value: mcon['contactTypeCodeDescription'],
              label: mcon['contactTypeCodeDescription']);
          dropDownMenuEntries.add(me);
          menuContacts!.add(mcon);
        }
        debugPrint('line 48: ${dropDownMenuEntries}');
        return dropDownMenuEntries;
      } else {
        return [];
      }

    } catch (e) {
      debugPrint('line 66: error: ${e.toString()}');
      throw Exception('line 67 error getting dropdown menu items');
    }
  }

  TextEditingController blacklistedController = TextEditingController();
  TextEditingController contactEntryController = TextEditingController();
  TextEditingController contactIdController = TextEditingController();
  TextEditingController contactTypeCodeDescriptionController =
      TextEditingController();
  TextEditingController contactTypeCodeIdController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController emailCredStatusNotificationsController =
      TextEditingController();
  TextEditingController emailRegistryModuleController = TextEditingController();
  TextEditingController emailSchedulingConfirmationsController =
      TextEditingController();
  TextEditingController emailShiftAvailableController = TextEditingController();
  TextEditingController extensionController = TextEditingController();
  TextEditingController hcpIdController = TextEditingController();
  TextEditingController isEmailController = TextEditingController();
  TextEditingController isTelephoneController = TextEditingController();
  TextEditingController mobileProviderCodeIdController =
      TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController unsubscribedController = TextEditingController();
  TextEditingController webAccessController = TextEditingController();

  void getHCPUserX() async {
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    debugPrint('line 38 gethcpuser contact: $hcpServices');
    Map<String, dynamic> lm = await hcpServices.getHCPUser(hcpId!);
    if (lm.isEmpty) {
      return lm;
    }
    fullName = lm['legalName'];
    return lm;
  }

  String? fullName;
  Map<String, String>? arguments;

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    hcpId = int.parse(arguments!['hcpId'].toString());
    debugPrint('line 126: $hcpId');
  }

  void initializeContactControllers() {
    blacklistedController.text = '';
    contactEntryController.text = '';
    contactIdController.text = '';
    contactTypeCodeDescriptionController.text = '';
    contactTypeCodeIdController.text = '';
    emailAddressController.text = '';
    emailCredStatusNotificationsController.text = '';
    emailRegistryModuleController.text = '';
    emailSchedulingConfirmationsController.text = '';
    emailShiftAvailableController.text = '';
    extensionController.text = '';
    hcpIdController.text = '';
    isEmailController.text = '';
    isTelephoneController.text = '';
    mobileProviderCodeIdController.text = '';
    noteController.text = '';
    unsubscribedController.text = '';
    webAccessController.text = '';
  }

  int getSelectedMenuIndex(value) {
    debugPrint('line 57 getselected contact index : $value');
    int index = -1;

    for (int i = 0; i < dropDownMenuEntries.length; i++) {
      DropdownMenuEntry de = dropDownMenuEntries[i];
      debugPrint('line 142: $value ${de.value}');
      if (value == de.value) {
        index = i;
        break;
      }
    }
    debugPrint('line 62: $index $arguments');
    if (index != -1) {
      Map<String, dynamic> con = listOfContacts![index];

      currentContactId = con['id'];
      debugPrint('line 159: $con');

      blacklistedController.text = con['blacklisted'] == false ? "No" : "Yes";
      contactEntryController.text = con['contactEntry'];
      contactIdController.text = con['contactId'].toString();
      contactTypeCodeDescriptionController.text =
          con['contactTypeCodeDescription'];
      contactTypeCodeIdController.text = con['contactTypeCodeId'].toString();
      emailAddressController.text =
          con['emailAddress'] == null ? "" : con['emailAddress'];
      emailCredStatusNotificationsController.text =
          con['emailCredStatusNotifications'] == false ? "No" : "Yes";
      emailRegistryModuleController.text =
          con['emailRegistryModule'] == false ? "No" : "Yes";
      emailSchedulingConfirmationsController.text =
          con['emailSchedulingConfirmations'] == false ? "No" : "Yes";
      emailShiftAvailableController.text =
          con['emailShiftAvailable'] == false ? "No" : "Yes";
      extensionController.text =
          con['extension'] == null ? "" : con['extension'];
      hcpIdController.text = con['hcpId'].toString();
      isEmailController.text = con['isEmail'] == false ? "No" : "Yes";
      isTelephoneController.text = con['isTelephone'] == false ? "No" : "Yes";
      mobileProviderCodeIdController.text =
          con['mobileProviderCodeId'].toString();
      noteController.text = con['note'] == null ? "" : con['note'];
      unsubscribedController.text = con['unsubscribed'] == false ? "No" : "Yes";
      webAccessController.text = con['webAccess'] == false ? "No" : "Yes";
    } else {
      throw Exception('line 177 index = -1');
    }
    return index;
  }

  void setContactData() {}
  @override
  void dispose() {
    super.dispose();
    blacklistedController.dispose();
    contactEntryController.dispose();
    contactIdController.dispose();
    contactTypeCodeDescriptionController.dispose();
    contactTypeCodeIdController.dispose();
    emailAddressController.dispose();
    emailCredStatusNotificationsController.dispose();
    emailRegistryModuleController.dispose();
    emailSchedulingConfirmationsController.dispose();
    emailShiftAvailableController.dispose();
    extensionController.dispose();
    hcpIdController.dispose();
    isEmailController.dispose();
    isTelephoneController.dispose();
    mobileProviderCodeIdController.dispose();
    noteController.dispose();
    unsubscribedController.dispose();
    webAccessController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 227 CONTACT  didchange');
    getHCPUserX();
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  double? screenHeight;
  double? screenWidth;
  double? fontSize;
  String? selectedMenu;
  String? selectedMenuName;
  int? selectedMenuNumber;
  int? selectedMenuIndex;
  bool flagHaveData = false;
  String? currentAddressId;
  TextEditingController menuController = TextEditingController();
  TextEditingController menuOptionController = TextEditingController();
  bool showRightSide = false;
  String genericTitle = '';
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double totalCurrentBalance = 0.0;
  double h = 1.0;

// ${getFormattedDate(widget.hcpCredential['credAcquiredData'])}'
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16 / h;
    //   double screenHeight = MediaQuery.sizeOf(context).height;
    debugPrint('line 17 screen width: $screenWidth');
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color2,
        leading: GestureDetector(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              final navigator = Navigator.of(context)
                  .pushNamed(hcpMenu, arguments: arguments!);
            },
          ),
        ),
        title: Text("Contact List",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
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
                    //  SizedBox(width: screenWidth - 10, height: 5),
                    Row(
                      children: [
                        Container(
                          height: 200,
                          width: 270,
                          padding: EdgeInsets.only(top: 5),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                            width: 270,
                                            child: Text(
                                                overflow: TextOverflow.visible,
                                                'There are no contacts for this HCP.',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: color2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      );
                                    } else {
                                      List<dynamic> listH = snapshot.data![0];
                                      debugPrint('line 111 ${listH.length}');
                                      if (listH.length == 0) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30),
                                            child: Container(
                                              height: 100,
                                              width: 270,
                                              child: Text(
                                                  'There are no contacts for this HCP.',
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: TextStyle(
                                                      fontSize: fontSize,
                                                      color: color2,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        );
                                      } else {
                                        List<dynamic> listD =
                                            snapshot.data![0]!;
                                        debugPrint('line 260 ${listD.length}');

                                        return Container(
                                          height: 80,
                                          width: 270,
                                          child: Column(
                                            children: [
                                              DropdownMenu<dynamic>(
                                                initialSelection: null,
                                                controller: menuController,
                                                scrollPadding: EdgeInsets.all(2),
                                                width: 270,
                                                requestFocusOnTap: true,
                                                textStyle: TextStyle(
                                                  fontSize: 18,
                                                ),
                                                label: const Text(
                                                    'HCP Contact Menu'),
                                                onSelected: (dynamic value) {
                                                  debugPrint(
                                                      'line 278 on selected $value');
                                                  selectedMenu = value;
                                                  selectedMenuIndex =
                                                      getSelectedMenuIndex(
                                                          value);
                                                  selectedMenuName = menuContacts![
                                                          selectedMenuIndex!][
                                                      'contactTypeCodeDescription'];
                                                  setState(() {
                                                    dropDownMenuOptionEntries =
                                                        [];
                                                    showRightSide = true;
                                                    genericTitle =
                                                        'HCP Contact Menu';
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
                                    Text('Selected: ${selectedMenu}'),
                                  ],
                                )
                              else
                                const Text('Please select an HCP Contact.'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )),
            right: showRightSide == true
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: hcpIdController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('HCP Id')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: contactIdController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Contact Id')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: contactTypeCodeIdController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Contact Type Id')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller:
                                            contactTypeCodeDescriptionController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Contact Description')),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                  controller: contactEntryController,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                      label: Text('Contact Entry')),
                                  validator: (value) {
                                    return null;
                                    //'some data' failed validation
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller:
                                            emailCredStatusNotificationsController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Email Cred Status?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller:
                                            emailRegistryModuleController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label:
                                                Text('Email Registry Module?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller:
                                            emailSchedulingConfirmationsController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Email Scheduling?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller:
                                            emailShiftAvailableController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text(
                                                'Email Available Shifts?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: isEmailController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Is Email?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: isTelephoneController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Is Telephone?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: blacklistedController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Blacklisted?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller:
                                            mobileProviderCodeIdController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label:
                                                Text('Mobile Provider Code')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: unsubscribedController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Unsubscribed?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                        controller: webAccessController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Web Access?')),
                                        validator: (value) {
                                          return null;
                                          //'some data' failed validation
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                  controller: emailAddressController,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                      label: Text('EmailAddress')),
                                  validator: (value) {
                                    return null;
                                    //'some data' failed validation
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                  controller: extensionController,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                      label: Text('Telephone Extension')),
                                  validator: (value) {
                                    return null;
                                    //'some data' failed validation
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                  maxLines: 1,
                                  controller: noteController,
                                  maxLength: 200,
                                  decoration:
                                      InputDecoration(label: Text('Note')),
                                  validator: (value) {
                                    return null;
                                    //'some data' failed validation
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 320,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      formKey.currentState?.reset();
                                      initializeContactControllers();
                                    },
                                    child: Text('Reset From'),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 320,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final navigator = Navigator.of(context)
                                          .pushNamed(hcpMenu,
                                              arguments: arguments!);
                                    },
                                    child: Text('Exit'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Container()),
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
