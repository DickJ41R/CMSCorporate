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
      List<Map<String, dynamic>>? hcpm =
          await hcpServices.getHCProfessionalsByArgument(arguments!);
      if (hcpm == null || hcpm!.length == 0 ) {
        return [];
      }
      debugPrint('line 104');
      listOfHCPs = hcpm;
      holdHCPs = hcpm;
      authServices.holdHcp = holdHCPs;
      _rowsPerPage = 15;
      final rowsCount = (listOfHCPs.length).toDouble();
      pageCount = (rowsCount / _rowsPerPage!.toDouble()).floorToDouble();
      debugPrint('line 91: $rowCount $pageCount $_rowsPerPage');


      authServices.rowsPerPage = _rowsPerPage!;
      if (pageCount == 0) {
        pageCount =1;
      }
      return listOfHCPs;
    } catch (e) {
      debugPrint('line 116 ${e.toString()}');
      throw Exception('line 116 Error getting hcp data');
    }
  }
  double _getPageCount(int len, int rowsPerPage) {
    debugPrint('line 121: $len $rowsPerPage');
    try {
      int addOn = 0;
      if (len % rowsPerPage > 0) {
        addOn = 1;
      }
      double lend =  len.toDouble();
      double rppd =  rowsPerPage.toDouble();
      debugPrint('line 176 $lend $rppd');
      int pgc = (lend / rppd).toInt();
      pgc += addOn;
      debugPrint('line 179 $pgc');
      double pgd = pgc.toDouble();
      debugPrint('line 181: $pgd');
      return pgd;

    } catch(e) {
      print('line 173 error ${e.toString()}');
      throw Exception('line 174: ${e.toString()}');
    }
  }
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 272: $arguments!');
    fontSize = 18;

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

  TextEditingController fullNameController = TextEditingController();


  TextEditingController hcpIdController = TextEditingController();
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
                hcpClassDataSource = HCPClassDataSource(
                    hcpClassData, _rowsPerPage!, _hcps, _paginatedHcps);
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
                columnName: 'HCP ID',
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
             columnName: 'Full Name',
            label: TextField(
            controller: fullNameController,
            decoration: InputDecoration(
            hintText: 'Full Name',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
            ),
            suffixIcon: IconButton(
            onPressed: () {
            fullNameController.text = '';
            },
            icon: Icon(Icons.clear),
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
          .indexWhere((cell) => cell.columnName == 'Client ID');
          debugPrint('line 347: $colIndex');
          int currentId = -1;
          if (colIndex != -1) {
          // Get and increment the current ID value.
          currentId = int.parse(cells[colIndex].value);
          debugPrint('line 351: $currentId');
          }
            final int colIndex2 = cells
          .indexWhere((cell) => cell.columnName == 'Full Name');
          String hcpName = '';
          if (colIndex2 != -1) {
          // Get and increment the current ID value.
          hcpName = cells[colIndex2].value;
          debugPrint('line 358 $hcpName');
          }
          for (int i = 0; i < listOfHCPs.length; i++) {
          Map<String, dynamic> lc = listOfHCPs[i];
          if (currentId == lc['hcpId']) {
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
          Map<String, dynamic> args = {
          'hcpId': currentId,
          'fullName': hcpName
          };
          Navigator.of(context)
          .pushNamed(hcpMenu, arguments: args);
          },
          );
          }
          }
