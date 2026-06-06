import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';

class ShiftClass {
  final String shiftCode;
  final String startTime;
  final String endTime;

  final int shiftCount;
  // final String payRate;
  ShiftClass(this.shiftCode, this.startTime, this.endTime, this.shiftCount);

  ShiftClass.fromJson(Map<String, dynamic> json)
      : shiftCode = json['shiftCode'] as String,
        startTime = json['startTime'] as String,
        endTime = json['endTime'] as String,
        shiftCount = json['shiftCount'] == null ? 0 : json['shiftCount'];
//        payRate = json['payRate'] as String;,

  Map<String, dynamic> toJson() => {
        'shiftCode': shiftCode,
        'startTime': startTime,
        'endTime': endTime,
        'shiftCount': shiftCount
        //      'payRate': payRate,
      };
  ShiftClass copyWith(
      {String? shiftCode,
      String? startTime,
      String? endTime,
      int? shiftCount}) {
    return ShiftClass(shiftCode ?? this.shiftCode, startTime ?? this.startTime,
        endTime ?? this.endTime, shiftCount ?? this.shiftCount);
  }
}

class ProcessShiftDataGrid extends StatefulWidget {
  final BuildContext ctx;
  final List<dynamic> listOfHolidays;
  final DateTime dateTime;
  final String discipline;
  final List<Map<String, dynamic>> listOfData;
  const ProcessShiftDataGrid({
    super.key,
    required this.ctx,
    required this.listOfHolidays,
    required this.dateTime,
    required this.discipline,
    required this.listOfData,
  });

  @override
  State<ProcessShiftDataGrid> createState() => _ProcessShiftDataGridState();
}

//enum selectionMode {none,single,multiple,singleDeselect}
class _ProcessShiftDataGridState extends State<ProcessShiftDataGrid> {
  late List<dynamic> listOfHolidays;
  late DateTime dateTime;
  late String discipline;
  late String formatted;
  late BuildContext ctx;
  late List<Map<String, dynamic>> listOfShiftData;
  List<ShiftClass> shiftClasses = <ShiftClass>[];
  late ShiftClassDataSource shiftClassDataSource;
  dynamic currentSelection = SelectionMode.single;
  Color disabledTextColor = Colors.white;
  Color disabledColor = Color.fromARGB(255, 19, 125, 103);
  bool flagPublishedButtonDisabled = false;
  double smallFontSize = 14;
  double smallerFontSize = 12;
  UtilitiesServices utilities = UtilitiesServices();
  //late ShiftClassDataSource _shiftClassDataSource;

  DataGridController _dataGridController = DataGridController();
  bool _dateIsAHoliday(DateTime date) {
    debugPrint('line 80 data is a holiday: ${listOfHolidays.length}');
    try {
      bool isHoliday = false;
      for (int i = 0; i < listOfHolidays.length; i++) {
        Map<String, dynamic> hl = listOfHolidays[i];
        String sdt = hl['startDate'];

        if (sdt.indexOf('\/') != -1) {
          sdt = sdt.replaceAll('\/', '\-');
        }
        List<String> lsdt = sdt.split('-');
        String dte = lsdt[2] + '-' + lsdt[0] + '-' + lsdt[1];
        debugPrint('line 92: $dte');
        DateTime ndt = DateTime.parse(dte);
        debugPrint('line 94: ${date.year} ${date.month} ${date.day}');
        debugPrint('line 95: ${ndt.year} ${ndt.month} ${ndt.day}');
        double duration = double.parse(hl['duration'].toString());
        Map<String, dynamic> shm = utilities.getHoursMinutes(hl['startTime']);
        ndt = ndt.subtract(Duration(
            hours: ndt.hour,
            minutes: ndt.minute,
            seconds: ndt.second,
            microseconds: ndt.microsecond,
            milliseconds: ndt.millisecond));
        DateTime endt = ndt;
        debugPrint(
            'line 106: ${date.millisecondsSinceEpoch} ${ndt.millisecondsSinceEpoch} ${endt.millisecondsSinceEpoch}${shm}');
        endt = endt.add(Duration(hours: shm['hours'], minutes: shm['minutes']));
        if (date.millisecondsSinceEpoch >= ndt.millisecondsSinceEpoch &&
            date.millisecondsSinceEpoch < endt.millisecondsSinceEpoch) {
          isHoliday = true;
          break;
        }
      }
      return isHoliday;
    } catch (e) {
      debugPrint('line 105 error: ${e.toString()}');
      throw Exception('line 106 error date is a holiday: ${e.toString()}');
    }
  }

  bool isDateAHoliday = false;
  bool isDateAWeekEnd = false;

  @override
  void initState() {
    super.initState();
    listOfHolidays = widget.listOfHolidays;
    dateTime = widget.dateTime;
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    formatted = formatter.format(dateTime);
    debugPrint('line 115 just before call to date is a holiday');
    isDateAHoliday = _dateIsAHoliday(dateTime);
    isDateAWeekEnd = false;
    if (dateTime.weekday == 6 || dateTime.weekday == 7) {
      isDateAWeekEnd = true;
    }
    ctx = widget.ctx;
    // h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    // if (h! < 1.0) {
    //   h = 1.0;
    // }
    // largeFontSize /= h!;
    // fontSize /= h!;
    double fontS = 14;
    double? hh = MediaQuery.maybeOf(ctx)?.textScaler.scale(1.0);
    if (hh! < 1.0) {
      hh = 1.0;
    }
    fontS /= hh;
    discipline = widget.discipline;
    listOfShiftData = widget.listOfData;
    debugPrint('line 123: $listOfHolidays, $dateTime, $discipline');
    debugPrint('line 124: $isDateAHoliday, $isDateAWeekEnd');

    debugPrint('line 126: ${fontSize} ${listOfShiftData}');
    shiftClasses = getShiftClassData(listOfShiftData);
    shiftClassDataSource =
        ShiftClassDataSource(shiftClassData: shiftClasses, fontS: fontS);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // for (int i=0; i < rows.length; i++) {
    //   RowWidgetModel row = rows[i];
    //
    // }

    super.dispose();
  }

  List<ShiftClass> getShiftClassData(List<Map<String, dynamic>> shiftData) {
    List<ShiftClass> sft = [];
    for (int i = 0; i < shiftData.length; i++) {
      Map<String, dynamic> obj = shiftData[i];
      ShiftClass shift = ShiftClass.fromJson(obj);
      sft.add(shift);
    }
    return sft;
  }

  List<GridColumn> columnList = [];
  List<GridColumn> getColumnList() {
    columnList = [
      GridColumn(
          columnName: "shiftCode",
          label: Container(
              //padding: EdgeInsets.all(3.0),
              alignment: Alignment.center,
              child: Text('Shift',
                  style: TextStyle(
                      fontSize: largeFontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
          columnName: "startTime",
          label: Container(
              //   padding: EdgeInsets.all(3.0),
              alignment: Alignment.center,
              child: Text('Start',
                  style: TextStyle(
                      fontSize: largeFontSize,
                      color: isDateAWeekEnd == true
                          ? Colors.blue
                          : isDateAHoliday == true
                              ? Colors.red
                              : Colors.black,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
          columnName: "endTime",
          label: Container(
              // padding: EdgeInsets.all(3.0),
              alignment: Alignment.center,
              child: Text('End',
                  style: TextStyle(
                      fontSize: largeFontSize,
                      color: isDateAWeekEnd == true
                          ? Colors.blue
                          : isDateAHoliday == true
                              ? Colors.red
                              : Colors.black,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
        allowEditing: true,
        columnName: "shiftCount",
        label: Container(
          // padding: EdgeInsets.all(3.0),
          alignment: Alignment.centerLeft,
          child: Text('Count',
              style: TextStyle(
                  fontSize: largeFontSize,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
        ),
      )
    ];
    return columnList;
  }

  bool showCheckboxHeader = false;

  Color color4 = Colors.black87;
  Color color5 = Colors.red;
  double tableHeight = 330;
  double count = 0;
  int? selectedIndex;
  Map<String, List<DataGridRow>> selectedRowsCollection = {};
  //final CustomSelectionManager _customSelectionManager = CustomSelectionManager();
  List<DataGridRow> selectedList = <DataGridRow>[];

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;
  double largeFontSize = 18;
  double? h;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 18;
    fontSize /= h!;
    largeFontSize /= h!;
    // double smallFontSize = 14;
    smallFontSize /= h!;
    debugPrint('line 296: $h! $fontSize, $listOfHolidays, $dateTime, $discipline');
    tableHeight = (listOfShiftData.length + 1) * 55;
    double scw = screenWidth! / 2;
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Shift Data Table",
            style: TextStyle(
                fontSize:
                    Theme.of(context).textTheme.headlineLarge!.fontSize! / h!,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        automaticallyImplyLeading: false,
        leading: null,
        // leading: GestureDetector(
        //   child: IconButton(
        //     icon: const Icon(Icons.arrow_back,
        //         size: 30),
        //     onPressed: () {
        //       // shiftClasses = shiftClassDataSource.returnShiftClasses();
        //       // debugPrint('line 99: ${shiftClasses[0].shiftCode} ${shiftClasses[0].shiftCount}');
        //       Navigator.of(widget.ctx).pop(null);
        //     },
        //   ),
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 350),
                child: Container(
                  height: tableHeight,
                  width: screenWidth! / 2,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(selectionColor: Colors.red),
                    child: SfDataGrid(
                      controller: _dataGridController,
                      allowEditing: true,
                      onQueryRowHeight: (details) {
                        // Set the row height as 70.0 to the column header row.
                        return details.rowIndex == 0 ? 70.0 : 49.0;
                      },
                      columns: getColumnList(),
                      navigationMode: GridNavigationMode.cell,
                      gridLinesVisibility: GridLinesVisibility.horizontal,
                      source: shiftClassDataSource,
                      selectionMode: SelectionMode.single,
                      onSelectionChanged: (addedRows, removedRows) {
                        // Add newly selected rows to the flag variable.
                        if (addedRows.isNotEmpty) {
                          selectedList.addAll(addedRows);
                        }

                        // Remove deselected rows from the flag variable.
                        if (removedRows.isNotEmpty) {
                          selectedList
                              .removeWhere((row) => removedRows.contains(row));
                        }
                      },
                      showCheckboxColumn: false,
                      checkboxColumnSettings: DataGridCheckboxColumnSettings(
                          showCheckboxOnHeader: false),

                      // onRowSelectBuilder: ( (List<RowWidgetModel<dynamic>>? listR) {
                      //   debugPrint('line 281 ${listR!.length}');
                      //   if (listR!.length > 0) {
                      //     debugPrint('line 282: ${listR[0].others} ${listR[0]
                      //         .isSelected}');
                      //   }
                      // }
                      // )
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    // this is the one you are looking for..........
                    //  onTap: () => setState(() => count++),
                    onPressed: () {
                      if (_dataGridController.selectedRow != null) {
                        final DataGridRow selectedRow =
                            _dataGridController.selectedRow!;
                        final int rowIndex = shiftClassDataSource
                            ._shiftClassData
                            .indexOf(selectedRow);

                        if (rowIndex >= 0) {
                          final List<DataGridCell> cells = shiftClassDataSource
                              ._shiftClassData[rowIndex]
                              .getCells();

                          // Find the index of the 'id' column in the row.
                          final int colIndex = cells.indexWhere(
                              (cell) => cell.columnName == 'shiftCount');
                          if (colIndex != -1) {
                            // Get and increment the current ID value.
                            int currentId = cells[colIndex].value;

                            currentId++;
                            ShiftClass sf = shiftClasses[rowIndex];
                            sf = sf.copyWith(shiftCount: currentId);
                            shiftClasses[rowIndex] = sf;
                            shiftClassDataSource._shiftClassData[rowIndex]
                                    .getCells()[colIndex] =
                                DataGridCell<int>(
                                    columnName: 'shiftCount', value: currentId);
                            // Clear the flag variable and add the updated row to maintain selection.
                            selectedList.clear();
                            selectedList.add(
                                shiftClassDataSource._shiftClassData[rowIndex]);
                            shiftClassDataSource.updateDataGridSource(
                                rowColumnIndex:
                                    RowColumnIndex(rowIndex, colIndex));
                            _dataGridController.selectedRow = selectedList[0];
                          }
                        }
                      }
                      debugPrint('line 405: ');
                    },

                    child: Container(
                        //width: 50.0,
                        //height: 50.0,
                        // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
                        decoration: BoxDecoration(
                          color: color1,
                          border: Border.all(color: Colors.black87, width: 3),
                          shape: BoxShape.circle,
                        ),
                        //child: Text(count.toString(), style: new TextStyle(color: Colors.white, fontSize: smallFontSize),// You can add a Icon instead of text also, like below.
                        child: new Icon(Icons.add,
                            size: 28.0, color: Colors.black38)),
                  ),
                  SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      if (_dataGridController.selectedRow != null) {
                        final DataGridRow selectedRow =
                            _dataGridController.selectedRow!;
                        final int rowIndex = shiftClassDataSource
                            ._shiftClassData
                            .indexOf(selectedRow);

                        if (rowIndex >= 0) {
                          final List<DataGridCell> cells = shiftClassDataSource
                              ._shiftClassData[rowIndex]
                              .getCells();

                          // Find the index of the 'id' column in the row.
                          final int colIndex = cells.indexWhere(
                              (cell) => cell.columnName == 'shiftCount');
                          if (colIndex != -1) {
                            // Get and increment the current ID value.
                            int currentId = cells[colIndex].value;
                            if (currentId > 0) {
                              currentId--;
                            }
                            ShiftClass sf = shiftClasses[rowIndex];
                            sf = sf.copyWith(shiftCount: currentId);
                            shiftClasses[rowIndex] = sf;
                            shiftClassDataSource._shiftClassData[rowIndex]
                                    .getCells()[colIndex] =
                                DataGridCell<int>(
                                    columnName: 'shiftCount', value: currentId);
                            // Clear the flag variable and add the updated row to maintain selection.
                            selectedList.clear();
                            selectedList.add(
                                shiftClassDataSource._shiftClassData[rowIndex]);
                            shiftClassDataSource.updateDataGridSource(
                                rowColumnIndex:
                                    RowColumnIndex(rowIndex, colIndex));
                            _dataGridController.selectedRow = selectedList[0];
                          }
                        }
                      }
                      debugPrint('line 520 ');
                    },
                    child: Container(
                        //width: 50.0,
                        //height: 50.0,
                        // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
                        decoration: BoxDecoration(
                          color: color1,
                          border: Border.all(color: Colors.black87, width: 3),
                          shape: BoxShape.circle,
                        ),
                        //child: Text(count.toString(), style: new TextStyle(color: Colors.white, fontSize: smallFontSize),// You can add a Icon instead of text also, like below.
                        child: new Icon(Icons.remove,
                            size: 28.0, color: Colors.black38)),
                  )
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: 50,
                  width: screenWidth! / 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black87, width: 4),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Date: $formatted Discipline: $discipline',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize! /
                                h!,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(height:20),
              // Container(
              //   height: 200,
              //   width: screenWidth-10,
              //   child: Column(
              //     children: [
              //       Container(
              //         height: 90,
              //         width: screenWidth-10,
              //         decoration: BoxDecoration(
              //             color: Colors.white,
              //             border:
              //             Border.all(color: Colors.black87,width:4),
              //             borderRadius:
              //             BorderRadius.circular(12)),
              //         child: Text('To exit without saving your data, click the Back Arrow icon above.  To save and exit, click the Save button shown below',
              //             overflow: TextOverflow.visible,
              //             style: TextStyle(
              //               fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! / h,
              //               color: Colors.black87,
              //               fontWeight: FontWeight.bold,
              //             )
              //         ),
              //       ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 50,
                  width: screenWidth! / 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black87, width: 4),
                      borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.white30),
                        elevation: WidgetStatePropertyAll<double>(0),
                      ),
                      child: Text("Save -> Back to Calendar",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize! /
                                  h!,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      onPressed: () async {
                        List<Map<String, dynamic>> lmp = [];
                        shiftClasses.sort(
                            (a, b) => (a.shiftCode.compareTo(b.shiftCode)));
                        for (int i = 0; i < shiftClasses.length; i++) {
                          ShiftClass sf = shiftClasses[i];
                          debugPrint('line 464: ${sf.shiftCount}');
                          Map<String, dynamic> lp = sf.toJson();
                          lmp.add(lp);
                        }

                        Navigator.pop(context, lmp);
                      }),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: 50,
                  width: screenWidth! / 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black87, width: 4),
                      borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.white30),
                        elevation: WidgetStatePropertyAll<double>(0),
                      ),
                      child: Text("Clear -> Back to Calendar",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize! /
                                  h!,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      onPressed: () async {
                        List<Map<String, dynamic>> lmp = [];
                        for (int i = 0; i < shiftClasses.length; i++) {
                          ShiftClass sf = shiftClasses[i];
                          sf = sf.copyWith(shiftCount: 0);
                          shiftClasses[i] = sf;
                          Map<String, dynamic> lp = sf.toJson();
                          lp['shiftCount'] = 0;
                          lmp.add(lp);
                        }

                        Navigator.pop(context, lmp);
                      }),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

// class ShiftClassDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   ShiftClassDataSource({required this.dataGridController,
//     required xshiftClasses,
//     required this.fontSize}) {
//     dataGridRows = xshiftClasses
//         .map<DataGridRow>((dataGridRow) =>
//         DataGridRow(cells: [
//           DataGridCell<String>(
//               columnName: 'shiftCode', value: dataGridRow.shiftCode),
//           DataGridCell<String>(
//               columnName: 'startTime', value: dataGridRow.startTime),
//           DataGridCell<String>(
//               columnName: 'endTime', value: dataGridRow.endTime),
//           DataGridCell<int>(
//               columnName: 'shiftCount', value: dataGridRow.shiftCount),
//         ]))
//         .toList();
//     if (fontSize! > 8) {
//       this.fontSize = 8;
//     }
//     debugPrint('line  581: ${fontSize}');
//   }
//
//   dynamic newCellValue;
//   double? fontSize;
//   List<DataGridRow> _shiftClassData = [];
//   final DataGridController dataGridController;
//
//   List<DataGridRow> dataGridRows = [];
//
//   @override
//   List<DataGridRow> get rows => dataGridRows;
//
//   // @override
//   // DataGridRowAdapter? buildRow(DataGridRow row) {
//   //   TextStyle? getSelectionTextStyle() {
//   //     return dataGridController.selectedRows.contains(row)
//   //         ? TextStyle(
//   //             fontFamily: 'Raleway',
//   //             fontWeight: FontWeight.w300,
//   //             color: Colors.white,
//   //           )
//   //         : null;
//   //   }
//   //
//   //   return DataGridRowAdapter(
//   //       cells: row.getCells().map<Widget>((dataGridCell) {
//   //     return Container(
//   //       color: Colors.transparent,
//   //       alignment: (dataGridCell.columnName == 'shiftCode' ?
//   //           Alignment.center : dataGridCell.columnName == 'shiftCount' ?
//   //             Alignment.centerRight
//   //           : Alignment.centerLeft),
//   //       padding: EdgeInsets.symmetric(horizontal: 2.0),
//   //       child: Text(
//   //         dataGridCell.value.toString(),
//   //         overflow: TextOverflow.ellipsis,
//   //         style: TextStyle(
//   //           fontSize: fontSize,
//   //           color: Colors.black87,
//   //           fontWeight: FontWeight.bold,
//   //         ),
//   //       ),
//   //     );
//   //   }).toList());
//   // }
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//           return Container(
//             height: 10,
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(2.0),
//             child: Text(e.value.toString(),
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: fontSize,
//                 )
//             ),
//           );
//         }).toList());
//   }
//   void updateDataGridSource({required RowColumnIndex rowColumnIndex}) {
//     debugPrint('line 740: $rowColumnIndex');
//   notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
//   }
// }
/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class ShiftClassDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  ShiftClassDataSource(
      {required List<ShiftClass> shiftClassData, required double fontS}) {
    _shiftClassData = shiftClassData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'shiftCode', value: e.shiftCode),
              DataGridCell<String>(columnName: 'startTime', value: e.startTime),
              DataGridCell<String>(columnName: 'endTime', value: e.endTime),
              DataGridCell<int>(columnName: 'shiftCount', value: e.shiftCount),
            ]))
        .toList();
    fontSize = fontS;
  }
  double fontSize = 10;
  List<DataGridRow> _shiftClassData = [];

  @override
  List<DataGridRow> get rows => _shiftClassData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4.0),
        child: Text(e.value.toString(),
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
      );
    }).toList());
  }

  void updateDataGridSource({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }
}
