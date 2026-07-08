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

class WorkOrderClassDataSource extends DataGridSource {
  /// Creates the order data source class with required details.
  final int? workOrderClassDataCount;
  final List<WorkOrderClass>? workOrderClassCollection;
  WorkOrderClassDataSource({
    this.workOrderClassDataCount,
    this.workOrderClassCollection,
  }) {
    workOrderClasses = workOrderClassCollection ??
        _fetchWorkOrderClasses(
            workOrderClasses, workOrderClassDataCount ?? 100);
    dataGridRows = buildDataGridRows();
  }

  static List<WorkOrderClass> workOrderClasses = <WorkOrderClass>[];

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
        return 'Shift & Time';
      case 'disciplineName':
        return 'Disc';
      case 'grossMargin':
        return 'Margin';
      default:
        return columnName;
    }
  }

  List<DataGridRow> buildDataGridRows() {
    List<DataGridRow> dgr =
        workOrderClasses.map<DataGridRow>((WorkOrderClass workOrderClass) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell(
          columnName: _fetchColumnName('orderId'),
          value: workOrderClass.orderId,
        ),
        DataGridCell(
          columnName: _fetchColumnName('statusId'),
          value: workOrderClass.statusId,
        ),
        DataGridCell(
          columnName: _fetchColumnName('clientName'),
          value: workOrderClass.clientName,
        ),
        DataGridCell(
          columnName: _fetchColumnName('departmentName'),
          value: workOrderClass.departmentName,
        ),
        DataGridCell(
          columnName: _fetchColumnName('state'),
          value: workOrderClass.state,
        ),
        DataGridCell(
          columnName: _fetchColumnName('hcpName'),
          value: workOrderClass.hcpName,
        ),
        DataGridCell(
          columnName: _fetchColumnName('shiftDate'),
          value: workOrderClass.shiftDate,
        ),
        DataGridCell(
          columnName: _fetchColumnName('shiftDateTime'),
          value: workOrderClass.shiftDateTime,
        ),
        DataGridCell(
          columnName: _fetchColumnName('disciplineName'),
          value: workOrderClass.disciplineName,
        ),
        DataGridCell(
          columnName: _fetchColumnName('grossMargin'),
          value: workOrderClass.grossMargin,
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

  List<WorkOrderClass> get classData {
    return workOrderClasses;
  }

  Color getRowBackgroundColor(DataGridRow row) {
    final String st = row.getCells()[1].value;
    if (st == 'S') {
      return Colors.blueAccent;
    } else if (st == 'O') {
      return Colors.yellow;
    } else if (st == 'C' || st == 'E' || st == '*') {
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
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(row.getCells()[2].value.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[6].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[7].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[8].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
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
    workOrderClasses = _fetchWorkOrderClasses(workOrderClasses, 20);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    workOrderClasses = _fetchWorkOrderClasses(workOrderClasses, 20);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    Widget? widget;
    Widget buildCell(String value, EdgeInsets padding, Alignment alignment) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    if (summaryRow.showSummaryInRow) {
      widget = buildCell(
        summaryValue,
        const EdgeInsets.all(16.0),
        Alignment.centerLeft,
      );
    } else if (summaryValue.isNotEmpty) {
      if (summaryColumn!.columnName == 'freight') {
        summaryValue = double.parse(summaryValue).toStringAsFixed(2);
      }

      summaryValue = 'Sum: ' +
          NumberFormat.currency(
            locale: 'en_US',
            decimalDigits: 0,
            symbol: r'$',
          ).format(double.parse(summaryValue));

      widget = buildCell(
        summaryValue,
        const EdgeInsets.all(8.0),
        Alignment.centerRight,
      );
    }
    return widget;
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

  List<WorkOrderClass> _fetchWorkOrderClasses(
      List<WorkOrderClass> workOrderClasses, int count) {
    final int startIndex =
            workOrderClasses.isNotEmpty ? workOrderClasses.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      WorkOrderClass wrk = workOrderClasses[i];
      workOrderClasses.add(
        WorkOrderClass(
            wrk.orderId,
            wrk.statusId,
            wrk.clientName,
            wrk.departmentName,
            wrk.state,
            wrk.hcpName,
            wrk.shiftDate,
            wrk.shiftDateTime,
            wrk.disciplineName,
            wrk.grossMargin),
      );
    }
    return workOrderClasses;
  }

  List<GridColumn> getColumns(double fontSize) {
    return <GridColumn>[
      GridColumn(
          columnName: 'orderId',
          allowEditing: false,
          allowFiltering: true,
          allowSorting: false,
          maximumWidth: 70,
          width: 70,
          label: Container(
              width: 70,
              height: 32,
              //  padding: EdgeInsets.all(16.0),
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
          allowFiltering: true,
          columnName: 'clientName',
          allowSorting: false,
          width: 180,
          maximumWidth: 180,
          allowEditing: false,
          label: Container(
              width: 180,
              height: 32,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('Client Name',
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: fontSize)))),
      GridColumn(
          columnName: 'departmentName',
          allowEditing: true,
          allowFiltering: false,
          allowSorting: false,
          width: 180,
          maximumWidth: 180,
          label: Container(
              width: 180,
              height: 32,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('Department Name',
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: fontSize)))),
      GridColumn(
          columnName: 'state',
          allowEditing: false,
          allowSorting: false,
          allowFiltering: false,
          width: 60,
          maximumWidth: 60,
          label: Container(
              width: 60,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('State',
                  style: TextStyle(
                    fontSize: fontSize,
                  )))),
      GridColumn(
          allowFiltering: true,
          allowSorting: false,
          columnName: 'hcpName',
          allowEditing: false,
          width: 120,
          maximumWidth: 120,
          label: Container(
              width: 120,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('HCP Name',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: fontSize,
                  )))),
      GridColumn(
          columnName: 'shiftDate',
          allowEditing: false,
          allowSorting: true,
          allowFiltering: false,
          width: 120,
          maximumWidth: 120,
          label: Container(
              width: 120,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('Shift Date',
                  style: TextStyle(
                    fontSize: fontSize,
                  )))),
      GridColumn(
          columnName: 'shiftDateTime',
          allowEditing: false,
          allowFiltering: false,
          allowSorting: true,
          width: 150,
          maximumWidth: 150,
          label: Container(
              width: 150,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('Shift Time',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: fontSize,
                  )))),
      GridColumn(
          columnName: 'disciplineName',
          allowEditing: false,
          allowSorting: true,
          allowFiltering: false,
          width: 80,
          maximumWidth: 80,
          label: Container(
              width: 80,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('Disc',
                  style: TextStyle(
                    fontSize: fontSize,
                  )))),
      GridColumn(
          columnName: 'grossMargin',
          allowEditing: false,
          allowSorting: false,
          allowFiltering: false,
          width: 120,
          maximumWidth: 120,
          label: Container(
              width: 120,
              padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
              alignment: Alignment.center,
              child: Text('Margin',
                  style: TextStyle(
                    fontSize: fontSize,
                  )))),
    ];
  }

  static List<WorkOrderClass> convertToWorkOrderClasses(List<dynamic> listD) {
    try {
      for (int i = 0; i < listD.length; i++) {
        Map<String, dynamic> ld = listD[i];
        Timestamp ts = ld['shiftDate'];
        DateTime dte = ts.toDate();
        String tss = dte.toString();
        int idx = tss.indexOf(' ');
        tss = tss.substring(0, idx);
        List<String> tsss = tss.split('-');
        tss = tsss[1] + '-' + tsss[2] + '-' + tsss[0];
        debugPrint('line 216 $ts $tss');
        //shiftdatetime
        String srt = ld['startTime'].substring(0, ld['startTime'].length - 1);
        srt = srt.replaceAll(' ', '');
        String ent = ld['endTime'].substring(0, ld['endTime'].length - 1);
        ent = ent.replaceAll(' ', '');
        String sdt = ld['shiftCode'] + '[H]' + srt + '-' + ent;
        if (ld['meals'] > 0) {
          sdt += '(' + ld['meals'].toString() + ')';
        }
        WorkOrderClass wkc = WorkOrderClass(
            ld['orderId'],
            ld['statusId'],
            ld['clientName'],
            ld['departmentName'],
            ld['state'],
            ld['hcpName'],
            tss,
            sdt,
            ld['disciplineName'],
            ld['grossMargin'].toString());
        workOrderClasses.add(wkc);
      }
      debugPrint('line 299: ${workOrderClasses.length}');
      return workOrderClasses;
    } catch (e) {
      debugPrint('line 231: ${e.toString()}');
      throw Exception('line 230 error on converting work orders');
    }
  }
}
