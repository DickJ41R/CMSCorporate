import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cms_web/features/shared/views/taskview.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/dropdown_codes.dart';

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

  void _setSearchFields(int index) {
    dropDownSearchFieldsEntries = [];

    switch (index) {
      case 0:
        {
          print('line 96: ${clientFields!.length}');
          for (int i = 0; i < clientFields!.length; i++) {
            DropdownMenuEntry me = DropdownMenuEntry(
                value: clientFields![i], label: clientFields![i]);
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
  List<dynamic>? clientFields;
  List<dynamic>? workOrderFields;
  List<dynamic>? hcpFields;

  void _setClientFields() {
    clientFields = [
      'Client Id',
      'Client Name',
      'Status',
      'Branch Id',
      'Branch Name'
    ];
  }

  void _setHCPFields() {
    hcpFields = [
      'Hcp Id',
      'Hcp Name (LastName, FirstName',
      'Status',
      'Branch Id',
      'Branch Name'
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

  Map<String, dynamic> argumentContainer = {
    'searchCriteria': 'All',
    'searchValue': 0,
    'searchCollection': 'None',
    'searchField': 'None',
  };
  void _setSearchCriteria() {
    searchCriteria = [
      "All",
      'Is Equal To',
      "Is Less Than",
      "Is Less Than or Equal To",
      "Is Greater Than",
      "Is Greater Than or Equal To",
      "Is Between (Include Edges)",
      "Is Between (Do not Include Edges)",
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

  bool showLoadingIndicator = true;
  bool isLoading = false;
//
  int selectedBranchIndex = -1;
  int selectedMenuOptionIndex = -1;

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
                                  argumentContainer['searchValue'] = value;
                                  selectedBranchIndex =
                                      getSelectedBranchIndex(value);
                                  int idx = value.indexOf(')');
                                  if (idx != -1) {
                                    String st = value.substring(0, idx);
                                    st = st.replaceAll('(', '');
                                    st = st.trim();
                                    selectedBranchNumber = int.parse(st);
                                  }
                                  // selectedBranchNumber =
                                  //     userBranches![selectedBranchIndex]
                                  //         ['branchId'];
                                  print('line 165: ${selectedBranchNumber}');
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
                                  argumentContainer['searchCriteria'] = value;

                                  print('line 165: ${selectedSearchCriteria}');
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
                                isCheckedHCP = false;
                                isCheckedWorkSchedule = false;
                              } else {
                                argumentContainer['searchCollection'] =
                                    'Client';
                                isCheckedHCP = !value;
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
                              } else {
                                argumentContainer['searchCollection'] =
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
                        label: Text('Search For HCPs'),
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
                              } else {
                                argumentContainer['searchCollection'] =
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
                                  selectedSearchField = value;
                                  argumentContainer['searchField'] = value;

                                  print('line 165: ${selectedSearchField}');
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
                      onChanged: (value) {
                        argumentContainer['searchValue'] = value;
                      },
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      controller: searchTermsController,
                      maxLength: 280,
                      minLines: 1,
                      maxLines: 3,
                      decoration:
                          InputDecoration(label: Text('Search Term(s)')),
                      validator: (value) {
                        return null;
                      }),
                ),
              ],
            ),
          ),
          right: Container(
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
                    TabsWeb(title: 'Home', route: homePage, argumentId: null),
                    Spacer(),
                    TabsWeb(
                      title: 'Work Order',
                      route: workOrderPage,
                      argumentId: -1,
                      argumentMap: argumentContainer,
                    ),
                    Spacer(),
                    TabsWeb(
                        title: 'Clients',
                        route: clientPage,
                        argumentId: -1,
                        argumentMap: argumentContainer),
                    Spacer(),
                    TabsWeb(
                        title: 'HC Professionals',
                        route: hcprofessionalPage,
                        argumentId: -1,
                        argumentMap: argumentContainer),
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
          ),
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
