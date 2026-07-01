import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:cms_web/features/clientapp/repositories/clients_data_source.dart';
import 'package:cms_web/features/clientapp/models/client.dart';
import 'package:cms_web/features/clientapp/models/client_class.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';

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

class ClientStreamScreen extends StatefulWidget {
  final Map<String, String> args;
  ClientStreamScreen({super.key, required this.args});

  @override
  State<ClientStreamScreen> createState() => _ClientStreamScreenState();
}

class _ClientStreamScreenState extends State<ClientStreamScreen> {
  // dynamic _localRef;
  List<ClientClass> clientClasses = <ClientClass>[];
  late ClientClassDataSource clientClassDataSource;
  AuthService authServices = AuthService();
  ClientServices clientServices = ClientServices();
  UtilitiesServices util = UtilitiesServices();
  late String formatted;
  late double fontSize;
  late List<Map<String, dynamic>> listOfClientClassData;
  late List<ClientClass> clientClassData = [];
  List<ClientClass> _paginatedClients = [];
  List<ClientClass>_clients = [];
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  String? documentId;
  List<ClientClass> getClientData() {
    List<ClientClass> cli = clientClasses;
    return cli;
  }
  int? _rowsPerPage;
  final double _dataPagerHeight = 60.0;
  List<ClientClass> _paginateClients = [];
  // Add maxWidth constraint check

  Stream<QuerySnapshot>? _clientStream;
  Map<String, dynamic>? arguments;
  List<Map<String, dynamic>> listOfClients = [];
  List<Map<String, dynamic>>? clm;


  Future<List<Map<String, dynamic>>> _getAllClientData() async {
    debugPrint('line 70 _getallclientdata: $arguments ${clm!.length}');

    try {
      if (authServices.holdClm.length > 0) {
        debugPrint('line 74: ${authServices.holdClm.length}');
        clm = authServices.holdClm;
        _clients = authServices.clients;
        clientClassData = authServices.clientClassData;
        _rowsPerPage = authServices.rowsPerPage;
        debugPrint('line 73  ${clm!.length}');
        if (clm!.length > 0) {
          return clm!;
        }
      }
     _rowsPerPage = 15;
      authServices.rowsPerPage = _rowsPerPage!;
      clm = [];
      authServices.holdClm = [];
      authServices.clients = [];

      Query query = util.buildDynamicQuery(arguments!);
       clm = await clientServices.getQueryData(query);
       if (clm!.length < _rowsPerPage!) {
         _rowsPerPage = clm!.length;
       }
       debugPrint('line 80');
       for (int i=0; i < clm!.length; i++) {
         Map<String, dynamic>obj = clm![i];
         _clients.add(ClientClass.fromJson(obj));
       }
       authServices.clients = _clients;
       authServices.holdClm = clm!;

      // debugPrint('line 85: $clm');
      return clm!;
    } catch (e) {
      debugPrint('line 87: ${e.toString()}');
      throw Exception('line 124 Error getting client data');
    }
  }


  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 272: $arguments!');

    fontSize = 18;
    // clientClasses = getClientData();

    //  getDataFromDatabase();
//    debugPrint('line 250 ${clientClasses.length}');
//    clientClassDataSource =
//        ClientClassDataSource(clientClassCollection: clientClasses);
//    debugPrint('line 252: ${clientClassDataSource}');
  }

  double? screenWidth;
  double? screenHeight;
  double count = 0;

  double _getPageCount(int len, int rowsPerPage) {
    debugPrint('line 168: $len $rowsPerPage');
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
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    //screenHeight = MediaQuery.sizeOf(context).height;
    //screenWidth = MediaQuery.sizeOf(context).width;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double? h = MediaQuery
        .maybeOf(context)
        ?.textScaler
        .scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    clm = [];
    debugPrint('line 87: $screenHeight $screenWidth');
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Client From List Screen',
            style: TextStyle(
                backgroundColor: color1,
                fontSize:
                Theme
                    .of(context)
                    .textTheme
                    .headlineSmall!
                    .fontSize! / h,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () {
            authServices.holdClm = [];
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
          future: Future.wait([_getAllClientData()]),
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
                  child: Text('There are no clients to list.',
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
              //  debugPrint('line 292 ${data.length}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    width: screenWidth! - 10,
                    child: Text('There are no clients to list.',
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
                if (_rowsPerPage! > listH.length) {
                  _rowsPerPage = listH.length;
                }
                //   debugPrint('line 312: ${listH.length} ${listH[0]}');
                clientClassData.clear();
                listH.forEach((doc) {
                  //  debugPrint('line 307: ${doc.data()}');
                  clientClassData.add(ClientClass.fromJson(doc));
                });
                //   debugPrint('line 311: ${clientClassData[0].clientId}');
                clientClassDataSource = ClientClassDataSource(
                    clientClassData, _rowsPerPage!, _clients, _paginatedClients);
                authServices.clientClassData = clientClassData;
                return LayoutBuilder(builder: (context, constraint) {
                  return Column(children: [
                    SizedBox(
                        height: constraint.maxHeight - _dataPagerHeight,
                        width: constraint.maxWidth,
                        child: buildDataGrid(constraint)),
                     Container(
                        height: _dataPagerHeight,
                        child: SfDataPager(
                          delegate: clientClassDataSource,
                          pageCount: _getPageCount(_clients.length, _rowsPerPage!),
                          direction: Axis.horizontal,
                        ))
                  ]);
                });
              }
            }
          }
      ),
    );
  }
  Widget buildDataGrid(BoxConstraints constraint) {
                return SfDataGrid(
                  columnWidthMode: ColumnWidthMode.fill,
                  source: clientClassDataSource,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'clientId',
                        allowEditing: false,
                        allowFiltering: true,
                        allowSorting: true,
                        maximumWidth: 80,
                        width: 80,
                        label: Container(
                            width: 80,
                            height: 32,
                            padding: EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: Text('ID',
                                style: TextStyle(
                                  fontSize: fontSize,
                                )))),
                    GridColumn(
                        allowSorting: false,
                        allowFiltering: false,
                        columnName: 'statusId',
                        allowEditing: false,
                        maximumWidth: 30,
                        width: 30,
                        label: Container(
                            width: 30,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Sts',
                                style: TextStyle(
                                  fontSize: fontSize,
                                )))),
                    GridColumn(
                        allowFiltering: true,
                        columnName: 'clientName',
                        allowSorting: true,
                        width: 300,
                        maximumWidth: 300,
                        allowEditing: false,
                        label: Container(
                            width: 300,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Client Name',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis, fontSize: fontSize)))),
                    GridColumn(
                        columnName: 'branchName',
                        allowEditing: false,
                        allowFiltering: false,
                        allowSorting: false,
                        width: 180,
                        maximumWidth: 180,
                        label: Container(
                            width: 180,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Branch Name',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis, fontSize: fontSize)))),
                    GridColumn(
                        columnName: 'clientType',
                        allowEditing: false,
                        allowSorting: false,
                        allowFiltering: false,
                        width: 130,
                        maximumWidth: 130,
                        label: Container(
                            width: 130,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Type',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  overflow: TextOverflow.ellipsis,
                                )))),
                    GridColumn(
                        columnName: 'disciplinesServiced',
                        allowEditing: false,
                        allowSorting: false,
                        allowFiltering: false,
                        width: 80,
                        maximumWidth: 80,
                        label: Container(
                            width: 80,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Disc',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: fontSize,
                                )))),
                    GridColumn(
                        allowFiltering: false,
                        allowSorting: false,
                        columnName: 'city',
                        allowEditing: false,
                        width: 100,
                        maximumWidth: 100,
                        label: Container(
                            width: 100,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('City',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: fontSize,
                                )))),
                    GridColumn(
                        columnName: 'state',
                        allowEditing: false,
                        allowSorting: false,
                        allowFiltering: false,
                        width: 40,
                        maximumWidth: 40,
                        label: Container(
                            width: 40,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Ste',
                                style: TextStyle(
                                  fontSize: fontSize,
                                )))),
                    GridColumn(
                        columnName: 'balance',
                        allowEditing: false,
                        allowFiltering: false,
                        allowSorting: false,
                        width: 130,
                        maximumWidth: 130,
                        label: Container(
                            width: 130,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Balance',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: fontSize,
                                )))),
                    GridColumn(
                        columnName: 'openCredit',
                        allowEditing: false,
                        allowSorting: false,
                        allowFiltering: false,
                        width: 130,
                        maximumWidth: 130,
                        label: Container(
                            width: 130,
                            height: 32,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            alignment: Alignment.center,
                            child: Text('Credit',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  overflow: TextOverflow.ellipsis,
                                )))),
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
                        .indexWhere((cell) => cell.columnName == 'Client Name');
                    String clientName = '';
                    if (colIndex2 != -1) {
                      // Get and increment the current ID value.
                      clientName = cells[colIndex2].value;
                      debugPrint('line 358 $clientName');
                    }
                    for (int i = 0; i < listOfClients.length; i++) {
                      Map<String, dynamic> lc = listOfClients[i];
                      if (currentId == lc['clientId']) {
                        authServices.clientMap = lc;
                        break;
                      }
                    }
                    authServices.targetType = "Client";
                    // Map<String, dynamic>? smp =
                    //     await clientServices.getASingleClientUser(
                    //         authServices.clientMap!['clientId']);
                    // debugPrint('line 304: $smp');
                    // if (smp!.containsKey('clientId') == true) {
                    //   authServices.clientUserMap = smp;
                    // }
                    Map<String, dynamic> args = {
                      'clientId': currentId,
                      'clientName': clientName
                    };
                    Navigator.of(context)
                        .pushNamed(clientMenu, arguments: args);
                  },
                );
              }
}
