import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cms_web/features/hcpapp/repositories/hcps_data_source.dart';
import 'package:cms_web/features/hcpapp/models/hcp_class.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';

// Replace the defaultFirebaseOptions with your own Firebase options.
const defaultFirebaseOptions = FirebaseOptions(
  apiKey: '',
  authDomain: '',
  projectId: '',
  storageBucket: '',
  messagingSenderId: '',
  appId: '',
);

final dio = Dio();

class HCProfessionalStreamScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const HCProfessionalStreamScreen({super.key, required this.args});

  @override
  State<HCProfessionalStreamScreen> createState() =>
      _HCProfessionalStreamScreenState();
}

class _HCProfessionalStreamScreenState
    extends State<HCProfessionalStreamScreen> {

  late HCPClassDataSource hcpClassDataSource;

  List<HCPClass> hcpClasses = <HCPClass>[];

  AuthService authServices = AuthService();
  HCPServices hcpServices = HCPServices();
  UtilitiesServices util = UtilitiesServices();
  late String formatted;
  late double fontSize;
  late List<Map<String, dynamic>> listOfHCPClassData;
  late List<HCPClass> HCPClassData = [];
  List<HCPClass>_hcps = [];
  int get rowCount => listOfHCPs.length;
  List<HCPClass> paginatedDataSource = [];
List<HCPClass> _paginatedHcps = [];

  // @override
  // Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
  //     int startRowIndex, int rowsPerPage) async {
  //   int endIndex = startRowIndex + rowsPerPage;
  //   if (endIndex > listOfHCPs.length) {
  //     endIndex = listOfHCPs.length - 1;
  //   }
  //
  //   paginatedDataSource = List.from(
  //       listOfHCPs.getRange(startRowIndex, endIndex).toList(growable: false));
  //   notifyListeners();
  //   return true;
  // }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  String? documentId;
  Map<String, dynamic>? arguments;
  List<HCPClass> getHCPData() {
    List<HCPClass> hcp = hcpClasses;
    return hcp;
  }

  // Add maxWidth constraint check

  List<HCPClass> hcpClassData = [];
  Stream<QuerySnapshot>? _hcpStream;
  int? _rowsPerPage;
  List<Map<String, dynamic>> listOfHCPs = [];
  List<Map<String, dynamic>> holdHCPs = [];
  final double _dataPagerHeight = 60.0;
  List<Map<String, dynamic>>? hcpm;
  TextEditingController hcpIdController = TextEditingController();
  TextEditingController statusIdController = TextEditingController();
  TextEditingController SSNController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController genderCodeDescriptionController = TextEditingController();
  TextEditingController disciplineNameController = TextEditingController();
  TextEditingController workerTypeController = TextEditingController();
  TextEditingController credsWillWarnDateController = TextEditingController();
  TextEditingController lastWorkedController = TextEditingController();

  Future<List<Map<String, dynamic>>> _getAllHCPsData() async {
    try {
      debugPrint('line 85: ${authServices.holdHcp.length}');
      if (authServices.holdHcp.length > 0) {
        debugPrint('line 74: ${authServices.holdHcp.length}');
         listOfHCPs = authServices.holdHcp;
        _hcps = authServices.hcps;
        HCPClassData = authServices.hcpClassData;
        _rowsPerPage = authServices.rowsPerPage;
        debugPrint('line 73  ${listOfHCPs.length}');
        if (listOfHCPs.length > 0) {
          return listOfHCPs;
        }
      }
      debugPrint('line 92: $arguments');
      _rowsPerPage = 15;
      authServices.rowsPerPage = _rowsPerPage!;
      _hcps = [];
      authServices.holdClm = [];
      authServices.clients = [];

      Query query = util.buildDynamicQuery(arguments!);
      hcpm = await hcpServices.getHCProfessionalsByArgument(arguments!);
      if (hcpm == null || hcpm!.length == 0 ) {
        return [];
      }
      _rowsPerPage = 15;

      if (hcpm!.length < _rowsPerPage!) {
        _rowsPerPage = hcpm!.length;
      }
      debugPrint('line 80');
      for (int i=0; i < hcpm!.length; i++) {
        Map<String, dynamic>obj = hcpm![i];
        _hcps.add(HCPClass.fromJson(obj));
      }
      authServices.hcps = _hcps;
      authServices.holdHcp = hcpm!;
      debugPrint('line 104');
      listOfHCPs = hcpm!;
      return hcpm!;
    } catch (e) {
      debugPrint('line 130: ${e.toString()}');
      throw Exception('line 131 Error getting hcp data');
    }
  }

  double _getPageCount(int len, int rowsPerPage) {
    debugPrint('line 136: $len $rowsPerPage');
    try {
      int addOn = 0;
      if (len % rowsPerPage > 0) {
        addOn = 1;
      }
      double lend =  len.toDouble();
      double rppd =  rowsPerPage.toDouble();
      debugPrint('line 144 page count: $lend $rppd');
      int pgc = (lend / rppd).toInt();
      pgc += addOn;
      debugPrint('line 147 page count: $pgc');
      double pgd = pgc.toDouble();
      debugPrint('line 149 page count: $pgd');
      return pgd;

    } catch(e) {
      print('line 153 page count error ${e.toString()}');
      throw Exception('line 154 page count: ${e.toString()}');
    }
  }
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 272: $arguments!');
    fontSize = 18;

  }


  @override
 void dispose() {
     super.dispose();
     hcpIdController.dispose();
     statusIdController.dispose();
     SSNController.dispose();
     fullNameController.dispose();
     branchNameController.dispose();
     genderCodeDescriptionController.dispose();
     disciplineNameController.dispose();
     workerTypeController.dispose();
     credsWillWarnDateController.dispose();
     lastWorkedController.dispose();

 }
  double pageCount = 0.0;
  void _updatePageCount() {
    debugPrint(
        'line 116 updatepagecount: ${hcpClassDataSource.filterConditions.isNotEmpty}');

    final rowsCount = hcpClassDataSource.filterConditions.isNotEmpty
        ? hcpClassDataSource.effectiveRows.length
        : listOfHCPs.length;
    debugPrint('line 121: $rowsCount');
    if (rowsCount > 0) {
      pageCount = (rowsCount / _rowsPerPage!.toDouble()).floorToDouble();
      //  pageCount = (rowsCount / _rowsPerPage).ceilToDouble();
    }
    debugPrint('line 122: $rowsCount $pageCount');
  }

  double? screenWidth;
  double? screenHeight;
  double count = 0;
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    //screenHeight = MediaQuery.sizeOf(context).height;
    //screenWidth = MediaQuery.sizeOf(context).width;
    screenWidth = MediaQuery.of(context).size.width;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    debugPrint('line 87: $screenHeight $screenWidth');
    return Scaffold(
      appBar: AppBar(
        title: Text('Select HCP From List Screen',
            style: TextStyle(
                backgroundColor: color1,
                fontSize:
                    Theme.of(context).textTheme.headlineSmall!.fontSize! / h,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () {
            // shiftClasses = shiftClassDataSource.returnShiftClasses();
            // debugPrint('line 99: ${shiftClasses[0].shiftCode} ${shiftClasses[0].shiftCount}');
            Navigator.of(context).pop(null);
          },
        ),
      ),
      //   body: LayoutBuilder(builder: (context, dimens) {
      //     // Tablet Layout
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: _clientStream!,
      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) return LinearProgressIndicator();
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait([_getAllHCPsData()]),
          builder: (context, snapshot) {
            // debugPrint(
            //     'line 211: ${snapshot.hasError} ${snapshot.hasData} ${ConnectionState} ');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  height: 100,
                  width: screenWidth! - 10,
                  child: Text('Error: ${snapshot.error}',
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontSize: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall!
                              .fontSize! /
                              h!,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Container(
                  height: 100,
                  width: screenWidth! - 10,
                  child: Text('There are no HCPs to list.',
                      style: TextStyle(
                          fontSize: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall!
                              .fontSize! /
                              h!,
                          color: color2,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else {
              List<dynamic> data = snapshot.data![0];
              debugPrint('line 292 ${data.length}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    width: screenWidth! - 10,
                    child: Text('There are no HCPs to list.',
                        style: TextStyle(
                            fontSize: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize! /
                                h!,
                            color: color2,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              } else {
                List<Map<String, dynamic>> listH = snapshot.data![0];
                //    debugPrint('line 312: ${listH.length} ${listH[0]}');
                if (_rowsPerPage! > listH.length) {
                  _rowsPerPage = listH.length;
                }
                //   debugPrint('line 312: ${listH.length} ${listH[0]}');
                hcpClassData.clear();
                listH.forEach((doc) {
                  //  debugPrint('line 307: ${doc.data()}');
                  hcpClassData.add(HCPClass.fromJson(doc));
                });
                //   debugPrint('line 311: ${clientClassData[0].clientId}');

                hcpClassDataSource = HCPClassDataSource(hcpClassData,
                     _rowsPerPage!, _hcps, _paginatedHcps);
                authServices.hcpClassData = hcpClassData;
                return LayoutBuilder(builder: (context, constraint) {
                  return Column(children: [
                    SizedBox(
                        height: constraint.maxHeight - _dataPagerHeight,
                        width: constraint.maxWidth,
                        child: buildDataGrid(constraint)),
                    Container(
                        height: _dataPagerHeight,
                        child: SfDataPager(
                          delegate: hcpClassDataSource,
                          pageCount: _getPageCount(_hcps.length, _rowsPerPage!),
                          direction: Axis.horizontal,
                        ))
                  ]);
                });
              }
            }
          },
            ),
            );
          }

          Widget buildDataGrid(BoxConstraints constraint) {
            return SfDataGrid(
              columnWidthMode: ColumnWidthMode.fill,
              source: hcpClassDataSource,
              columns: <GridColumn>[
              GridColumn(
                columnName: 'ID',
                label: TextField(
                controller: hcpIdController,
                decoration: InputDecoration(
                hintText: 'HCP ID',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
                ),
                suffixIcon: IconButton(
                onPressed: () {
                hcpIdController.text = '';
                },
                icon: Icon(Icons.clear),
                ),
              ),
              ),
            ),
            GridColumn(
                    allowFiltering: false,
                    columnName: 'Sts',
                    allowSorting: false,
                    width: 50,
                    maximumWidth: 50,
                    allowEditing: false,
                    label: Container(
                        width: 50,
                        height: 32,
                        padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                        alignment: Alignment.center,
                        child: Text('Sts',
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: fontSize)))),
            GridColumn(
            allowFiltering: false,
            columnName: 'SSN',
            allowSorting: false,
            width: 50,
            maximumWidth: 50,
            allowEditing: false,
            label: Container(
            width: 50,
            height: 32,
            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
            alignment: Alignment.center,
            child: Text('SSN',
            style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize)))),
            GridColumn(
             columnName: 'HCP Name',
            label: TextField(
            decoration: InputDecoration(
            hintText: 'HCP Name',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
            ),
            ),
            ),
            ),
                GridColumn(
                  columnName: 'Branch Name',
                  label: TextField(
                    decoration: InputDecoration(
                      hintText: 'Branch Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Gender',
                  label: TextField(
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Disc',
                  label: TextField(
                    decoration: InputDecoration(
                      hintText: 'Disc',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Worker Type',
                  label: TextField(
                    decoration: InputDecoration(
                      hintText: 'Worker Type',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Will Warn',
                  label: TextField(
                    decoration: InputDecoration(
                      hintText: 'Will Warn',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Worked',
                  label: TextField(
                    decoration: InputDecoration(
                      hintText: 'Worked',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ],

          allowEditing: true,
          editingGestureType: EditingGestureType.doubleTap,
          onQueryRowHeight: (details) {
          // Set the row height as 70.0 to the column header row.
          return details.rowIndex == 0 ? 30.0 : 50.0;
          },
          // rowHeight: 40,
          selectionMode: SelectionMode.single,
          onSelectionChanged: (addedRows, removedRows) async {
          debugPrint(
          'line 343: ${addedRows.length} ${addedRows[0].getCells()}');
          final List<DataGridCell> cells = addedRows[0].getCells();
          final int colIndex = cells
          .indexWhere((cell) => cell.columnName == 'ID');
          debugPrint('line 347: $colIndex');
          int currentId = -1;
          if (colIndex != -1) {
          // Get and increment the current ID value.
          currentId = int.parse(cells[colIndex].value.toString());
          debugPrint('line 351: $currentId');
          }
            final int colIndex2 = cells
          .indexWhere((cell) => cell.columnName == 'HCP Name');
          String hcpName = '';
          if (colIndex2 != -1) {
          // Get and increment the current ID value.
          hcpName = cells[colIndex2].value;
          debugPrint('line 358 $hcpName');
          }
          for (int i = 0; i < listOfHCPs.length; i++) {
          Map<String, dynamic> lc = listOfHCPs[i];
          if (currentId == int.parse(lc['hcpId'].toString())) {
          authServices.hcpMap = lc;
          break;
          }
          }
          authServices.targetType = "HCP";
          // Map<String, dynamic>? smp =
          //     await clientServices.getASingleClientUser(
          //         authServices.clientMap!['clientId']);
          // debugPrint('line 304: $smp');
          // if (smp!.containsKey('clientId') == true) {
          //   authServices.clientUserMap = smp;
          // }
          Map<String, String> args = {
          'hcpId': currentId.toString(),
          'fullName': hcpName
          };
          Navigator.of(context)
          .pushNamed(hcpMenu, arguments: args);
          },
          );
          }
          }
