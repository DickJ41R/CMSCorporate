
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientCredit {
  const ClientCredit({
    required this.clientId,
    required this.creditId,
    required this.creditStatusCodeId,
    required this.creditLimit,
    required this.creditDeclineReasonCodeId,
    required this.creditPreApprovedAmount,
    required this.creditScoreCodeId,
    required this.creditWarn,
    required this.creditSuspend,
    required this.warnCreditLimitAmount,
    required this.suspendCreditLimitAmount,
    required this.weeklyCreditLimit,
    required this.weeklyCreditLimitAmount,
    required this.weeklyCreditLimitReasonCodeId,
    required this.boCurrentBalance,
    required this.boOpenCredit,
    required this.boMTDBilling,
    required this.boMTDPaid,
    required this.boYTDBilling,
    required this.boYTDPaid,
    required this.boFirstInvoiced,
    required this.boLastInvoiced,
    required this.gpOClient,
    required this.invoiceFrequencyCodeId,
    required this.billingGroupMaster,
    required this.boLastPaidAmount,
    required this.boLastPaidDate,
  });

  final int clientId;
  final int creditId;
  final int creditStatusCodeId;
  final double creditLimit;
  final int creditDeclineReasonCodeId;
  final double creditPreApprovedAmount;
  final int creditScoreCodeId;
  final bool creditWarn;
  final bool creditSuspend;
  final double warnCreditLimitAmount;
  final double suspendCreditLimitAmount;
  final bool weeklyCreditLimit;
  final double weeklyCreditLimitAmount;
  final dynamic weeklyCreditLimitReasonCodeId;
  final double boCurrentBalance;
  final double boOpenCredit;
  final double boMTDBilling;
  final double boMTDPaid;
  final double boYTDBilling;
  final double boYTDPaid;
  final String? boFirstInvoiced;
  final String? boLastInvoiced;
  final bool gpOClient;
  final dynamic invoiceFrequencyCodeId;
  final bool billingGroupMaster;
  final double boLastPaidAmount;
  final String? boLastPaidDate;

  factory ClientCredit.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    return ClientCredit(
      clientId: data?["clientId"],
      creditId: data?["creditId"],
      creditStatusCodeId: data?["creditStatusCodeId"],
      creditLimit: data?["creditLimit"],
      creditDeclineReasonCodeId: data?["creditDeclineReasonCodeId"],
      creditPreApprovedAmount: data?["creditPreApprovedAmount"],
      creditScoreCodeId: data?["creditScoreCodeId"],
      creditWarn: data?["creditWarn"],
      creditSuspend: data?["creditSuspend"],
      warnCreditLimitAmount: data?["warnCreditLimitAmount"],
      suspendCreditLimitAmount: data?["suspendCreditLimitAmount"],
      weeklyCreditLimit: data?["weeklyCreditLimit"],
      weeklyCreditLimitAmount: data?["weeklyCreditLimitAmount"],
      weeklyCreditLimitReasonCodeId: data?["weeklyCreditLimitReasonCodeId"],
      boCurrentBalance: data?["boCurrentBalance"],
      boOpenCredit: data?["boOpenCredit"],
      boMTDBilling: data?["boMTDBilling"],
      boMTDPaid: data?["boMTDPaid"],
      boYTDBilling: data?["boYTDBilling"],
      boYTDPaid: data?["boYTDPaid"],
      boFirstInvoiced: data?["boFirstInvoiced"],
      boLastInvoiced: data?["boLastInvoiced"],
      gpOClient: data?["gpOClient"],
      invoiceFrequencyCodeId: data?["invoiceFrequencyCodeId"],
      billingGroupMaster: data?["billingGroupMaster"],
      boLastPaidAmount: data?[" boLastPaidAmount"],
      boLastPaidDate: data?["boLastPaidDate"],
    );
  }
  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    col['clientId'] = clientId;
    col['creditId'] = creditId;
    col['creditStatusCodeId'] = creditStatusCodeId;
    col['creditLimit'] = creditLimit;
    if ( creditDeclineReasonCodeId != '') {
      col['creditDeclineReasonCodeId'] = creditDeclineReasonCodeId;
    }
      col['creditPreApprovedAmount'] = creditPreApprovedAmount;
    if (  creditScoreCodeId != '') {
     col['creditScoreCodeId'] = creditScoreCodeId;
    }
    col['creditWarn'] = creditWarn;
    col['creditSuspend'] = creditSuspend;
    col['warnCreditLimitAmount'] = warnCreditLimitAmount;
    col['suspendCreditLimitAmount'] = suspendCreditLimitAmount;
    col['weeklyCreditLimit'] = weeklyCreditLimit;
    col['weeklyCreditLimitAmount'] = weeklyCreditLimitAmount;
    if (weeklyCreditLimitReasonCodeId != null && weeklyCreditLimitReasonCodeId != '') {
    col['weeklyCreditLimitReasonCodeId'] = weeklyCreditLimitReasonCodeId;
    }
    col['boCurrentBalance'] = boCurrentBalance;
    col['boOpenCredit'] = boOpenCredit;
    col['boMTDBilling;'] = boMTDBilling;
    col['boMTDPaid'] = boMTDPaid;
    col['boYTDBilling'] = boYTDBilling;
    col['boYTDPaid'] = boYTDPaid;
    if ( boFirstInvoiced != null) {
    col['boFirstInvoiced'] =  boFirstInvoiced;
    }
    if (boLastInvoiced != null) {
    col['boLastInvoiced'] = boLastInvoiced;
    }
    col['gpOClient'] = gpOClient;
    if (invoiceFrequencyCodeId != null && invoiceFrequencyCodeId != '' ) {
    col['invoiceFrequencyCodeId'] = invoiceFrequencyCodeId;
    }
    col['billingGroupMaster'] = billingGroupMaster;
    col['boLastPaidAmount'] = boLastPaidAmount;
    if (boLastPaidDate != null) {
    col['boLastPaidDate'] = boLastPaidDate;
    }
     return col;
  }
  }