import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cms_web/features/hcpapp/models/hcp_class.dart';

class HCPClassDataSource extends DataGridSource {
  /// Creates the order data source class with required details.
  ///
  List<HCPClass> _HCPClassInfo;
  int rowsPerPage;
  List<HCPClass>hcps;
  List<HCPClass>paginatedHcps;
  HCPClassDataSource(this._HCPClassInfo,this.rowsPerPage,this.hcps,this.paginatedHcps) {
    //  debugPrint('line 11: ${this._clientClassInfo}');
//    debugPrint('line 14: $rowsPerPage $clients $paginatedClients');
     debugPrint('line 21: $hcps');
    paginatedHcps = hcps.getRange(0,rowsPerPage).toList(growable: false);
    //_addCityState();
    debugPrint('line 24 $rowsPerPage $paginatedHcps');
    buildPaginatedDataGridRows();
    // _buildDataRow();
  }


  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;


  double fontSize = 18;
  String _fetchColumnName(String columnName) {
    switch (columnName) {
      case 'hcpId':
        return 'ID';
      case 'statusId':
        return 'Sts';
      case 'SSN':
        return "SSN";
      case 'fullName':
        return 'HCP Name';
      case 'branchName':
        return 'Branch Name';
      case 'genderCodeDescription':
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
        return "Bad Column Name";
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
    if (endIndex  > hcps.length) {
      endIndex = hcps.length;
    }

     if (startIndex < hcps.length && endIndex <= hcps.length) {
       debugPrint('line 181: $startIndex $endIndex $rowsPerPage ${hcps.length}');

       paginatedHcps = hcps.getRange(startIndex, endIndex).toList(growable: false);
      debugPrint('line 186 $paginatedHcps');
      buildPaginatedDataGridRows();
       notifyListeners();
    } else {
      paginatedHcps = [];
    }

    return true;
  }
  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedHcps.map<DataGridRow>((dataGridRow) {
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
