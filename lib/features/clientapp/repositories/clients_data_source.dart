import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cms_web/features/clientapp/models/client_class.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientClassDataSource extends DataGridSource {
  /// Creates the order data source class with required details.

  ClientClassDataSource(this._clientClassInfo) {
    //  print('line 11: ${this._clientClassInfo}');
    //_addCityState();
    _buildDataRow();
  }

  // void _addCityState() {
  //   print('line 17 addcitystate');
  //   List<dynamic> ld =
  //       _clientClassInfo.map<dynamic>((e) => <dynamic>[e.clientId]).toList();
  //   print('line 21: $ld');
  //   for (int i = 0; i < ld.length; i++) {
  //     List<int> li = ld[i];
  //     int cli = li[0];
  //     FirebaseFirestore.instance
  //         .collection('ClientAddress')
  //         .where('clientId', isEqualTo: cli)
  //         .where('addressType', isEqualTo: 'Physical')
  //         .get()
  //         .then((QuerySnapshot) {
  //       for (var docSnapshot in QuerySnapshot.docs) {
  //         var obj = docSnapshot.data();
  //       }
  //     });
  //   }
  // }

  List<DataGridRow> clients = [];
  List<ClientClass> _clientClassInfo;

  String _fetchColumnName(String columnName) {
    switch (columnName) {
      case 'clientId':
        return 'Client ID';
      case 'statusId':
        return 'Sts';
      case 'clientName':
        return 'Client Name';
      case 'branchName':
        return 'Branch Name';
      case 'clientType':
        return 'Type';
      case 'disciplinesServiced':
        return 'Disc';
      case 'City':
        return 'City';
      case 'state':
        return 'Ste';
      case 'balance':
        return 'Balance';
      case 'openCredit':
        return 'Credit';
      default:
        return columnName;
    }
  }

  void _buildDataRow() {
    clients = _clientClassInfo
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(
                columnName: _fetchColumnName('clientId'),
                value: e.clientId.length < 4
                    ? "   ".substring(0, 4 - e.clientId.length) + e.clientId
                    : e.clientId,
              ),
              DataGridCell(
                columnName: _fetchColumnName('statusId'),
                value: e.statusId,
              ),
              DataGridCell(
                columnName: _fetchColumnName('clientName'),
                value: e.clientName,
              ),
              DataGridCell(
                columnName: _fetchColumnName('branchName'),
                value: e.branchName,
              ),
              DataGridCell(
                columnName: _fetchColumnName('clientType'),
                value: e.clientType,
              ),
              DataGridCell(
                columnName: _fetchColumnName('disciplinesServiced'),
                value: e.disciplinesServiced,
              ),
              DataGridCell(
                columnName: _fetchColumnName('city'),
                value: e.city,
              ),
              DataGridCell(
                columnName: _fetchColumnName('state'),
                value: e.state,
              ),
              DataGridCell(
                columnName: _fetchColumnName('balance'),
                value: e.balance,
              ),
              DataGridCell(
                columnName: _fetchColumnName('openCredit'),
                value: e.openCredit,
              ),
            ]))
        .toList();
//    print('line 88: ${clients}');
  }

  @override
  List<DataGridRow> get rows => clients;

  @override
  DataGridRowAdapter buildRow(
    DataGridRow row,
  ) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  List<GridColumn> getColumns(double fontSize) {
    return <GridColumn>[
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
    ];
  }
}
//   Stream<QuerySnapshot> getStream() {
//     print('line 50 in getStream');
//     return FirebaseFirestore.instance
//         .collection('Client')
//         .orderBy('clientId', descending: false)
//         .snapshots();
//   }
//
//   Future<void> buildStream(AsyncSnapshot snapShot) async {
//     if (snapShot.hasError ||
//         snapShot.data == null ||
//         snapShot.data.docs.length == 0) {
//       return Future<void>.value();
//     }
//
//     await Future.forEach(snapShot.data.docs, (element) {
//       var obj = snapShot.data.docs();
//
//
//
//     updateDataGridDataSource();
//
//     return Future<void>.value();
//   }
//
//   void updateDataGridDataSource() {
//     notifyListeners();
//   }
//
//   List<DataGridRow> buildDataGridRows() {
//     List<DataGridRow> dgr =
//         clientClasses.map<DataGridRow>((ClientClass ClientClass) {
//       return DataGridRow(cells: <DataGridCell>[
//         DataGridCell(
//           columnName: _fetchColumnName('clientId'),
//           value: ClientClass.clientId,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('statusId'),
//           value: ClientClass.statusId,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('clientName'),
//           value: ClientClass.clientName,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('branchName'),
//           value: ClientClass.branchName,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('clientType'),
//           value: ClientClass.branchName,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('disciplinesServiced'),
//           value: ClientClass.disciplinesServiced,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('city'),
//           value: ClientClass.city,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('state'),
//           value: ClientClass.state,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('balance'),
//           value: ClientClass.balance,
//         ),
//         DataGridCell(
//           columnName: _fetchColumnName('openCredit'),
//           value: ClientClass.openCredit,
//         )
//       ]);
//     }).toList();
//     return dgr;
//   }
//
//   /// Provides the column name.
//   List<DataGridRow> dataGridRows = <DataGridRow>[];
//
// //@Overrides
//   @override
//   List<DataGridRow> get rows {
//     return dataGridRows;
//   }

// List<ClientClass> get classData {
//   return clientClasses;
// }
//
// Color getRowBackgroundColor(DataGridRow row) {
//   final String st = row.getCells()[1].value;
//   if (st == 'A') {
//     return Colors.greenAccent;
//   } else if (st == 'P') {
//     return Colors.yellow;
//   } else if (st == 'I') {
//     return Colors.white;
//   }
//   return Colors.transparent;
// }
//
// @override
// DataGridRowAdapter buildRow(DataGridRow row) {
//   final int rowIndex = dataGridRows.indexOf(row);
//   Color backgroundColor = getRowBackgroundColor(row);
//   return DataGridRowAdapter(
//     color: backgroundColor,
//     cells: <Widget>[
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerRight,
//         child: Text(
//           row.getCells()[0].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerRight,
//         child: Text(
//           row.getCells()[1].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(row.getCells()[2].value.toString()),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           row.getCells()[3].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           row.getCells()[4].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           row.getCells()[5].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           row.getCells()[6].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           row.getCells()[7].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           row.getCells()[8].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(8),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           row.getCells()[9].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     ],
//   );
// }
//
// /// Currency symbol
// @override
// Future<void> handleLoadMoreRows() async {
//   await Future<void>.delayed(const Duration(seconds: 5));
//   clientClasses = _fetchClientClasses(clientClasses, 20);
//   buildDataGridRows();
//   notifyListeners();
// }
//
// @override
// Future<void> handleRefresh() async {
//   await Future<void>.delayed(const Duration(seconds: 5));
//   clientClasses = _fetchClientClasses(clientClasses, 20);
//   buildDataGridRows();
//   notifyListeners();
// }

// @override
// Widget? buildTableSummaryCellWidget(
//     GridTableSummaryRow summaryRow,
//     GridSummaryColumn? summaryColumn,
//     RowColumnIndex rowColumnIndex,
//     String summaryValue,
//     ) {
//   Widget? widget;
//   Widget buildCell(String value, EdgeInsets padding, Alignment alignment) {
//     return Container(
//       padding: padding,
//       alignment: alignment,
//       child: Text(
//         value,
//         overflow: TextOverflow.ellipsis,
//         style: const TextStyle(fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   if (summaryRow.showSummaryInRow) {
//     widget = buildCell(
//       summaryValue,
//       const EdgeInsets.all(16.0),
//       Alignment.centerLeft,
//     );
//   } else if (summaryValue.isNotEmpty) {
//     if (summaryColumn!.columnName == 'freight') {
//       summaryValue = double.parse(summaryValue).toStringAsFixed(2);
//     }
//
//     summaryValue = 'Sum: ' +
//         NumberFormat.currency(
//           locale: 'en_US',
//           decimalDigits: 0,
//           symbol: r'$',
//         ).format(double.parse(summaryValue));
//
//     widget = buildCell(
//       summaryValue,
//       const EdgeInsets.all(8.0),
//       Alignment.centerRight,
//     );
//   }
//   return widget;
// }

// @override
// Widget? buildGroupCaptionCellWidget(
//     RowColumnIndex rowColumnIndex,
//     String summaryValue,
//     ) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//     child: Text(summaryValue),
//   );
// }

/// Provides the column name.

/// Update DataSource
//   void updateDataSource() {
//     notifyListeners();
//   }
//
//   List<ClientClass> _fetchClientClasses(
//       List<ClientClass> clientClasses, int count) {
//     final int startIndex = clientClasses.isNotEmpty ? clientClasses.length : 0,
//         endIndex = startIndex + count;
//     for (int i = startIndex; i < endIndex; i++) {
//       ClientClass wrk = clientClasses[i];
//       clientClasses.add(
//         ClientClass(
//             wrk.clientId,
//             wrk.statusId,
//             wrk.clientName,
//             wrk.branchName,
//             wrk.clientType,
//             wrk.disciplinesServiced,
//             wrk.city,
//             wrk.state,
//             wrk.balance,
//             wrk.openCredit),
//       );
//     }
//     return clientClasses;
//   }
//
//   List<GridColumn> getColumns(double fontSize) {
//     return <GridColumn>[
//       GridColumn(
//           columnName: 'clientId',
//           allowEditing: false,
//           allowFiltering: true,
//           allowSorting: true,
//           maximumWidth: 80,
//           width: 80,
//           label: Container(
//               width: 80,
//               height: 32,
//               //  padding: EdgeInsets.all(16.0),
//               alignment: Alignment.center,
//               child: Text('ID',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                   )))),
//       GridColumn(
//           allowSorting: false,
//           allowFiltering: false,
//           columnName: 'statusId',
//           allowEditing: false,
//           maximumWidth: 30,
//           width: 30,
//           label: Container(
//               width: 30,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Sts',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                   )))),
//       GridColumn(
//           allowFiltering: true,
//           columnName: 'clientName',
//           allowSorting: true,
//           width: 180,
//           maximumWidth: 180,
//           allowEditing: false,
//           label: Container(
//               width: 180,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Client Name',
//                   style: TextStyle(
//                       overflow: TextOverflow.ellipsis, fontSize: fontSize)))),
//       GridColumn(
//           columnName: 'branchName',
//           allowEditing: false,
//           allowFiltering: false,
//           allowSorting: false,
//           width: 180,
//           maximumWidth: 180,
//           label: Container(
//               width: 180,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Branch Name',
//                   style: TextStyle(
//                       overflow: TextOverflow.ellipsis, fontSize: fontSize)))),
//       GridColumn(
//           columnName: 'clientType',
//           allowEditing: false,
//           allowSorting: false,
//           allowFiltering: false,
//           width: 130,
//           maximumWidth: 130,
//           label: Container(
//               width: 130,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Type',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     overflow: TextOverflow.ellipsis,
//                   )))),
//       GridColumn(
//           columnName: 'disciplinesServiced',
//           allowEditing: false,
//           allowSorting: false,
//           allowFiltering: false,
//           width: 80,
//           maximumWidth: 80,
//           label: Container(
//               width: 80,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Disc',
//                   style: TextStyle(
//                     overflow: TextOverflow.ellipsis,
//                     fontSize: fontSize,
//                   )))),
//       GridColumn(
//           allowFiltering: false,
//           allowSorting: false,
//           columnName: 'city',
//           allowEditing: false,
//           width: 100,
//           maximumWidth: 100,
//           label: Container(
//               width: 100,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('City',
//                   style: TextStyle(
//                     overflow: TextOverflow.ellipsis,
//                     fontSize: fontSize,
//                   )))),
//       GridColumn(
//           columnName: 'state',
//           allowEditing: false,
//           allowSorting: false,
//           allowFiltering: false,
//           width: 40,
//           maximumWidth: 40,
//           label: Container(
//               width: 40,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Ste',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                   )))),
//       GridColumn(
//           columnName: 'balance',
//           allowEditing: false,
//           allowFiltering: false,
//           allowSorting: false,
//           width: 130,
//           maximumWidth: 130,
//           label: Container(
//               width: 130,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Balance',
//                   style: TextStyle(
//                     overflow: TextOverflow.ellipsis,
//                     fontSize: fontSize,
//                   )))),
//       GridColumn(
//           columnName: 'openCredit',
//           allowEditing: false,
//           allowSorting: false,
//           allowFiltering: false,
//           width: 130,
//           maximumWidth: 130,
//           label: Container(
//               width: 130,
//               height: 32,
//               padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
//               alignment: Alignment.center,
//               child: Text('Credit',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     overflow: TextOverflow.ellipsis,
//                   )))),
//     ];
//   }
//
//   static List<ClientClass> convertToClientClasses(List<dynamic> listD) {
//     try {
//       print('line 473: ${listD.length}');
//       for (int i = 0; i < listD.length; i++) {
//         Map<String, dynamic> ld = listD[i];
//         //  print('line 474: $ld');
//         if (ld['disciplinesServiced'] == null ||
//             ld['disciplinesServiced'] == "") {
//           ld['disciplinesServiced'] = 'UNK';
//         }
//         if (ld['clientType'] == null || ld['clientType'] == "") {
//           ld['clientType'] = 'UNK';
//         }
//         double db = double.parse(ld['openCredit']);
//         final formatCurrency = new NumberFormat.simpleCurrency();
//         String convertedDollar = formatCurrency.format(db);
//         db = double.parse(ld['balance']);
//         String convertedBalance = formatCurrency.format(db);
//         ClientClass wkc = ClientClass(
//             ld['clientId'],
//             ld['statusId'],
//             ld['clientName'],
//             ld['branchName'],
//             ld['clientType'],
//             ld['disciplinesServiced'],
//             ld['city'],
//             ld['state'],
//             convertedBalance,
//             convertedDollar);
//         print(
//             'line 499: ${wkc.clientId} ${wkc.statusId} ${wkc.clientName}${wkc.branchName} ${wkc.clientType} ${wkc.disciplinesServiced} ${wkc.city} ${wkc.state} ${wkc.balance} ${wkc.openCredit}');
//         clientClasses.add(wkc);
//       }
//       print('line 299: ${clientClasses.length}');
//       return clientClasses;
//     } catch (e) {
//       print('line 231: ${e.toString()}');
//       throw Exception('line 230 error on converting work orders');
//     }
//   }
// }
