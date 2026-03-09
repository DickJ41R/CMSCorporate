import 'package:cms_web/features/clientapp/services/client_services.dart';
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
import 'package:cms_web/features/clientapp/services/client_services.dart';

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
  final Map<String, dynamic> args;
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
  Query buildDynamicQuery(Map<String, dynamic> arg) {
    CollectionReference contentsRef =
        FirebaseFirestore.instance.collection(arg['searchCollection']);
    Query query = contentsRef;

    //check search criteria
    //all
    print('line 69');
    try {
      if (arg['searchCriteria'] == 'All') {
        return query;
      }
      //isequalto
      print('line 75');
      if (arg['searchCriteria'] == 'Is Equal To') {
        if (arg['searchField'].indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']);
          const q  = query(collection(.where(arg['searchField'], isEqualTo: value);
          return query;
        } else {
          query =
              query.where(arg['searchField'], isEqualTo: arg['searchValue']);
          return query;
        }
      }
      //less than
      print('line 88');
      if (arg['searchCriteria'] == 'Is Less Than') {
        if (arg['searchField'].indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']);
          query = query.where(arg['searchField'], isLessThan: value);
          return query;
        } else {
          query =
              query.where(arg['searchField'], isLessThan: arg['searchValue']);
          return query;
        }
      }
      //greater than
      print('line 101');
      if (arg['searchCriteria'] == 'Is Greater Than') {
        if (arg['searchField'].indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']);
          query = query.where(arg['searchField'], isGreaterThan: value);
          return query;
        } else {
          query = query.where(arg['searchField'],
              isGreaterThan: arg['searchValue']);
          return query;
        }
      }
      // Is greater Than or Equal To,
      print('line 115');
      if (arg['searchCriteria'] == 'Is Greater Than Or Equal To') {
        if (arg['searchField'].indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']);
          query =
              query.where(arg['searchField'], isGreaterThanOrEqualTo: value);
          return query;
        } else {
          query = query.where(arg['searchField'],
              isGreaterThanOrEqualTo: arg['searchValue']);
          return query;
        }
      }

      //Is less Than or Equal To",
      if (arg['searchCriteria'] == 'Is Less Than Or Equal To') {
        if (arg['searchField'].indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']);
          query = query.where(arg['searchField'], isLessThanOrEqualTo: value);
        } else {
          query = query.where(arg['searchField'],
              isLessThanOrEqualTo: arg['searchValue']);
        }
      }
      //Is Between (Include Edges)",
      if (arg['searchCriteria'] == 'Is Between (Include Edges)') {
        if (arg['searchField'].indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']);
          query =
              query.where(arg['searchField'], isGreaterThanOrEqualTo: value);
          query = query.where(arg['searchField'], isLessThanOrEqualTo: value);
        } else {
          query = query.where(arg['searchField'],
              isGreaterThanOrEqualTo: arg['searchValue']);
          query = query.where(arg['searchField'],
              isLessThanOrEqualTo: arg['searchValue']);
        }
      }
      // Is Between (Do not Include Edges)",
      if (arg['searchCriteria'] == 'Is Between (Do not Include Edges)') {
        if (arg['searchField'].indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']);
          query = query.where(arg['searchField'], isGreaterThan: value);
          query = query.where(arg['searchField'], isLessThan: value);
        } else {
          query = query.where(arg['searchField'],
              isGreaterThan: arg['searchValue']);
          query =
              query.where(arg['searchField'], isLessThan: arg['searchValue']);
        }
      }

      if (arg['searchCriteria'] == 'Is In (colon separated list)') {
        String sx = arg['searchCriteria'].replaceAll(',', ':');
        List<String> lsx = sx.split(':');
        if (arg['searchField'].indexOf('Id') != -1) {
          List<int> lvalues = [];
          for (int i = 0; i < lsx.length; i++) {
            String sv = lsx[i];
            lvalues.add(int.parse(sv));
          }
          query = query.where(arg['searchField'], whereIn: lvalues);
        } else {
          List<String> svalues = [];
          for (int i = 0; i < lsx.length; i++) {
            String sv = lsx[i];
            svalues.add(sv);
          }
          query = query.where(arg['searchField'], whereIn: svalues);
        }
      }
      return query;
    } catch (e) {
      print('line 186: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> _getAllClientData() async {
    print('line 178 in _getallclientdata: $arguments');
    List<Map<String, dynamic>>? clm;
    try {
      clm = [];
      Query query = buildDynamicQuery(arguments!);
      print('line 182: $query');
      query.get().then(
        ((querySnapshot) async {
          for (var docSnapShot in querySnapshot.docs) {
            print('line 198 in querysnapshot');
            Map<String, dynamic> obj =
                docSnapShot.data() as Map<String, dynamic>;
            obj['id'] = docSnapShot.id;
            listOfClients.add(obj);
            await FirebaseFirestore.instance
                .collection('ClientAddress')
                .where('clientId', isEqualTo: obj['clientId'])
                .where('addressType', isEqualTo: 'Physical')
                .get()
                .then((QuerySnapshot) async {
              for (var docSnapshot in QuerySnapshot.docs) {
                Map<String, dynamic> tobj = docSnapshot.data();
                //        print('line 100: $tobj');
                obj['city'] = tobj['city'];
                obj['state'] = tobj['state'];
                break;
              }
            });
            await FirebaseFirestore.instance
                .collection('ClientCredit')
                .where('clientId', isEqualTo: obj['clientId'])
                .get()
                .then((QuerySnapshot) async {
              for (var docSnapshot in QuerySnapshot.docs) {
                Map<String, dynamic> cobj = docSnapshot.data();
                //     print('line 113: $cobj');
                obj['balance'] = '0.00';
                obj['openCredit'] =
                    cobj['creditLimit'] == null ? 0.0 : cobj['creditLimit'];
                break;
              }
            });
            //   print('line 116: $obj');
            Map<String, dynamic> xbj = {
              'clientId': obj['clientId'].toString().length < 4
                  ? "    ".substring(0, 4 - obj['clientId'].toString().length) +
                      obj['clientId'].toString()
                  : obj['clientId'].toString(),
              'statusId': obj['statusId'] == null ? 'U' : obj['statusId'],
              'clientName':
                  obj['clientName'] == null ? 'Unknown' : obj['clientName'],
              'branchName':
                  obj['branchName'] == null ? 'Unknown' : obj['branchName'],
              'clientType':
                  obj['clientType'] == null ? 'Unknown' : obj['clientType'],
              'disciplinesServiced': obj['disciplinesServiced'] == null
                  ? "Unknown"
                  : obj['disciplinesServiced'].indexOf('CNA') == -1
                      ? "Unknown"
                      : obj['disciplinesServiced'].indexOf('LPN') == -1
                          ? "Unknown"
                          : obj['disciplinesServiced'].indexOf('RN') == -1
                              ? "Unknown"
                              : obj['disciplinesServiced'],
              'city': obj['city'] == null ? "Unknown" : obj['city'],
              'state': obj['state'] == null ? "Unk" : obj['state'],
              'balance':
                  obj['balance'] == null ? "0.00" : obj['balance'].toString(),
              'openCredit': obj['openCredit'] == null
                  ? "0.00"
                  : obj['openCredit'].toString()
            };
            //   print('line 138: $xbj');
            clm!.add(xbj);
          }
          ;
        }),
      );
      clm.sort((a, b) {
        int cmp = a['clientId'].compareTo(b['clientId']);
        if (cmp != 0) return cmp;
        return a['clientId'].compareTo(b['clientId']);
      });
      return clm;
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
                ClientClassData.clear();
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
                    Map<String, dynamic>? smp =
                        await clientServices.getASingleClientUser(
                            authServices.clientMap!['clientId']);
                    print('line 356: $smp');
                    if (smp!.containsKey('clientId') == true) {
                      authServices.clientUserMap = smp;
                    }
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
