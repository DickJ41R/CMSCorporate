/// Custom business object class which contains properties to hold the detailed
/// information about the order which will be rendered in datagrid.

class WorkOrderClass {
  /// Creates the order class with required details.
  WorkOrderClass(
      this.orderId,
      this.statusId,
      this.clientName,
      this.departmentName,
      this.state,
      this.hcpName,
      this.shiftDate,
      this.shiftDateTime,
      this.disciplineName,
      this.grossMargin);

  /// Id of an order.
  final int orderId;

  /// status an order.
  final String statusId;

  /// client Name of an order.
  final String clientName;

  /// City of an order.
  final String departmentName;

  /// Freight of an order.
  final String state;

  /// Price of an order.
  final String hcpName;
  final String shiftDate;
  final String shiftDateTime;
  final String disciplineName;
  final String grossMargin;

  WorkOrderClass.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'] as int,
        statusId = json['statusId'] as String,
        clientName = json['clientName'] as String,
        departmentName = json['departmentName'] as String,
        state = json['state'] as String,
        hcpName = json['hcpName'] == null ? "Shift is Open" : json['hcpName'] as String,
        shiftDate = json['shiftDate'] as String,
        shiftDateTime = json['shiftDateTime'] as String,
        disciplineName = json['disciplineName'] as String,
        grossMargin = json['grossMargin'] as String;

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'statusId': statusId,
        'clientName': clientName,
        'departmentName': departmentName,
        'state': state,
        'hcpName': hcpName,
        'shiftDate': shiftDate,
        'shiftDateTime': shiftDateTime,
        'disciplineName': disciplineName,
        'grossMargin': grossMargin
//      'payRate': payRate,
      };

  WorkOrderClass copyWith(
      {int? orderId,
      String? statusId,
      String? clientName,
      String? departmentName,
      String? state,
      String? hcpName,
      String? shiftDate,
      String? shiftDateTime,
      String? disciplineName,
      String? grossMargin}) {
    return WorkOrderClass(
        orderId ?? this.orderId,
        statusId ?? this.statusId,
        clientName ?? this.clientName,
        departmentName ?? this.departmentName,
        state ?? this.state,
        hcpName ?? this.hcpName,
        shiftDate ?? this.shiftDate,
        shiftDateTime ?? this.shiftDateTime,
        disciplineName ?? this.disciplineName,
        grossMargin ?? this.grossMargin);
  }

  List<WorkOrderClass> workOrderClasses = <WorkOrderClass>[];

  void convertToWorkOrderClasses(List<dynamic> listD) {
    for (int i = 0; i < listD.length; i++) {
      dynamic ld = listD[i];
      WorkOrderClass wkc = WorkOrderClass(
          ld['orderId'],
          ld['statusId'],
          ld['clientName'],
          ld['departmentName'],
          ld['state'],
          ld['hcpName'],
          ld['shiftDate'],
          ld['shiftDateTime'],
          ld['disciplineName'],
          ld['grossMargin'].toString());
      workOrderClasses.add(wkc);
    }
  }
}
