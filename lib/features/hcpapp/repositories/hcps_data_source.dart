import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cms_web/features/hcpapp/models/hcp_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HCPClassDataSource extends DataGridSource {
  /// Creates the order data source class with required details.
  final int? hcpClassDataCount;
  final List<HCPClass>? hcpClassCollection;
  HCPClassDataSource({
    this.hcpClassDataCount,
    required this.hcpClassCollection,
  }) {
    hcpClasses = hcpClassCollection ??
        _fetchHCPClasses(hcpClasses, hcpClassDataCount ?? 100);
    dataGridRows = buildDataGridRows();
  }

  static List<HCPClass> hcpClasses = <HCPClass>[];

  String _fetchColumnName(String columnName) {
    switch (columnName) {
      case 'hcpId':
        return 'ID';
      case 'statusId':
        return 'Sts';
      case 'SSN':
        return 'SSN';
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

  List<DataGridRow> buildDataGridRows() {
    List<DataGridRow> dgr = hcpClasses.map<DataGridRow>((HCPClass hcpClass) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell(
          columnName: _fetchColumnName('hcpId'),
          value: hcpClass.hcpId,
        ),
        DataGridCell(
          columnName: _fetchColumnName('statusId'),
          value: hcpClass.statusId,
        ),
        DataGridCell(
          columnName: _fetchColumnName('SSN'),
          value: hcpClass.SSN,
        ),
        DataGridCell(
          columnName: _fetchColumnName('fullName'),
          value: hcpClass.fullName,
        ),
        DataGridCell(
          columnName: _fetchColumnName('branchName'),
          value: hcpClass.branchName,
        ),
        DataGridCell(
          columnName: _fetchColumnName('gender'),
          value: hcpClass.genderCodeDescription.toString().substring(0, 1),
        ),
        DataGridCell(
          columnName: _fetchColumnName('disciplineName'),
          value: hcpClass.disciplineName,
        ),
        DataGridCell(
          columnName: _fetchColumnName('workerType'),
          value: hcpClass.workerType,
        ),
        DataGridCell(
          columnName: _fetchColumnName('credsWillWarnDate'),
          value: hcpClass.credsWillWarnDate,
        ),
        DataGridCell(
          columnName: _fetchColumnName('lastWorked'),
          value: hcpClass.lastWorked,
        )
      ]);
    }).toList();
    return dgr;
  }

  /// Provides the column name.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

//@Overrides
  @override
  List<DataGridRow> get rows {
    return dataGridRows;
  }

  List<HCPClass> get classData {
    return hcpClasses;
  }

  Color getRowBackgroundColor(DataGridRow row) {
    final String st = row.getCells()[1].value;
    if (st == 'A') {
      return Colors.greenAccent;
    } else if (st == 'P') {
      return Colors.yellow;
    } else if (st == 'I') {
      return Colors.redAccent;
    }
    return Colors.transparent;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = getRowBackgroundColor(row);
    return DataGridRowAdapter(
      color: backgroundColor,
      cells: <Widget>[
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(row.getCells()[2].value.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[6].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[7].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[8].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            row.getCells()[9].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Currency symbol
  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    hcpClasses = _fetchHCPClasses(hcpClasses, 20);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    hcpClasses = _fetchHCPClasses(hcpClasses, 20);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildGroupCaptionCellWidget(
      RowColumnIndex rowColumnIndex,
      String summaryValue,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Text(summaryValue),
    );
  }

  /// Provides the column name.

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }

  List<HCPClass> _fetchHCPClasses(List<HCPClass> hcpClasses, int count) {
    final int startIndex = hcpClasses.isNotEmpty ? hcpClasses.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      HCPClass wrk = hcpClasses[i];
      hcpClasses.add(
        HCPClass(
            wrk.hcpId,
            wrk.statusId,
            wrk.SSN,
            wrk.fullName,
            wrk.branchName,
            wrk.disciplineName,
            wrk.genderCodeDescription,
            wrk.workerType,
            wrk.credsWillWarnDate,
            wrk.lastWorked),
      );
    }
    return hcpClasses;
  }

  static List<HCPClass> convertToHCPClasses(List<dynamic> listD) {
    try {
      for (int i = 0; i < listD.length; i++) {
        Map<String, dynamic> ld = listD[i];
        Timestamp ts = ld['credsWillWarnDate'];
        DateTime dte = ts.toDate();
        String creds = dte.toString();
        int idx = creds.indexOf(' ');
        creds = creds.substring(0, idx);
        List<String> tsss = creds.split('-');
        creds = tsss[1] + '-' + tsss[2] + '-' + tsss[0];
        //debugPrint('line 216 $ts $creds');
        //last worked
        Timestamp lw = ld['lastWorked'];
        DateTime dtw = lw.toDate();
        String lwk = dtw.toString();
        idx = lwk.indexOf(' ');
        lwk = lwk.substring(0, idx);
        List<String> slwk = lwk.split('-');
        lwk = slwk[1] + '-' + slwk[2] + '-' + slwk[0];
        // debugPrint('line 216 $lw $lwk');
        String? ssn;
        if (ld['SSN'] == null || ld['SSN'] == '') {
          ssn = "UNK";
        } else {
          ssn = ld['SSN'];
        }
        String? workerType;
        if (ld['workerType'] == null || ld['workerType'] == '') {
          workerType = "UNK";
        } else {
          workerType = ld['workerType'];
        }
        String? gender;
        if (ld['genderCodeDescription'] == null ||
            ld['genderCodeDescription'] == '') {
          gender = 'U';
        } else {
          gender = ld['genderCodeDescription'].toString().substring(0, 1);
        }
        HCPClass wkc = HCPClass(
            ld['hcpId'],
            ld['statusId'],
            ssn!,
            ld['fullName'],
            ld['branchName'],
            gender,
            ld['disciplineName'],
            workerType!,
            creds,
            lwk);
        hcpClasses.add(wkc);
      }
      debugPrint('line 299: ${hcpClasses.length}');
      return hcpClasses;
    } catch (e) {
      debugPrint('line 231: ${e.toString()}');
      throw Exception('line 230 error on converting hcp classes');
    }
  }
}
