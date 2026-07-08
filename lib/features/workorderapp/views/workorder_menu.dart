import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/views/taskview.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'dart:ui';
class WorkOrderMenu extends StatefulWidget {
  final Map<String, dynamic> args;
  const WorkOrderMenu({super.key, required this.args});

  @override
  State<WorkOrderMenu> createState() => _HCPMenuState();
}

class _HCPMenuState extends State<WorkOrderMenu> {
  String? localTitle;
  @override
  void initState() {
    super.initState();
    debugPrint('line 19 in  workorder menu ${widget.args}');
    localTitle = 'WorkOrder Menu';
    arguments = widget.args;
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

  List<Map<String, dynamic>> genericMenu = [];
  List<Map<String, dynamic>> workOrderMenus = [
    {
      "menuId": 1,
      "menuName": "List Edit Work Order",
      "menuRouteName": "/editWorkOrderPage",
      "index": 0
    },

  ];
  String genericTitle = '';

  int showRightSide = -1;
  List<Map<String, dynamic>> genericMenu1 = [];
  Map<String, dynamic>? arguments;
  void _setMenus() {
    for (int i = 0; i < workOrderMenus.length; i++) {
      // String st = userBranches[i]['branchName'];
      //  Text ts = Text('Index $i: $st', style: optionStyle);
      //  _widgetOptions.add(userBranches[i]);
      Map<String, dynamic> mp = workOrderMenus[i];
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
  String? description;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    debugPrint(
        'line build 217: $screenWidth $selectedMenu $showRightSide $flagHaveData $flagHaveCalled');
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 18 / h;
    debugPrint('line 406: $fontSize $h');
    bool flagHasSnackbar = false;
    screenWidth = 1350;
    if (screenWidth < 1350) {
      double dif = 1350 - screenWidth;
      String title = 'Screen Width';
      String sdif = dif.toStringAsFixed(0);
      description =
          'Extend the width of your screen on the right by dragging the right border until menu appears on left.';
      flagHasSnackbar = true;
    }
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
      body: ScrollConfiguration(
        // 1. Target the specific area containing your split view
        behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse, // Ensures mouse-drag resizing still works flawlessly
          PointerDeviceKind.stylus,
        }),
    child: flagHasSnackbar == true
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
                      SizedBox(width: 300, height: 5),
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: 300,
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
                                    label: const Text('Work Order Menu'),
                                    onSelected: (dynamic value) {
                                      debugPrint('line 258 on selected $value');
                                      selectedMenu = value;
                                      selectedMenuIndex =
                                          getSelectedMenuIndex(value);
                                      debugPrint('line 262: $selectedMenuIndex');
                                      selectedMenuName =
                                          workOrderMenus[selectedMenuIndex]
                                              ['WorkOrderRouteName'];
                                      setState(() {
                                        if (selectedMenuIndex == 0) {
                                          //    dropDownMenuOptionEntries = [];
                                          showRightSide = 0;

                                          // genericMenu = clientProfileMenus;
                                          genericTitle = 'Work Order Menu';
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
                                  const Text('Please select a Work Order Menu.'),
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
                          width: 600,
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                width: 600,
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
                                  width: 600,
                                  height: screenHeight! - 200,
                                  decoration: BoxDecoration(
                                    color: color1,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    restorationId: 'WorkOrderListView',
                                    itemCount: workOrderMenus.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item = workOrderMenus[index];
                                      debugPrint('line 243: $index ${item}');
                                      return VerticalTile(
                                        menuItem: workOrderMenus[index],
                                        arguments: arguments!,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
          )
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
