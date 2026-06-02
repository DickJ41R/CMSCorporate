import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/views/taskview.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/utils/dropdown_codes.dart';

class LandingPageWeb extends StatefulWidget {
  const LandingPageWeb({super.key});

  @override
  State<LandingPageWeb> createState() => _LandingPageWebState();
}

Map<String, dynamic>? csmBranchUserMap;

class _LandingPageWebState extends State<LandingPageWeb> {
  String? localTitle;
  AuthService authServices = AuthService();

  List<Map<String, dynamic>>? listOfCurrentUserBranches;
  @override
  void initState() {
    super.initState();

    print('line 26 landingpage web');
    localTitle = 'CMS Primary Menu';
    listOfCurrentUserBranches = authServices.listOfCMSUserBranches;
    _setBranches();
    _setSearchCriteria();
    _setClientFields();
    _setHCPFields();
    _setWorkOrderFields();
    currentArgument = {
      'searchCollection': 'Unknown',
      'searchField': 'Unknown',
      'searchCriteria': 'Unknown',
      'searchValue': 'Unknown',
      'branchValue': 'Unknown'
    };
  }

  @override
  void dispose() {
    super.dispose();
    searchCriteriaController.dispose();
    searchClientController.dispose();
    searchHCPController.dispose();
    searchWorkOrderController.dispose();
    searchTermsController.dispose();
    branchController.dispose();
    menuOptionController.dispose();
    searchFieldsController.dispose();
  }

  DropDownCodes dropDownCodes = DropDownCodes();
  bool flagHaveQueryData = false;
  bool isLoggedIn = true;
  double? screenHeight;
  double? screenWidth;
  double? fontSize;
  String? selectedBranch;
  String? selectedSearchField;
  String? selectedSearchCriteria;
  String? selectedMenuOption;
  String? selectedSearchCriteriaMenuOption;
  bool isCheckedClient = false;
  bool isCheckedHCP = false;
  bool isCheckedWorkSchedule = false;
  int? selectedBranchNumber;
  bool flagHaveData = false;
  TextEditingController searchCriteriaController = TextEditingController();
  TextEditingController searchClientController = TextEditingController();
  TextEditingController searchHCPController = TextEditingController();
  TextEditingController searchWorkOrderController = TextEditingController();
  TextEditingController searchTermsController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController menuOptionController = TextEditingController();
  TextEditingController searchFieldsController = TextEditingController();

  List<DropdownMenuEntry<dynamic>> dropDownBranchEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownSearchCriteriaEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownSearchFieldsEntries = [];

  String? _value;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  bool flagHaveCalled = false;
  List<Map<String, String>>? argumentsContainer;

  void _setSearchFields(int index) {
    dropDownSearchFieldsEntries = [];

    switch (index) {
      case 0:
        {
          print('line 96: ${clientFields!.length}');
          for (int i = 0; i < clientFields!.length; i++) {
            Map<String, String> obj = clientFields![i];
            DropdownMenuEntry me =
                DropdownMenuEntry(value: obj['value']!, label: obj['label']!);
            dropDownSearchFieldsEntries.add(me);
          }
        }
        break;
      case 1:
        {
          for (int i = 0; i < hcpFields!.length; i++) {
            DropdownMenuEntry me =
                DropdownMenuEntry(value: hcpFields![i], label: hcpFields![i]);
            dropDownSearchFieldsEntries.add(me);
          }
        }
        break;
      case 2:
        {
          for (int i = 0; i < workOrderFields!.length; i++) {
            DropdownMenuEntry me = DropdownMenuEntry(
                value: workOrderFields![i], label: workOrderFields![i]);
            dropDownSearchFieldsEntries.add(me);
          }
        }
        break;
      default:
        break;
    }
  }

  bool haveFields = false;
  List<dynamic>? searchCriteria;
  List<Map<String, String>>? clientFields;
  List<dynamic>? workOrderFields;
  List<dynamic>? hcpFields;
  void _setClientFields() {
    clientFields = [
      {"value": 'clientId', "label": 'Client Id'},
      {'value': 'clientName', 'label': 'Client Name'},
      {"value": 'active', 'label': 'Status'},
      {'value': 'branchId', 'label': 'Branch Id'},
      {'value': 'branchName', 'label': 'Branch Name'}
    ];
  }

  void _setHCPFields() {
    hcpFields = [
      {"value": "hcpId", "label": 'Hcp Id'},
      {'value": "fullName","label": "Hcp Name (LastName, FirstName'},
      {"value": "status", "label": 'Status'},
      {'value': "branchId", "label": 'Branch Id'},
      {'value': 'branchName', 'label': 'Branch Name'}
    ];
  }

  void _setWorkOrderFields() {
    hcpFields = [
      'Hcp Id',
      'Hcp Name (LastName, FirstName',
      'Status',
      'Branch Id',
      'Branch Name'
    ];
  }

  dynamic currentTermsValue;
  Map<String, String>? currentArgument;

  void _setSearchCriteria() {
    searchCriteria = [
      "All",
      'Is Equal To',
      "Is Less Than",
      "Is Less Than or Equal To",
      "Is Greater Than",
      "Is Greater Than or Equal To",
      "Is Between (Edges, colon separated fields)",
      "Is Between (No Edges, colon separated fields)",
      "Is In (colon separated list)",
    ];
    for (int i = 0; i < searchCriteria!.length; i++) {
      DropdownMenuEntry me = DropdownMenuEntry(
          value: searchCriteria![i], label: searchCriteria![i]);
      dropDownSearchCriteriaEntries.add(me);
    }
  }

  List<Map<String, dynamic>>? userBranches;

  void _setBranches() {
    print('line 50 in _setBranches');
    userBranches = dropDownCodes.getUserBranches();
    print(
        'line 60: ${userBranches!.length} ${listOfCurrentUserBranches!.length}');
    if (authServices.corporateOrBranch == 'Corporate') {
      Map<String, dynamic> mp = {"branchId": 0, "branchName": "Corporate"};
      DropdownMenuEntry me = DropdownMenuEntry(
          value: '(' +
              mp['branchId'].toString() +
              ') ' +
              mp['branchName'].toString(),
          label: mp['branchName']);
      dropDownBranchEntries.add(me);
    }
    for (int i = 0; i < userBranches!.length; i++) {
      // String st = userBranches[i]['branchName'];
      //  Text ts = Text('Index $i: $st', style: optionStyle);
      //  _widgetOptions.add(userBranches[i]);
      bool flagGotHit = false;
      Map<String, dynamic> mp = userBranches![i];

      for (int j = 0; j < listOfCurrentUserBranches!.length; j++) {
        Map<String, dynamic> tp = listOfCurrentUserBranches![j];
        if (tp['branchId'] == mp['branchId']) {
          flagGotHit = true;
          break;
        }
      }
      if (flagGotHit == false) {
        continue;
      }
      DropdownMenuEntry me = DropdownMenuEntry(
          value: '(' +
              mp['branchId'].toString() +
              ') ' +
              mp['branchName'].toString(),
          label: mp['branchName']);
      dropDownBranchEntries.add(me);
    }
  }

  int getSelectedBranchIndex(value) {
    print('line 342 getselected branchindex : $value');

    for (int i = 0; i < dropDownBranchEntries.length; i++) {
      DropdownMenuEntry de = dropDownBranchEntries[i];
      if (value == de.value) {
        return i;
      }
    }
    return -1;
  }

  String _getSelectedSearchFieldIndex(int index, dynamic value) {
    String ivv = '';
    if (index == 0) {
      ivv = clientFields![index]['value']!;
    } else if (index == 1) {
      ivv = hcpFields![index]['value'];
    } else if (index == 2) {
      ivv = workOrderFields![index]['value'];
    }
    print('line 253 $ivv');
    return ivv;
  }

  bool _validateCurrentArguments() {
    bool bl = true;

    print('line 263: ${currentArgument}');
    if (currentArgument!['searchValue'] == null ||
        currentArgument!['searchValue'] == 'Unknown') {
      bl = false;
    }
    if (currentArgument!['branchValue'] == null ||
        currentArgument!['branchValue'] == 'Unknown') {
      bl = false;
    }
    if (currentArgument!['searchValue'] == null ||
        currentArgument!['searchValue'] == 'Unknown') {
      bl = false;
    }
    if (currentArgument!['searchField'] == null ||
        currentArgument!['searchField'] == 'Unknown') {
      bl = false;
    }
    if (currentArgument!['searchCollection'] == null ||
        currentArgument!['searchCollection'] == 'Unknown') {
      bl = false;
    }
    if (currentArgument!['searchCriteria'] == null ||
        currentArgument!['searchCriteria'] == 'Unknown') {
      bl = false;
    }
    return bl;
  }

  void setDataElements() {
    print("line 268 edit ${searchTermsController.text}");
    currentArgument!['searchValue'] = currentTermsValue.toString();
    currentArgument!['branchValue'] = selectedBranchNumber.toString();
    print('line 271: ${currentArgument}');
    bool bl = _validateCurrentArguments();
    if (bl == false) {
      print('line 283 bl == false');
      return;
    }
    setState(() {
      flagHaveQueryData = true;
      if (selectedBranchNumber != null) {
        flagHasTopLevelBranch = true;
      }
      flagHaveData = true;
    });
  }

  bool showLoadingIndicator = true;
  bool isLoading = false;
//
  bool haveSomeQuery = false;
  int selectedBranchIndex = -1;
  int selectedMenuOptionIndex = -1;
  bool flagHasTopLevelBranch = false;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    print(
        'line build 184: $screenWidth $selectedBranch $selectedMenuOption $flagHaveData $flagHaveCalled');
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 18 / h;
    print('line 406: $screenWidth $screenHeight $fontSize $h');

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
        padding: const EdgeInsets.all(4.0),
        child: VerticalSplitView(
          left: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(width: screenWidth! - 10, height: 5),
                Row(
                  children: [
                    Container(
                      height: 200,
                      width: 295,
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: DropdownMenu<dynamic>(
                              initialSelection: null,
                              //    "Corporate",
                              controller: branchController,
                              //  requestFocusOnTap is enabled/disabled by platforms when it is null.
                              //  On mobile platforms, this is false by default. Setting this to true will
                              // trigger focus request on the text field and virtual keyboard will appear
                              //   afterward. On desktop platforms however, this defaults to true.
                              requestFocusOnTap: true,
                              label: Container(
                                  height: 50,
                                  width: 285,
                                  child: Text('Branch')),
                              onSelected: (dynamic value) {
                                setState(() {
                                  selectedBranch = value;

                                  getSelectedBranchIndex(value);
                                  int idx = value.indexOf(')');
                                  if (idx != -1) {
                                    String st = value.substring(0, idx);
                                    st = st.replaceAll('(', '');
                                    st = st.trim();
                                    selectedBranchNumber = int.parse(st);

                                    // selectedBranchNumber =
                                    //     userBranches![selectedBranchIndex]
                                    //         ['branchId'];
                                    //
                                    flagHasTopLevelBranch = true;
                                    print('line 341:  ${selectedBranchNumber}');
                                  }
                                });

                                if (selectedMenuOption != null &&
                                    flagHaveCalled == false) {
                                  print(
                                      'line 404 in show circular progress indicator');
                                  flagHaveData == false
                                      ? Center(
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 19, 125, 103),
                                                    width: 4),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: CircularProgressIndicator(
                                              backgroundColor: color1,
                                            ),
                                          ),
                                        )
                                      : Container();
                                  print('line 424 just before get rows');
                                }
                              },

                              dropdownMenuEntries: dropDownBranchEntries,
                            ),
                          ),
                          selectedBranch != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        height: 50,
                                        width: 285,
                                        child: Text(
                                            'Selected: ${selectedBranch}')),
                                  ],
                                )
                              : Container(
                                  height: 30,
                                  width: 285,
                                  child: Text('Please select a branch.'),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      height: 200,
                      width: 295,
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: DropdownMenu<dynamic>(
                              initialSelection: null,
                              //    "Corporate",
                              controller: searchCriteriaController,
                              //  requestFocusOnTap is enabled/disabled by platforms when it is null.
                              //  On mobile platforms, this is false by default. Setting this to true will
                              // trigger focus request on the text field and virtual keyboard will appear
                              //   afterward. On desktop platforms however, this defaults to true.
                              requestFocusOnTap: true,
                              label: Container(
                                  height: 50,
                                  width: 290,
                                  child: Text('Search Criteria')),
                              onSelected: (dynamic value) {
                                setState(() {
                                  selectedSearchCriteria = value;
                                  currentArgument!['searchCriteria'] = value;

                                  print(
                                      'line 165: $currentArgument ${selectedSearchCriteria}');
                                });
                              },

                              dropdownMenuEntries:
                                  dropDownSearchCriteriaEntries,
                            ),
                          ),
                          selectedSearchCriteria != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        height: 50,
                                        width: 2,
                                        child: Text(
                                            'Selected: ${selectedSearchCriteria}')),
                                  ],
                                )
                              : Container(
                                  height: 50,
                                  width: 285,
                                  child: Text('Please select search criteria.'),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 50,
                  width: 285,
                  child: TextFormField(
                      controller: searchClientController,
                      style: TextStyle(
                          decoration: isCheckedClient
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                      decoration: InputDecoration(
                        label: Text('Search For Clients'),
                        suffixIcon: Checkbox(
                          value: isCheckedClient,
                          onChanged: (value) {
                            setState(() {
                              _setSearchFields(0);

                              isCheckedClient = value!;
                              haveFields = true;
                              if (value == false) {
                                dropDownSearchFieldsEntries = [];
                                currentArgument!['searchCollection'] = 'None';
                                isCheckedHCP = false;
                                isCheckedWorkSchedule = false;
                              } else {
                                currentArgument!['searchCollection'] = 'Client';
                              }
                              isCheckedHCP = !value;
                              isCheckedWorkSchedule = !value;
                            });
                          },
                        ),
                      ),
                      maxLength: 280,
                      validator: (value) {
                        return null;
                      }),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 50,
                  width: 285,
                  child: TextFormField(
                      controller: searchHCPController,
                      style: TextStyle(
                          decoration: isCheckedHCP
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                      decoration: InputDecoration(
                        label: Text('Search For HCPs'),
                        suffixIcon: Checkbox(
                          value: isCheckedHCP,
                          onChanged: (value) {
                            print('line 389: $value');
                            setState(() {
                              isCheckedHCP = value!;
                              haveFields = true;
                              _setSearchFields(1);

                              if (value == false) {
                                dropDownSearchFieldsEntries = [];
                                isCheckedClient = false;
                                isCheckedWorkSchedule = false;
                                currentArgument!['searchCollection'] = 'None';
                              } else {
                                currentArgument!['searchCollection'] =
                                    'HCProfessional';

                                isCheckedClient = !value;
                                isCheckedWorkSchedule = !value;
                              }
                            });
                          },
                        ),
                      ),
                      maxLength: 280,
                      validator: (value) {
                        return null;
                      }),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 50,
                  width: 285,
                  child: TextFormField(
                      controller: searchHCPController,
                      style: TextStyle(
                          decoration: isCheckedWorkSchedule
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                      decoration: InputDecoration(
                        label: Text('Search For Work Orders'),
                        suffixIcon: Checkbox(
                          value: isCheckedWorkSchedule,
                          onChanged: (value) {
                            setState(() {
                              isCheckedWorkSchedule = value!;
                              _setSearchFields(2);
                              haveFields = true;
                              if (value == false) {
                                dropDownSearchFieldsEntries = [];
                                isCheckedHCP = false;
                                isCheckedClient = false;
                                currentArgument!['searchCollection'] = 'None';
                              } else {
                                currentArgument!['searchCollection'] =
                                    'ClientWorkOrder';

                                isCheckedHCP = !value;
                                isCheckedClient = !value;
                              }
                            });
                          },
                        ),
                      ),
                      maxLength: 280,
                      validator: (value) {
                        return null;
                      }),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      height: 150,
                      width: 295,
                      padding: EdgeInsets.only(left: 10, top: 20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: DropdownMenu<dynamic>(
                              initialSelection: null,
                              //    "Corporate",
                              controller: searchFieldsController,
                              //  requestFocusOnTap is enabled/disabled by platforms when it is null.
                              //  On mobile platforms, this is false by default. Setting this to true will
                              // trigger focus request on the text field and virtual keyboard will appear
                              //   afterward. On desktop platforms however, this defaults to true.
                              requestFocusOnTap: true,
                              label: Container(
                                  height: 50,
                                  width: 290,
                                  child: Text('Search Fields')),
                              onSelected: (dynamic value) {
                                setState(() {
                                  int index = 0;
                                  if (isCheckedHCP) {
                                    index = 1;
                                  } else if (isCheckedWorkSchedule) {
                                    index = 2;
                                  }
                                  String ivv = _getSelectedSearchFieldIndex(
                                      index, value);
                                  selectedSearchField = value;
                                  currentArgument!['searchField'] = ivv;

                                  print(
                                      'line 165: $ivv ${selectedSearchField}');
                                });
                              },

                              dropdownMenuEntries: dropDownSearchFieldsEntries,
                            ),
                          ),
                          selectedSearchField != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        height: 50,
                                        width: 285,
                                        child: Text(
                                            'Selected: ${selectedSearchField}')),
                                  ],
                                )
                              : Container(
                                  height: 50,
                                  width: 285,
                                  child: Text('Please select search Field'),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 150,
                  width: 285,
                  child: TextFormField(
                    autofocus: false,
                    onChanged: (value) {
                      currentTermsValue = value;
                      searchTermsController.text = value;
                    },
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    controller: searchTermsController,
                    maxLength: 280,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(label: Text('Search Term(s)')),
                  ),
                ),
                Container(
                    height: 50,
                    width: 100,
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            setDataElements();
                          },
                          child: Center(
                            child: Text('Done',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          )),
                    ))
              ],
            ),
          ),
          right: flagHasTopLevelBranch == true && flagHaveQueryData == true
              ? Container(
                  width: screenWidth! - 310,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    color: color1,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Row(
                        children: [
                          TabsWeb(
                              title: 'Home', route: homePage, argumentId: null),
                          Spacer(),
                          TabsWeb(
                              title: 'Work Order',
                              route: workOrderPage,
                              argumentId: -1,
                              argumentMap: currentArgument),
                          Spacer(),
                          TabsWeb(
                              title: 'Clients',
                              route: clientPage,
                              argumentId: -1,
                              argumentMap: currentArgument),
                          Spacer(),
                          TabsWeb(
                              title: 'HC Professionals',
                              route: hcprofessionalPage,
                              argumentId: -1,
                              argumentMap: currentArgument),
                          Spacer(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Center(
                        child: Text(
                            "This application has been developed to provide both Corporate and Branch users the capabilities of view and modifying data elements.  Any changes made to the data presented in this applications will be replicated in the StafferLink's primary database as well as the database for the target mobile devices.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color2,
                            )),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
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
      {Key? key, required this.left, required this.right, this.ratio = 0.25});

  @override
  _VerticalSplitViewState createState() => _VerticalSplitViewState();
}

class _VerticalSplitViewState extends State<VerticalSplitView> {
  final _dividerWidth = 16.0;

  //from 0-1
  double? _ratio;
  double? _maxWidth;

  get _width1 => _ratio! * _maxWidth!;

  get _width2 => (1 - _ratio!) * _maxWidth!;

  @override
  void initState() {
    super.initState();

    _ratio = widget.ratio;
    _ratio = 0.25;
    print('line 99:  $_ratio');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      print('line 296: ${constraints.maxWidth}');
      if (_maxWidth == null) _maxWidth = constraints.maxWidth - _dividerWidth;
      if (_maxWidth != constraints.maxWidth) {
        _maxWidth = constraints.maxWidth - _dividerWidth;
      }
      print('line 300: ${_maxWidth!}');
      return SizedBox(
        width: constraints.maxWidth,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 320, //_width1,
              child: widget.left,
            ),
            SizedBox(
              width: _maxWidth! - 320,
              child: widget.right,
            ),
          ],
        ),
      );
    });
  }
}
