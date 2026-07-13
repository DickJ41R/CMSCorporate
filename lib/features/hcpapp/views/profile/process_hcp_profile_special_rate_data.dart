//
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPProfileSpecialRateData extends StatefulWidget {
  final Map<String, String> args;
  const ProcessHCPProfileSpecialRateData({super.key, required this.args});

  @override
  State<ProcessHCPProfileSpecialRateData> createState() =>
      _ProcessHCPProfileSpecialRateDataState();
}

class _ProcessHCPProfileSpecialRateDataState
    extends State<ProcessHCPProfileSpecialRateData> {
  _ProcessHCPProfileSpecialRateDataState();
  final formKey = GlobalKey<FormState>();
  var hcpContact;
  AuthService authService = AuthService();
  HCPServices hcpServices = HCPServices();
  DropDownCodes dropDownCodes = DropDownCodes();
  int? hcpId;

  List<Map<String, dynamic>>? listOfSpecialRates = [];
  List<Map<String, dynamic>>? menuSpecialRates;
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
  String? currentContactId;

  Future<List<dynamic>> _getDropDownMenuItems() async {
    debugPrint(
        'line 30 get client address Dropdownitems: ${listOfSpecialRates!.length}');
    dropDownMenuEntries = [];
    menuSpecialRates = [];
    try {

      if (listOfSpecialRates!.length == 0) {
        listOfSpecialRates =
            await hcpServices.getHCPSpecialRates(hcpId!);
      }
      debugPrint('line 35: ${listOfSpecialRates!.length}');
      if (listOfSpecialRates!.length > 0) {
        for (int i = 0; i < listOfSpecialRates!.length; i++) {
          Map<String, dynamic> spr = listOfSpecialRates![i];
          var specialRateIdentifier =
              spr['hcpId'].toString() + '-' + spr['shiftCode'];
          Map<String, dynamic> mspr = {
            'specialRateIdentifier': specialRateIdentifier,
            'rateId': spr['rateId'].toString()
          };
          DropdownMenuEntry me = DropdownMenuEntry(
              value: mspr['rateId'], label: mspr['specialRateIdentifier']);
          dropDownMenuEntries.add(me);
          menuSpecialRates!.add(mspr);
        }
        debugPrint('line 48: ${dropDownMenuEntries}');
        return dropDownMenuEntries;
      } else {
        return [];
      }
      debugPrint('line 49: dropdownentries ${dropDownMenuEntries.length}');
    } catch (e) {
      debugPrint('line 49: error: ${e.toString()}');
      throw Exception('line 21 error getting dropdown menu items');
    }
  }

  TextEditingController specialRateIdController = TextEditingController();
  TextEditingController billRateController = TextEditingController();
  TextEditingController billRateWEController = TextEditingController();
  TextEditingController calcTypeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController hcpIdController = TextEditingController();
  TextEditingController marginController = TextEditingController();
  TextEditingController marginWEController = TextEditingController();
  TextEditingController mealsController = TextEditingController();
  TextEditingController payRateController = TextEditingController();
  TextEditingController payRateWEController = TextEditingController();
  TextEditingController rateGroupIdController = TextEditingController();
  TextEditingController rateIdController = TextEditingController();
  TextEditingController shiftCodeController = TextEditingController();
  TextEditingController shiftCodeDescriptionController =
      TextEditingController();
  TextEditingController startTimeController = TextEditingController();

  void getHCPUserX() async {
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    debugPrint('line 38 gethcpuser address: $hcpServices');
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
  }

  void initializeSpecialRateControllers() {
    specialRateIdController.text = '';
    billRateController.text = '';
    billRateWEController.text = '';
    calcTypeController.text = '';
    endTimeController.text = '';
    hcpIdController.text = '';
    marginController.text = '';
    marginWEController.text = '';
    mealsController.text = '';
    payRateController.text = '';
    payRateWEController.text = '';
    rateGroupIdController.text = '';
    rateIdController.text = '';
    shiftCodeController.text = '';
    shiftCodeDescriptionController.text = '';
    startTimeController.text = '';
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
      Map<String, dynamic> spr = listOfSpecialRates![index];

      currentSpecialRateId = spr['id'];
      debugPrint('line 159: $spr');
      specialRateIdController.text = spr['id'];
      billRateController.text = spr['billRate'].toString();
      billRateWEController.text = spr['billRateWE'].toString();
      calcTypeController.text = spr['calcType'];
      endTimeController.text = spr['endTime'];
      hcpIdController.text = spr['hcpId'].toString();
      marginController.text = spr['margin'].toString();
      marginWEController.text = spr['marginWE'].toString();
      mealsController.text = spr['meals'].toString();
      payRateController.text = spr['payRate'].toString();
      payRateWEController.text = spr['payRateWE'].toString();
      rateGroupIdController.text = spr['rateGroupId'].toString();
      rateIdController.text = spr['rateId'].toString();
      shiftCodeController.text = spr['shiftCode'];
      shiftCodeDescriptionController.text = spr['shiftCodeDescription'];
      startTimeController.text = spr['startTime'];
    } else {
      throw Exception('line 177 index = -1');
    }
    return index;
  }

  void setContactData() {}
  @override
  void dispose() {
    super.dispose();
    specialRateIdController.dispose();
    billRateController.dispose();
    billRateWEController.dispose();
    calcTypeController.dispose();
    endTimeController.dispose();
    hcpIdController.dispose();
    marginController.dispose();
    marginWEController.dispose();
    mealsController.dispose();
    payRateController.dispose();
    payRateWEController.dispose();
    rateGroupIdController.dispose();
    rateIdController.dispose();
    shiftCodeController.dispose();
    shiftCodeDescriptionController.dispose();
    startTimeController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 51 ADDRESS  didchange');
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
  String? currentSpecialRateId;
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
                                                'There are no special rates for this HCP',
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
                                                  'There are no special rates for this HCP.',
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
                                                requestFocusOnTap: true,
                                                label: const Text(
                                                    'HCP Special Rates Menu'),
                                                onSelected: (dynamic value) {
                                                  debugPrint(
                                                      'line 278 on selected $value');
                                                  selectedMenu = value;
                                                  selectedMenuIndex =
                                                      getSelectedMenuIndex(
                                                          value);
                                                  selectedMenuName =
                                                      menuSpecialRates![
                                                              selectedMenuIndex!]
                                                          [
                                                          'specialRateIdentifier'];
                                                  setState(() {
                                                    dropDownMenuOptionEntries =
                                                        [];
                                                    showRightSide = true;
                                                    genericTitle =
                                                        'HCP Special Rates Menu';
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
                                const Text('Please select an HCP Rate.'),
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
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
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
                                      width: 280,
                                      child: TextFormField(
                                        controller: specialRateIdController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Special Rate Id')),
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
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: rateGroupIdController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Rate Group Id')),
                                        validator: (value) {
                                          return null;
//'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: rateIdController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Rate ID')),
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
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: shiftCodeController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Shift Code')),
                                        validator: (value) {
                                          return null;
//'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller:
                                            shiftCodeDescriptionController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Shift Description')),
                                        validator: (value) {
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: startTimeController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Start Time')),
                                        validator: (value) {
                                          return null;
//'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: endTimeController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('End Time')),
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
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: calcTypeController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Calc Type')),
                                        validator: (value) {
                                          return null;
//'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: mealsController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Meals')),
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
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: billRateController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Bill Rate')),
                                        validator: (value) {
                                          return null;
//'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: billRateWEController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Bill Rate WE')),
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
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: marginController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Margin')),
                                        validator: (value) {
                                          return null;
//'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: marginWEController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Margin WE')),
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
                                width: 600,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: payRateController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Pay Rate')),
                                        validator: (value) {
                                          return null;
//'some data' failed validation
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      height: 50,
                                      width: 280,
                                      child: TextFormField(
                                        controller: payRateWEController,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                            label: Text('Pay Rate WE')),
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
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 600,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      formKey.currentState?.reset();
                                      initializeSpecialRateControllers();
                                    },
                                    child: Text('Reset From'),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 600,
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
