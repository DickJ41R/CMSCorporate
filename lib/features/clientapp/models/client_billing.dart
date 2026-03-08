import 'package:cloud_firestore/cloud_firestore.dart';

class ClientBilling {
   ClientBilling({
      required this.clientId,
      required this.billingId,
      required this.splitShifts,
      required this.splitWeekends,
      required this.splitHolidays,
      required this.acceptsOT,
      required this.timeType,
      required this.payHoliday,
      required this.payOTModifier,
      required this.payHolidayPlusModifier,
      required this.payDblModifier,
      required this.payMaxModifier,
      required this.payMaxPlusModifier,
      required this.billOTModifier,
      required this.billOTPlusModifier,
      required this.payOTPlusModifier,
      required this.billDblModifier,
      required this.billDblPlusModifier,
      required this.billHolModifier,
      required this.billHolPlusModifier,
      required this.billMaxModifier,
      required this.billMaxPlusModifier,
      required this.facilityCancelLimit,
      required this.facilityCancelCharge,
      required this.agencyCancelLimit,
      required this.agencyCancelCredit,
      required this.weekStartDay,
      required this.weekStartTime,
      required this.weekendStartDay,
      required this.weekendStartTime,
      required this.weekendEndDay,
      required this.weekendEndTime,
      required this.billingGroup,
      required this.billByCodeName,
      required this.payorName,
      required this.billIncludeOnCallInOT,
      required this.billingClientName,
      required this.billingAttention
   });

   final dynamic clientId;
   final dynamic billingId;
   final bool splitShifts;
   final bool splitWeekends;
   final bool splitHolidays;
   final bool acceptsOT;
   final String timeType;
   final double payHoliday;
   final double payOTModifier;
   final double payHolidayPlusModifier;
   final double payDblModifier;
   final double payMaxModifier;
   final double payMaxPlusModifier;
   final double billOTModifier;
   final double billOTPlusModifier;
   final double payOTPlusModifier;
   final double billDblModifier;
   final double billDblPlusModifier;
   final double billHolModifier;
   final double billHolPlusModifier;
   final double billMaxModifier;
   final double billMaxPlusModifier;
   final bool facilityCancelLimit;
   final bool facilityCancelCharge;
   final bool agencyCancelLimit;
   final bool agencyCancelCredit;
   final dynamic weekStartDay;
   final dynamic weekStartTime;
   final dynamic weekendStartDay;
   final dynamic weekendStartTime;
   final dynamic weekendEndDay;
   final dynamic weekendEndTime;
   final dynamic billingGroup;
   final dynamic billByCodeName;
   final dynamic payorName;
   final bool billIncludeOnCallInOT; //2
   final String? billingClientName;
   final String? billingAttention;

   factory ClientBilling.fromFirestore(
       DocumentSnapshot<Map<String, dynamic>> snapshot,
       SnapshotOptions? options,) {
      final data = snapshot.data();
      return ClientBilling(
         clientId: data?["clientId"],
         billingId: data?["billingId"],
         splitShifts: data?["splitShifts"],
         splitWeekends: data?["splitWeekends"],
         splitHolidays: data?["splitHolidays"],
         acceptsOT: data?["acceptOT"],
         timeType: data?["timeType"],
         payHoliday: data?["payHoliday"],
         payOTModifier: data?["payOTModifier"],
         payHolidayPlusModifier: data?["payHolidayPlusModifier"],
         payDblModifier: data?["payDblModifier"],
         payMaxModifier: data?["payMaxModifier"],
         payMaxPlusModifier: data?["payMaxPlusModifier"],
         billOTModifier: data?["billOTModifier"],
         billOTPlusModifier: data?["billOTPlusModifier"],
         payOTPlusModifier: data?["payOTPlusModifier"],
         billDblModifier: data?["billDblModifier"],
         billDblPlusModifier: data?["billDblPlusModifier"],
         billHolModifier: data?["billHolidayModifier"],
         billHolPlusModifier: data?["billHolidayPlusModfier"],
         billMaxModifier: data?["billMaxModifier"],
         billMaxPlusModifier: data?["billMaxPlusModifier"],
         facilityCancelLimit: data?["facilityCancelLimit"],
         facilityCancelCharge: data?["facilityCancelCharge"],
         agencyCancelLimit: data?["agencyCancelLimit"],
         agencyCancelCredit: data?["agencyCancelCredit"],
         weekStartDay: data?["weekStartDat"],
         weekStartTime: data?["weekStartTime"],
         weekendStartDay: data?["weekendStartDay"],
         weekendStartTime: data?["weekendStartTime"],
         weekendEndDay: data?["weekEndDay"],
         weekendEndTime: data?["weekendEndTime"],
         billingGroup: data?["billingGroup"],
         billByCodeName: data?["billBuCodeName"],
         payorName: data?["payorName"],
         billIncludeOnCallInOT: data?["billINcludeOnCallInOT"],
         billingClientName: data?["billingClientName"],
         billingAttention: data?["billingAttention"]
      );
   }
// final double boCurrentBalance;
   // final double boOpenCredit;
   // final double boMTDBilling;
   // final double boMTDPaid;
   // final double boYTDBilling;
   // final double boYTDPaid;
   // final DateTime? boFirstInvoiced;
   // final DateTime? boLastInvoiced;

   // final double boLastPaidAmount;
   // final DateTime? lastPaidDate;
   // final bool billIncludeOnCallOT;
   // final int invoiceEmailTemplateId;

   //final String? billingGroupCodeId;
   // final String? billingGroupDescription;

   Map<String, dynamic> setCollection() {
      Map<String, dynamic> col = {};
      col['clientId'] = clientId;
      col['billingId'] = billingId;
      col['splitShifts'] = splitShifts;
      col['splitWeekends'] = splitWeekends;
      col['splitHolidays'] = splitHolidays;
      col['acceptsOT'] = acceptsOT;
      col['timeType'] = timeType;
      col['payHoliday'] = payHoliday;
      col['payOTModifier'] = payOTModifier;
      col['payHolidayPlusModifier'] = payHolidayPlusModifier;
      col['payDblModifier'] = payDblModifier;
      col['payMaxModifier'] = payMaxModifier;
      col['payMaxPlusModifier'] = payMaxPlusModifier;
      col['billOTModifier'] = billOTModifier;
       col['billDblModifier'] = billDblModifier;
      col['billOTPlusModifier'] = billOTPlusModifier;
      col['payOTPlusModifier'] = payOTPlusModifier;
      col['billDblPlusModifier'] = billDblPlusModifier;
      col['billHolModifier'] = billHolModifier;
      col['billHolPlusModifier'] = billHolPlusModifier;
      col['billMaxModifier'] = billMaxModifier;
      col['billMaxPlusModifier'] = billMaxPlusModifier;
      col['facilityCancelLimit'] = facilityCancelLimit;
      col['facilityCancelCharge'] = facilityCancelCharge;
      col['agencyCancelLimit;'] = agencyCancelLimit;
      col['agencyCancelCredit'] = agencyCancelCredit;
      if (weekStartDay != null && weekStartDay != '') {
         col['weekStartDay'] = weekStartDay;
      }
      if (weekStartTime != null && weekStartTime != '') {
         col['weekStarTimey'] = weekStartTime;
      }
      if (weekendStartDay != null && weekendStartDay != '') {
         col['weekendStartDay'] = weekendStartDay;
      }
      if (weekendStartTime != null && weekendStartTime != '') {
         col['weekendStartTime'] = weekendStartTime;
      }
      if (weekendEndDay != null && weekendEndDay != '') {
         col['weekendEndDay'] = weekendEndDay;
      }
      if (weekendEndTime != null && weekendEndTime != '') {
         col['weekendEndTime'] = weekendEndTime;
      }
      if (billingGroup != null && billingGroup != '') {
         col['billingGroup'] = billingGroup;
         }
      col['billIncludeOnCallInOT'] = billIncludeOnCallInOT; //2
      return col;
   }
}