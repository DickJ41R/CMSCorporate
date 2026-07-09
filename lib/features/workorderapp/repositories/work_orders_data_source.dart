import 'package:cms_web/features/shared/utils/app_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:cms_web/features/workorderapp/models/work_order_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkOrdersClassDataSource extends DataGridSource {
  /// Creates the order data source class with required details.
  ///

  List<WorkOrderClass> _workOrderClassInfo;
  int rowsPerPage;
  List<WorkOrderClass>workOrders;
  List<WorkOrderClass>paginatedWorkOrders;
  WorkOrdersClassDataSource( this._workOrderClassInfo,this.rowsPerPage,this.workOrders,this.paginatedWorkOrders) {
    //  debugPrint('line 11: ${this._clientClassInfo}');
//    debugPrint('line 14: $rowsPerPage $clients $paginatedClients');

    paginatedWorkOrders = workOrders.getRange(0,rowsPerPage).toList(growable: false);
    //_addCityState();
    buildPaginatedDataGridRows();
    // _buildDataRow();
  }

  // void _addCityState() {
  //   debugPrint('line 17 addcitystate');
  //   List<dynamic> ld =
  //       _clientClassInfo.map<dynamic>((e) => <dynamic>[e.clientId]).toList();
  //   debugPrint('line 21: $ld');
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
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;


  double fontSize = 18;
  String _fetchColumnName(String columnName) {
    switch (columnName) {
      case 'orderId':
        return 'Order ID';
      case 'statusId':
        return 'Sts';
      case 'clientName':
        return 'Client Name';
      case 'departmentName':
        return 'Department Name';
      case 'state':
        return 'Ste';
      case 'hcpName':
        return 'Employee';
      case 'shiftDate':
        return 'Date';
      case 'shiftDateTime':
        return 'Date & Time';
      case 'disciplineName':
        return 'Disc';
      case 'grossMargin':
        return 'Margin';
      default:
        return "Bad Column Name";
    }
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == _fetchColumnName('orderId')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              width: 80,
              height: 32,
              alignment: Alignment.center,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,

              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('statusId')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('clientName')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('departmentName')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('state')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('hcpName')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('shiftDate')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('shiftDateTime')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('disciplineName')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('grossMargin')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        })
            .toList());
  }



  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex  = startIndex + rowsPerPage;
    if (endIndex  > workOrders.length) {
      endIndex = workOrders.length;
    }

    debugPrint('line 191: $startIndex $endIndex $rowsPerPage ${workOrders.length}');
    if (startIndex < workOrders.length && endIndex <= workOrders.length) {

      paginatedWorkOrders =
          workOrders.getRange(startIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedWorkOrders = [];
    }

    return true;
  }
  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedWorkOrders.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'Order ID', value: dataGridRow.orderId),
        DataGridCell(columnName: 'Sts', value: dataGridRow.statusId),
        DataGridCell(columnName: 'Client Name', value: dataGridRow.clientName),
        DataGridCell(columnName: 'Department Name', value: dataGridRow.departmentName),
        DataGridCell(columnName: 'Ste', value: dataGridRow.state),
        DataGridCell(columnName: 'Employee', value: dataGridRow.hcpName),
        DataGridCell(columnName: 'Date', value: dataGridRow.shiftDate),
        DataGridCell(columnName: 'Date & Time', value: dataGridRow.shiftDateTime),
        DataGridCell(columnName: 'Disc', value: dataGridRow.disciplineName),
        DataGridCell(columnName: 'Margin', value: dataGridRow.grossMargin),

      ]);
    }).toList(growable: false);
  }

}
