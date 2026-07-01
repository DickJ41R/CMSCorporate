import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cms_web/features/hcpapp/models/hcp_class.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HCPClassDataSource extends DataGridSource {
  /// Creates the order data source class with required details.
  ///

  int rowsPerPage;
  List<HCPClass>clients;
  List<HCPClass>paginatedClients;
  HCPClassDataSource(this._clientClassInfo,this.rowsPerPage,this.clients,this.paginatedClients) {
    //  debugPrint('line 11: ${this._clientClassInfo}');
//    debugPrint('line 14: $rowsPerPage $clients $paginatedClients');
    paginatedClients = clients.getRange(0,rowsPerPage).toList(growable: false);
    //_addCityState();
    buildPaginatedDataGridRows();
    // _buildDataRow();
  }


  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  List<HCPClass> _clientClassInfo;
  double fontSize = 18;
  String _fetchColumnName(String columnName) {
    switch (columnName) {
      case 'hcpId':
        return 'HCP ID';
      case 'statusId':
        return 'Sts';
      case 'SSN':
        return "SSN";
      case 'fullName':
        return 'HCP Name';
      case 'branchName':
        return 'Branch Name';
      case 'gender':
        return 'Gender';
      case 'disciplineName':
        return 'Disc';
      case 'workerType':
        return 'Worker Type';
      case 'credsWillWarnDate':
        return 'Warn Date';
      case 'lastWorked':
        return 'Worked';
      default:
        return columnName;
    }
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == _fetchColumnName('hcpId')) {
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
          } else if (dataGridCell.columnName == _fetchColumnName('SSN')) {
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
          } else if (dataGridCell.columnName == _fetchColumnName('fullName')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('branchName')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('genderCodeDescription')) {
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
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('workerType')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('credsWillWarnDate')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (dataGridCell.columnName == _fetchColumnName('lastWorked')) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
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
    if (endIndex  > clients.length) {
      endIndex = clients.length;
    }

    debugPrint('line 191: $startIndex $endIndex $rowsPerPage ${clients.length}');
    if (startIndex < clients.length && endIndex <= clients.length) {

      paginatedClients =
          clients.getRange(startIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedClients = [];
    }

    return true;
  }
  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedClients.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'ID', value: dataGridRow.hcpId),
        DataGridCell(columnName: 'Sts', value: dataGridRow.statusId),
        DataGridCell(columnName: 'SSN', value: dataGridRow.SSN),
        DataGridCell(columnName: 'HCP Name', value: dataGridRow.fullName),
        DataGridCell(columnName: 'Branch Name', value: dataGridRow.branchName),
        DataGridCell(columnName: 'Gender', value: dataGridRow.genderCodeDescription),
        DataGridCell(columnName: 'Disc', value: dataGridRow.disciplineName),
        DataGridCell(columnName: 'Worker Type', value: dataGridRow.workerType),
        DataGridCell(columnName: 'Will Warn', value: dataGridRow.credsWillWarnDate),
        DataGridCell(columnName: 'Worked', value: dataGridRow.lastWorked),

      ]);
    }).toList(growable: false);
  }

}
