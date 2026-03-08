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
  }

  DropDownCodes dropDownCodes = DropDownCodes();

  bool isLoggedIn = true;
  double? screenHeight;
  double? screenWidth;
  double? fontSize;
  String? selectedBranch;
  String? selectedMenuOption;
  int? selectedBranchNumber;
  bool flagHaveData = false;
  TextEditingController branchController = TextEditingController();
  TextEditingController menuOptionController = TextEditingController();
  List<DropdownMenuEntry<dynamic>> dropDownBranchEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
  String? _value;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  bool flagHaveCalled = false;
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
    print('line 406: $fontSize $h');

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
          left: Container(
              decoration: BoxDecoration(
                color: color1,
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  // SizedBox(width: screenWidth! - 10, height: 5),
                  Row(
                    children: [
                      Container(
                        height: 500,
                        width: 295,
                        padding: EdgeInsets.only(left: 10, top: 35),
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
                                    height: 80,
                                    width: 285,
                                    child: Text('Branch')),
                                onSelected: (dynamic value) {
                                  setState(() {
                                    selectedBranch = value;
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
                                                      BorderRadius.circular(
                                                          12)),
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
                                    height: 50,
                                    width: 285,
                                    child: Text('Please select a branch.'),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
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
                        argumentId: 0),
                    Spacer(),
                    TabsWeb(
                        title: 'Clients',
                        route: clientPage,
                        argumentId: selectedBranchNumber),
                    Spacer(),
                    TabsWeb(
                        title: 'HC Professionals',
                        route: hcprofessionalPage,
                        argumentId: selectedBranchNumber),
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
