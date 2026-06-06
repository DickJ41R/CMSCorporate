import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cms_web/features/shared/views/taskview.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientMenu extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientMenu({super.key, required this.args});

  @override
  State<ClientMenu> createState() => _ClientMenuState();
}

class _ClientMenuState extends State<ClientMenu> {
  String? localTitle;

  AuthService authServices = AuthService();
  Map<String, dynamic>? clientMap;
  @override
  void initState() {
    super.initState();
    debugPrint('line 19 in client menu ${widget.args}');
    localTitle = 'Client Menu';
    arguments = widget.args;
    clientMap = authServices.clientMap;
    _setMenus();
  }

  bool isLoggedIn = true;
  double? screenHeight;
  double? fontSize;
  String? selectedMenu;
  int? selectedMenuName;
  int? selectedMenuNumber;
  bool flagHaveData = false;
  TextEditingController menuController = TextEditingController();
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
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
  List<Map<String, dynamic>> clientMenus = [
    {
      "menuId": 1,
      "menuName": "Client Profile Menu",
      "menuRouteName": "/clientProfileMenu",
      "index": 0
    },
    {
      "menuId": 2,
      "menuName": "Client Scheduling Menu",
      "menuRouteName": "/clientSchedulingMenu",
      "index": 1
    }
  ];
  List<Map<String, dynamic>> genericMenu = [];
  List<Map<String, dynamic>> clientSchedulingMenus = [
    {
      "menuId": 1,
      "menuName": "Cancel Shifts",
      "menuRouteName": "/clientCancelShiftsSchedulingPage",
      "index": 0
    },
    {
      "menuId": 2,
      "menuName": "Republish Shifts",
      "menuRouteName": "/clientRepublishShiftsSchedulingPage",
      "index": 1
    },
    {
      "menuId": 3,
      "menuName": "Schedule Shifts",
      "menuRouteName": "/clientScheduleShiftsSchedulingPage",
      "index": 2
    },
    {
      "menuId": 4,
      "menuName": "Approve Shifts",
      "menuRouteName": "/clientApproveShiftsSchedulingPage",
      "index": 3
    },
    // {
    //   "menuId": 5,
    //   "menuName": "Confirm Shifts",
    //   "menuRouteName": "/clientConfirmShiftsSchedulingPage",
    //   "index": 4
    // },
    {
      "menuId": 5,
      "menuName": "List Schedule",
      "menuRouteName": "/clientListScheduleSchedulingPage",
      "index": 4
    },
    {
      "menuId": 6,
      "menuName": "Schedule View",
      "menuRouteName": "/clientScheduleViewSchedulingPage",
      "index": 5
    },
    {
      "menuId": 7,
      "menuName": "Do Not Schedule List",
      "menuRouteName": "/clientDoNotScheduleListSchedulingPage",
      "index": 6
    },
    {
      "menuId": 8,
      "menuName": "Mitigate Shift OT",
      "menuRouteName": "/clientMitigateOTSchedulingPage",
      "index": 7
    },
    // {
    //   "menuId": 9,
    //   "menuName": "Set a DNS",
    //   "menuRouteName": "/clientSetDNSSchedulingPage",
    //   "index": 8
    // },
    // {
    //   "menuId": 10,
    //   "menuName": "Timecard Approval",
    //   "menuRouteName": "/clientTimecardApprovalSchedulingPage",
    //   "index": 8
    // },
    // {
    //   "menuId": 11,
    //   "menuName": "Cannot Be Scheduled",
    //   "menuRouteName": "/clientTimecardApprovalSchedulingPage",
    //   "index": 8
    // },
  ];
  String genericTitle = '';
  List<Map<String, dynamic>> clientProfileMenus = [
    {
      "menuId": 1,
      "menuName": "Client",
      "menuRouteName": "/clientProfilePage",
      "index": 0
    },
    {
      "menuId": 2,
      "menuName": "Client Users",
      "menuRouteName": "/clientUserProfilePage",
      "index": 1
    },
    {
      "menuId": 3,
      "menuName": "Client Addresses",
      "menuRouteName": "/clientAddressProfilePage",
      "index": 2
    },
    {
      "menuId": 4,
      "menuName": "Client Contacts",
      "menuRouteName": "/clientContactProfilePage",
      "index": 3,
    },
    {
      "menuId": 5,
      "menuName": "Client Credit",
      "menuRouteName": "/clientCreditProfilePage",
      "index": 4
    },
    {
      "menuId": 6,
      "menuName": "Client Departments",
      "menuRouteName": "/clientDepartmentProfilePage",
      "index": 5
    },
    // {
    //   "menuId": 7,
    //   "menuName": "Client Credentials",
    //   "menuRouteName": "/clientCredentialsProfilePage",
    //   "index": 6
    // },
    {
      "menuId": 7,
      "menuName": "HCPs Cannot Be Scheduled",
      "menuRouteName": "/clientCannotBeScheduledProfilePage",
      "index": 6
    },
  ];

  int showRightSide = -1;
  List<Map<String, dynamic>> genericMenu1 = [];
  Map<String, dynamic>? arguments;
  void _setMenus() {
    for (int i = 0; i < clientMenus.length; i++) {
      // String st = userBranches[i]['branchName'];
      //  Text ts = Text('Index $i: $st', style: optionStyle);
      //  _widgetOptions.add(userBranches[i]);
      Map<String, dynamic> mp = clientMenus[i];
      DropdownMenuEntry me = DropdownMenuEntry(
          value: mp['menuName'].toString(), label: mp['menuName']);
      dropDownMenuEntries.add(me);
    }
  }

  int getSelectedMenuIndex(value) {
    debugPrint('line 342 getselected branchindex : $value');

    for (int i = 0; i < dropDownMenuEntries.length; i++) {
      DropdownMenuEntry de = dropDownMenuEntries[i];
      if (value == de.value) {
        return i;
      }
    }
    return -1;
  }

  bool showLoadingIndicator = true;
  bool isLoading = false;
//
  int selectedMenuIndex = -1;
  Future<bool> _showDialog(
      BuildContext context, String title, String? description) async {
    debugPrint('line 12 showdialog');
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color2,
                  fontWeight: FontWeight.bold,
                )),
            content: Text(description!,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color2,
                  fontWeight: FontWeight.bold,
                )),
            contentTextStyle: TextStyle(
              color: color1,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            titleTextStyle: TextStyle(
                color: Color.fromARGB(255, 19, 125, 103),
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () => Navigator.pop(context, 'Cancel'),
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: (() {
                  Navigator.pop(context, true);
                }),
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 125, 103)),
                ),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null || exit == false) {
        return false;
      } else {
        return true;
      }
    });
  }

  String? description;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool flagHasSnackbar = false;
    if (screenWidth < 1220) {
      double dif = 1220 - screenWidth;
      String title = 'Screen Width';
      String sdif = dif.toStringAsFixed(0);
      description =
          'Extend the width of your screen to the right until the menu appears on left.';
      flagHasSnackbar = true;
    }
    debugPrint(
        'line build 184: $screenWidth $selectedMenu $showRightSide $flagHaveData $flagHaveCalled');
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 18 / h;
    debugPrint('line 406: $fontSize $h');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localTitle!,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                final navigator = Navigator.of(context)
                    .pushNamed(landingPageWeb, arguments: arguments!);
              }),
        ),
      ),
      body: flagHasSnackbar == true
          ? Center(
              heightFactor: 50,
              widthFactor: 50,
              child: Text(description!),
            )
          : VerticalSplitView(
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
                            height: 100,
                            width: 295,
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: DropdownMenu<dynamic>(
                                    initialSelection: null,
                                    //    "Corporate",
                                    controller: menuController,
                                    //  requestFocusOnTap is enabled/disabled by platforms when it is null.
                                    //  On mobile platforms, this is false by default. Setting this to true will
                                    // trigger focus request on the text field and virtual keyboard will appear
                                    //   afterward. On desktop platforms however, this defaults to true.
                                    requestFocusOnTap: true,
                                    label: const Text('Client Menu'),
                                    onSelected: (dynamic value) {
                                      debugPrint('line 258 on selected $value');
                                      selectedMenu = value;
                                      selectedMenuIndex =
                                          getSelectedMenuIndex(value);
                                      debugPrint('line 262: $selectedMenuIndex');
                                      selectedMenuName =
                                          clientMenus[selectedMenuIndex]
                                              ['clientRouteName'];
                                      setState(() {
                                        if (selectedMenuIndex == 0) {
                                          //    dropDownMenuOptionEntries = [];
                                          showRightSide = 0;

                                          // genericMenu = clientProfileMenus;
                                          genericTitle = 'Client Profile Menu';
                                        } else {
                                          // dropDownMenuOptionEntries = [];
                                          showRightSide = 1;

                                          //genericMenu = clientSchedulingMenus;
                                          genericTitle =
                                              'Client Scheduling Menu';
                                        }
                                      });
                                    },
                                    dropdownMenuEntries: dropDownMenuEntries,
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
                                  const Text('Please select a Client Menu.'),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
              right: showRightSide == -1
                  ? Container()
                  : showRightSide == 0
                      ? Container(
                          height: screenHeight! - 100,
                          width: screenWidth - 295,
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                width: 295,
                                child: Center(
                                  child: Text(
                                    '$genericTitle',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Container(
                                  width: screenWidth - 295,
                                  height: screenHeight! - 200,
                                  decoration: BoxDecoration(
                                    color: color1,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    restorationId: 'ClientListView',
                                    itemCount: clientProfileMenus.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item = clientProfileMenus[index];
                                      debugPrint('line 243: $index ${item}');
                                      return VerticalTile(
                                        menuItem: clientProfileMenus[index],
                                        arguments: arguments!,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: screenHeight! - 100,
                          width: screenWidth - 295,
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                width: 295,
                                child: Center(
                                  child: Text(
                                    '$genericTitle',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Container(
                                  width: screenWidth - 295,
                                  height: screenHeight! - 200,
                                  decoration: BoxDecoration(
                                    color: color1,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    restorationId: 'ClientListView1',
                                    itemCount: clientSchedulingMenus.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item = clientSchedulingMenus[index];
                                      debugPrint('line 402: $index ${item}');

                                      return VerticalTile1(
                                        menuItem: clientSchedulingMenus[index],
                                        arguments: arguments!,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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
      {Key? key, required this.left, required this.right, this.ratio = 0.5});

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
