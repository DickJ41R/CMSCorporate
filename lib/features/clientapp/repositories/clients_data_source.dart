import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cms_web/features/clientapp/models/client_class.dart';


class ClientClassDataSource extends DataGridSource {
  /// Creates the order data source class with required details.
  ///

  int rowsPerPage;
  List<ClientClass>clients;
  List<ClientClass>paginatedClients;
  ClientClassDataSource(this._clientClassInfo,this.rowsPerPage,this.clients,this.paginatedClients) {
    //  debugPrint('line 11: ${this._clientClassInfo}');
//    debugPrint('line 14: $rowsPerPage $clients $paginatedClients');

    paginatedClients = clients.getRange(0,rowsPerPage).toList(growable: false);
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

  List<ClientClass> _clientClassInfo;
  double fontSize = 18;
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
      case 'city':
        return 'City';
      case 'state':
        return 'Ste';
      case 'balance':
        return 'Balance';
      case 'openCredit':
        return 'Credit';
      default:
        return "Bad Column Name";
    }
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
        return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
            if (dataGridCell.columnName == _fetchColumnName('clientId')) {
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
            } else if (dataGridCell.columnName == _fetchColumnName('branchName')) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            } else if (dataGridCell.columnName == _fetchColumnName('clientType')) {
            return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            ),
            );
            } else if (dataGridCell.columnName == _fetchColumnName('disciplinesServiced')) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            } else if (dataGridCell.columnName == _fetchColumnName('city')) {
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
            } else if (dataGridCell.columnName == _fetchColumnName('balance')) {
            return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerRight,
            child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            ),
            );
            } else if (dataGridCell.columnName == _fetchColumnName('openCredit')) {
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
        DataGridCell(columnName: 'Client ID', value: dataGridRow.clientId),
        DataGridCell(columnName: 'Sts', value: dataGridRow.statusId),
        DataGridCell(columnName: 'Client Name', value: dataGridRow.clientName),
        DataGridCell(columnName: 'Branch Name', value: dataGridRow.branchName),
        DataGridCell(columnName: 'Type', value: dataGridRow.clientType),
        DataGridCell(columnName: 'Disc', value: dataGridRow.disciplinesServiced),
        DataGridCell(columnName: 'City', value: dataGridRow.city),
        DataGridCell(columnName: 'Ste', value: dataGridRow.state),
        DataGridCell(columnName: 'Balance', value: dataGridRow.balance),
        DataGridCell(columnName: 'Credit', value: dataGridRow.openCredit),

      ]);
    }).toList(growable: false);
  }

}
