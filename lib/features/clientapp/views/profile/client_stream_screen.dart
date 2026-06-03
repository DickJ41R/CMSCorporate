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
  late List<ClientClass> ClientClassData = [];
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  String? documentId;
  List<ClientClass> getClientData() {
    List<ClientClass> cli = clientClasses;
    return cli;
  }

  // Add maxWidth constraint check

  List<ClientClass> clientClassData = [];
  Stream<QuerySnapshot>? _clientStream;
  Map<String, dynamic>? arguments;
  List<Map<String, dynamic>> listOfClients = [];
  List<Map<String, dynamic>>? clm;
  Future<List<Map<String, dynamic>>> _getAllClientData() async {
    print('line 178 in _getallclientdata: $arguments');

    try {

      clm = [];

      Query query = util.buildDynamicQuery(arguments!);
       clm = await clientServices.getQueryData(query);
       print('line 72: $clm');
      return clm!;
    } catch (e) {
      print('line 262: ${e.toString()}');
      throw Exception('line 124 Error getting client data');
    }
  }

  // Future<String> getBranchDocumentId(int branchId) async {
  //   String? doc_id;
  //   await FirebaseFirestore.instance
  //       .collection('CMSBranch')
  //       .where('branchId', isEqualTo: branchId)
  //       .get()
  //       .then((querySnapshot) {
  //     for (var docSnapshot in querySnapshot.docs) {
  //       doc_id = docSnapshot.id;
  //       break;
  //     }
  //   });
  //   return Future.value(doc_id);
  // }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    print('line 272: $arguments!');

    // String? docId;
//     if (branchId == 0) {
//       _clientStream = FirebaseFirestore.instance
//           .collection('Client')
//           .orderBy('clientId', descending: false)
//           .snapshots();
//     } else {
//       print('line 278');
//       // docId = getBranchDocumentId(branchId!) as String;
//       _clientStream = FirebaseFirestore.instance
//           .collection('Client')
//           .where('branchId', isEqualTo: branchId)
//           .orderBy('clientId', descending: false)
// //          .where(FieldPath.documentId, isEqualTo: docId)
//           .snapshots();
//     }
    fontSize = 18;
    // clientClasses = getClientData();

    //  getDataFromDatabase();
//    print('line 250 ${clientClasses.length}');
//    clientClassDataSource =
//        ClientClassDataSource(clientClassCollection: clientClasses);
//    print('line 252: ${clientClassDataSource}');
  }

  double? screenWidth;
  double? screenHeight;
  double count = 0;
//   @override
//   int get rowCount = 0;
//
//   @override
//   Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
//       int startRowIndex, int rowsPerPage) async {
//     int endIndex = startRowIndex + rowsPerPage;
//     if (endIndex > orders.length) {
//       endIndex = orders.length - 1;
//     }
//
//     paginatedDataSource = List.from(
//         orders.getRange(startRowIndex, endIndex).toList(growable: false));
//     notifyListeners();
//     return true;
//   }
// }
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
    clm = [];
    print('line 87: $screenHeight $screenWidth');
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Client From List Screen',
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
          future: Future.wait([_getAllClientData()]),
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
                  child: Text('There are no clients to list.',
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
              //  print('line 292 ${data.length}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    width: screenWidth! - 10,
                    child: Text('There are no clients to list.',
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
                //   print('line 312: ${listH.length} ${listH[0]}');
                clientClassData.clear();
                listH.forEach((doc) {
                  //  print('line 307: ${doc.data()}');
                  clientClassData.add(ClientClass.fromJson(doc));
                });
                //   print('line 311: ${clientClassData[0].clientId}');
                clientClassDataSource = ClientClassDataSource(clientClassData);
                return SfDataGrid(
                  columnWidthMode: ColumnWidthMode.fill,
                  source: clientClassDataSource,
                  allowEditing: true,
                  editingGestureType: EditingGestureType.doubleTap,
                  onQueryRowHeight: (details) {
                    // Set the row height as 70.0 to the column header row.
                    return details.rowIndex == 0 ? 30.0 : 50.0;
                  },
                  // rowHeight: 40,
                  selectionMode: SelectionMode.single,
                  columns: clientClassDataSource.getColumns(fontSize),
                  onSelectionChanged: (addedRows, removedRows) async {
                    print(
                        'line 343: ${addedRows.length} ${addedRows[0].getCells()}');
                    final List<DataGridCell> cells = addedRows[0].getCells();
                    final int colIndex = cells
                        .indexWhere((cell) => cell.columnName == 'Client ID');
                    print('line 347: $colIndex');
                    int currentId = -1;
                    if (colIndex != -1) {
                      // Get and increment the current ID value.
                      currentId = int.parse(cells[colIndex].value);
                      print('line 351: $currentId');
                    }
                    final int colIndex2 = cells
                        .indexWhere((cell) => cell.columnName == 'Client Name');
                    String clientName = '';
                    if (colIndex2 != -1) {
                      // Get and increment the current ID value.
                      clientName = cells[colIndex2].value;
                      print('line 358 $clientName');
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
                    // print('line 304: $smp');
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
          }),
    );
  }
}
