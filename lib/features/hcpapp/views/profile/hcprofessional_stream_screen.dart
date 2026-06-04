import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:cms_web/features/hcpapp/repositories/hcps_data_source.dart';
import 'package:cms_web/features/hcpapp/models/hcp_professional.dart';
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
  List<HCPClass> hcpClasses = <HCPClass>[];
  late HCPClassDataSource hcpClassDataSource;
  AuthService authServices = AuthService();
  HCPServices hcpServices = HCPServices();
  late String formatted;
  late double fontSize;
  late List<Map<String, dynamic>> listOfHCPClassData;
  late List<HCPClass> HCPClassData = [];

  @override
  int get rowCount => listOfHCPs.length;
  List<HCPClass> paginatedDataSource = [];

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    int endIndex = startRowIndex + rowsPerPage;
    if (endIndex > listOfHCPs.length) {
      endIndex = listOfHCPs.length - 1;
    }

    paginatedDataSource = List.from(
        listOfHCPs.getRange(startRowIndex, endIndex).toList(growable: false));
    notifyListeners();
    return true;
  }

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

  List<Map<String, dynamic>> listOfHCPs = [];
  Future<List<Map<String, dynamic>>> _getAllHCPsData() async {
    try {
      List<Map<String, dynamic>>? hcpm =
          await hcpServices.getHCProfessionalsByArgument(arguments!);
      listOfHCPs = hcpm!;
      final rowsCount = listOfHCPs.length as double;
      pageCount = (rowsCount / _rowsPerPage).floorToDouble();
      print('line 91: $rowCount $pageCount $_rowsPerPage');
      if (pageCount == 0) {
        pageCount =1;
      }
      return listOfHCPs;
    } catch (e) {
      print('line 123: ${e.toString()}');
      throw Exception('line 124 Error getting client data');
    }
  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    print('line 272: $arguments!');
    fontSize = 18;
    // clientClasses = getClientData();

    //  getDataFromDatabase();
//    print('line 250 ${clientClasses.length}');
//    clientClassDataSource =
//        ClientClassDataSource(clientClassCollection: clientClasses);
//    print('line 252: ${clientClassDataSource}');
  }

  double pageCount = 0.0;
  double _rowsPerPage = 12;
  void _updatePageCount() {
    print(
        'line 116 updatepagecount: ${hcpClassDataSource.filterConditions.isNotEmpty}');

    final rowsCount = hcpClassDataSource.filterConditions.isNotEmpty
        ? hcpClassDataSource.effectiveRows.length
        : listOfHCPs.length;
    print('line 121: $rowsCount');
    if (rowsCount > 0) {
      pageCount = (rowsCount / _rowsPerPage).floorToDouble();
      //  pageCount = (rowsCount / _rowsPerPage).ceilToDouble();
    }
    print('line 122: $rowsCount $pageCount');
  }

  static const double dataPagerHeight = 60;
  double? screenWidth;
  double? screenHeight;
  double count = 0;
  // double getPageCount(int len, int ppr) {
  //   double dlen = len.toDouble();
  //   double dppr = ppr.toDouble();
  //   double ac = 0.0;
  //   if (len % ppr > 0) {
  //     ac = 1.0;
  //   }
  //   print('line $dlen $ppr $ac');
  //   double ppa = (dlen ~/ dppr) as double;
  //   ppa += ac;
  //   print('line 123: $ppa');
  //
  //   return ppa;
  // }
  TextEditingController fullNameController = TextEditingController();

  void _applyFilter() {
    print('line 151 applyfileter');
    final nameFilter = fullNameController.text.trim().toLowerCase();
    final List<HCPClass> filtered = hcpClasses.where((e) {
      bool nameMatch =
          nameFilter.isEmpty || e.fullName.toLowerCase().contains(nameFilter);
      return nameMatch;
    }).toList();
    setState(() {
      hcpClassDataSource = HCPClassDataSource(hcpClassCollection: filtered);
    });
  }

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
    print('line 87: $screenHeight $screenWidth');
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
            // print('line 99: ${shiftClasses[0].shiftCode} ${shiftClasses[0].shiftCount}');
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
            // print(
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
                          fontSize: Theme.of(context)
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
                          fontSize: Theme.of(context)
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
              print('line 292 ${data.length}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    width: screenWidth! - 10,
                    child: Text('There are no HCPs to list.',
                        style: TextStyle(
                            fontSize: Theme.of(context)
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
                //    print('line 312: ${listH.length} ${listH[0]}');
                HCPClassData.clear();
                listH.forEach((doc) {
                  //   print('line 307: ${doc}');
                  hcpClassData.add(HCPClass.fromJson(doc));
                });
                print('line 205: check');
                hcpClassDataSource =
                    HCPClassDataSource(hcpClassCollection: hcpClassData);
                return Column(
                  children: [
                    Container(
                      height: screenHeight! - (dataPagerHeight + 150),
                      width: screenWidth! - 10,
                      child: SfDataGrid(
                        allowFiltering: false,
                        onFilterChanged: (details) {
                          print('line 283');
                          _applyFilter();
                        },
                        rowsPerPage: _rowsPerPage.toInt(),
                        columnWidthMode: ColumnWidthMode.fill,
                        source: hcpClassDataSource,
                        allowEditing: false,
                        editingGestureType: EditingGestureType.doubleTap,
                        onQueryRowHeight: (details) {
                          // Set the row height as 70.0 to the column header row.
                          return details.rowIndex == 0 ? 30.0 : 50.0;
                        },
                        // rowHeight: 40,
                        selectionMode: SelectionMode.single,
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
                              allowSorting: false,
                              allowFiltering: false,
                              columnName: 'statusId',
                              allowEditing: false,
                              maximumWidth: 40,
                              width: 40,
                              label: Container(
                                  width: 40,
                                  height: 32,
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                  alignment: Alignment.center,
                                  child: Text('Sts',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )))),
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
                          // allowEditing: false,
                          // allowFiltering: true,
                          // allowSorting: false,
                          // width: 180,
                          // maximumWidth: 180,
                          // label: Container(
                          //     width: 180,
                          //     height: 32,
                          //     padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                          //     alignment: Alignment.center,
                          //     child: Text('Full Name',
                          //         style: TextStyle(
                          //             overflow: TextOverflow.ellipsis, fontSize: fontSize)))),
                          GridColumn(
                              columnName: 'branchName',
                              allowEditing: false,
                              allowSorting: false,
                              allowFiltering: false,
                              width: 180,
                              maximumWidth: 180,
                              label: Container(
                                  width: 180,
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                  alignment: Alignment.center,
                                  child: Text('Branch Name',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )))),
                          GridColumn(
                              columnName: 'gender',
                              allowEditing: false,
                              allowSorting: false,
                              allowFiltering: false,
                              width: 70,
                              maximumWidth: 70,
                              label: Container(
                                  width: 70,
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                  alignment: Alignment.center,
                                  child: Text('Gender',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )))),
                          GridColumn(
                              allowFiltering: true,
                              allowSorting: false,
                              columnName: 'disciplineName',
                              allowEditing: false,
                              width: 120,
                              maximumWidth: 120,
                              label: Container(
                                  width: 70,
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                  alignment: Alignment.center,
                                  child: Text('Disc',
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: fontSize,
                                      )))),
                          GridColumn(
                              columnName: 'workerType',
                              allowEditing: false,
                              allowFiltering: false,
                              allowSorting: false,
                              width: 100,
                              maximumWidth: 100,
                              label: Container(
                                  width: 100,
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                  alignment: Alignment.center,
                                  child: Text('Work Type',
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: fontSize,
                                      )))),
                          GridColumn(
                              columnName: 'credWillWarnDate',
                              allowEditing: false,
                              allowSorting: false,
                              allowFiltering: false,
                              width: 100,
                              maximumWidth: 100,
                              label: Container(
                                  width: 100,
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                  alignment: Alignment.center,
                                  child: Text('Warn Date',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )))),
                          GridColumn(
                              columnName: 'lastWorked',
                              allowEditing: false,
                              allowSorting: false,
                              allowFiltering: false,
                              width: 100,
                              maximumWidth: 100,
                              label: Container(
                                  width: 100,
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                  alignment: Alignment.center,
                                  child: Text('Work Last',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )))),
                        ],
                        onSelectionChanged: (addedRows, removedRows) async {
                          print(
                              'line 343: ${addedRows.length} ${addedRows[0].getCells()}');
                          final List<DataGridCell> cells =
                              addedRows[0].getCells();
                          // for (int q = 0; q < cells.length; q++) {
                          //   print('line 483: $q ${cells[q].columnName}');
                          // }
                          final int colIndex = cells
                              .indexWhere((cell) => cell.columnName == 'ID');
                          print('line 347: $colIndex');
                          int currentId = -1;
                          if (colIndex != -1) {
                            // Get and increment the current ID value.
                            currentId =
                                int.parse(cells[colIndex].value.toString());
                            print('line 351: $currentId');
                          }
                          final int colIndex2 = cells.indexWhere(
                              (cell) => cell.columnName == 'HCP Name');
                          String hcpName = '';
                          if (colIndex2 != -1) {
                            // Get and increment the current ID value.
                            hcpName = cells[colIndex2].value;
                            print('line 358 $currentId $hcpName');
                          }
                          for (int i = 0; i < listOfHCPs.length; i++) {
                            Map<String, dynamic> lc = listOfHCPs[i];
                            if (currentId == lc['hcpId']) {
                              authServices.hcpMap = lc;
                              break;
                            }
                          }
                          if (authServices.hcpMap == null) {
                            throw Exception(
                                'line 502 no match for selected hcp');
                          }
                          authServices.targetType = "HCProfessional";
                          Map<String, dynamic>? smp = await hcpServices
                              .getASingleHCPUser(authServices.hcpMap!['hcpId']);
                          print('line 356: $smp');
                          if (smp!.containsKey('hcpId') == true) {
                            authServices.hcpUserMap = smp;
                          }
                          Map<String, dynamic> args = {
                            'hcpId': currentId,
                            'hcpName': hcpName
                          };
                          Navigator.of(context)
                              .pushNamed(hcpMenu, arguments: args);
                        },
                      ),
                    ),
                    Container(
                        height: dataPagerHeight,
                        color: Colors.white,
                        child: SfDataPager(
                          visibleItemsCount: 30,
                          delegate: hcpClassDataSource,
                          direction: Axis.horizontal,
                          pageCount: pageCount,
                        )),
                  ],
                );
              }
            }
          }),
    );
  }

  void notifyListeners() {}
}
