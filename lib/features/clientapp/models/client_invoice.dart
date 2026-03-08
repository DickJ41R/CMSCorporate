import 'package:cloud_firestore/cloud_firestore.dart';

class ClientInvoice {
  ClientInvoice(
      {required this.invoiceId,
      required this.invoiceNumber,
      required this.clientNumber,
      required this.clientName,
      required this.departmentName,
      required this.branchName,
      required this.invoiceDate,
      required this.billAmount,
      required this.adjustmentAmount,
      required this.discountAmount,
      required this.taxAmount,
      required this.totalAmount,
      required this.totalPaid,
      required this.paidAmount,
      required this.balance,
      required this.timecardQty,
      required this.postDate,
      required this.clientGroupName,
      required this.clientType,
      required this.clientId,
      required this.invoiceDueDate,
      required this.invoicePastDueDays,
      required this.invoicePaymentTerms,
      required this.invoiceURL});

  final int invoiceId;
  final String invoiceNumber;
  final String clientNumber;
  final String clientName;
  final String? departmentName;
  final String branchName;
  DateTime invoiceDate;
  final double billAmount;
  final double adjustmentAmount;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final double totalPaid;
  final double paidAmount;
  final double balance;
  final int timecardQty;
  DateTime postDate;
  final String? clientGroupName;
  final String? clientType;
  final int clientId;
  DateTime invoiceDueDate;
  final int invoicePastDueDays;
  final String? invoicePaymentTerms;
  final String? invoiceURL;

  factory ClientInvoice.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ClientInvoice(
        invoiceId: data?['invoiceId'] as int,
        invoiceNumber: data?['invoiceNumber'] as String,
        clientNumber: data?['clientNumber'] as String,
        clientName: data?['clientName'] as String,
        departmentName: (data?['departmentName'] ?? '') as String,
        branchName: data?['branchName'] as String,
        invoiceDate: data?['invoiceDate'] == null ? null : data?['invoiceDate'],
        billAmount: data?['billAmount'] as double,
        adjustmentAmount: data?['adjustmentAmount'] as double,
        discountAmount: data?['discountAmount'] as double,
        taxAmount: data?['taxAmount'] as double,
        totalAmount: data?['totalAmount'] as double,
        totalPaid: data?['totalPaid'] as double,
        paidAmount: data?['paidAmount'] as double,
        balance: data?['balance'] as double,
        timecardQty: data?['timecardQty'] as int,
        postDate: data?['postDate'] == null ? null : data?['postDate'],
        clientGroupName: data?['clientGroupName'],
        clientType: data?['clientType'] as String,
        clientId: data?['clientId'] as int,
        invoiceDueDate:
            data?['invoiceDueDate'] == null ? null : data?['invoiceDueDate'],
        invoicePastDueDays: data?['invoicePastDueDays'] as int,
        invoicePaymentTerms: data?['invoicePaymentTerms'] == null
            ? ''
            : data?['invoicePaymentTerms'] as String,
        invoiceURL: data?['invoiceURL'] as String);
  }
  Map<String, dynamic> toMap() => {
        'invoiceId': invoiceId,
        'invoiceNumber': invoiceNumber,
        'clientNumber': clientNumber,
        'clientName': clientName,
        'departmentName': departmentName,
        'branchName': branchName,
        'invoiceDate': invoiceDate,
        'billAmount': billAmount,
        'adjustmentAmount': adjustmentAmount,
        'discountAmount': discountAmount,
        'taxAmount': taxAmount,
        'totalAmount': totalAmount,
        'totalPaid': totalPaid,
        'paidAmount': paidAmount,
        'balance': balance,
        'timecardQty': timecardQty,
        'postDate': postDate,
        'clientGroupName': clientGroupName,
        'clientType': clientType,
        'clientId': clientId,
        'invoiceDueDate': invoiceDueDate,
        'invoicePastDueDays': invoicePastDueDays,
        'invoicePaymentTerms': invoicePaymentTerms,
        'invoiceURL': invoiceURL
      };
  String get invoiceUrl {
    return invoiceUrl;
  }
}
