import 'package:cms_web/features/shared/utils/dropdown_codes.dart';

class HCPCredential {
  HCPCredential(
      {
      // required this.id,
      // required this.mongodbId,   //hcpprofessional
      required this.credId, //asm
      required this.hcpId,
      required this.credCodeId,
      required this.credCodeDescription,
      required this.credType,
      required this.credAcquiredDate,
      required this.credCEUDate,
      required this.empCode,
      required this.empComm,
      required this.credExpirationDate,
      required this.empHasIt,
      required this.empHours,
      required this.empLicenseNumber,
      required this.empLicenseState,
      required this.empOver,
      required this.empPosNeg,
      required this.empScore,
      required this.empSponsor,
      required this.empTitle,
      required this.credVerifiedBy,
      required this.credVerificationDate,
      required this.credPass,
      required this.credWarn,
      required this.credWillWarn,
      required this.credWillWarnDate,
      required this.credWillFail,
      required this.credWillFailDate,
      required this.agencyRequired,
      required this.hideRegistrantPortal,
      required this.useExpirationDate,
      required this.getAcquiredDate,
      required this.allowOverRide,
      required this.allowOverRideLabel,
      required this.yesNoLabel});

  // final ObjectId id; //0
  // final ObjectId mongodbId;  //hcpprof
  final int credId; //2     //asm
  final int hcpId;
  final int credCodeId; //3
  final String credCodeDescription; //4
  final String credType; //5
  final DateTime? credAcquiredDate; //6
  final DateTime? credCEUDate; //7
  final String? empCode; //8
  final String? empComm; //9
  final DateTime? credExpirationDate; //10
  final bool empHasIt; //11
  final double empHours; //12
  final String? empLicenseNumber; //13
  final String? empLicenseState; //14
  final bool empOver; //15
  final String? empPosNeg; //16
  final double empScore; //17
  final String? empSponsor; //18
  final String? empTitle; //19
  final String? credVerifiedBy; //20
  final DateTime? credVerificationDate; //21
  final bool credPass; //22
  final bool credWarn; //23
  final bool credWillWarn; //24
  final DateTime? credWillWarnDate; //25
  final bool credWillFail; //26
  final DateTime? credWillFailDate; //27
  final bool agencyRequired; //28
  final bool hideRegistrantPortal; //29
  final bool useExpirationDate; //30
  final bool getAcquiredDate; //31
  final bool allowOverRide; //32
  final String? allowOverRideLabel; //33
  final String? yesNoLabel; //34

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    //   col['id'] = id;
    // col['mongodbId'] = mongodbId;
    col['credId'] = credId;
    col['credCodeId'] = credCodeId;
    col['credCodeDescription'] = credCodeDescription;
    col['credType'] = credType;
    if (credAcquiredDate != null) {
      col['credAcquiredDate'] = credAcquiredDate;
    }
    if (credCEUDate != null) {
      col['credCEUDate'] = credCEUDate;
    }
    if (empCode != '') {
      col['empCode'] = empCode;
    }
    if (empComm != '') {
      col['empComm'] = empComm;
    }
    if (credExpirationDate != null) {
      col['credExpirationDate'] = credExpirationDate;
    }
    col['empHasIt'] = empHasIt;
    col['empHours'] = empHours;
    if (empLicenseNumber != '') {
      col['empLicenseNumber'] = empLicenseNumber;
    }
    if (empLicenseState != '') {
      col['empLicenseState'] = empLicenseState;
    }
    col['empOver'] = empOver;
    if (empPosNeg != '') {
      col['empPosNeg'] = empPosNeg;
    }
    col['empScore'] = empScore;
    if (empSponsor != '') {
      col['empSponsor'] = empSponsor;
    }
    if (empTitle != '') {
      col['empTitle'] = empTitle;
    }
    if (credVerifiedBy != '') {
      col['credVerifiedBy'] = credVerifiedBy;
    }
    if (credVerificationDate != null) {
      col['credVerificationDate'] = credVerificationDate;
    }
    col['credPass'] = credPass;
    col['credWarn'] = credWarn;
    col['credWillWarn'] = credWillWarn;
    if (credWillWarnDate != null) {
      col['credWillWarnDate'] = credWillWarnDate;
    }
    col['credWillFail'] = credWillFail;
    if (credWillFailDate != null) {
      col['credWillFailDate'] = credWillFailDate;
    }
    col['agencyRequired'] = agencyRequired;
    col['hideRegistrantPortal'] = hideRegistrantPortal;
    col['useExpirationDate'] = useExpirationDate;
    col['getAcquiredDate'] = getAcquiredDate;
    col['allowOverRide'] = allowOverRide;
    col['allowOverRideLabel'] = allowOverRideLabel;
    if (yesNoLabel != '' && yesNoLabel != null) {
      col['yesNoLabel'] = yesNoLabel;
    }

    return col;
  }

  DropDownCodes dropDownCodes = DropDownCodes();

  Map<String, dynamic> getClientDepartmentModelData(Map<String, dynamic> imp) {
    Map<String, dynamic> dataElements = {};
    List<dynamic> lutc = [];
    imp.forEach((k, v) {
      // print('line 13: $k $v');
      switch (k) {
        case 'DeptID':
          {
            //2
            dataElements['departmentId'] = int.parse(v.toString());
            //    dataElements['departmentAsOwnerId'] = ObjectId().toString();
          }
          break;
        case "ClientID":
          {
            //0
            dataElements['clientId'] = int.parse(v.toString());
          }
          break;
        case 'DeptNumber':
          {
            dataElements['departmentNumber'] = v;
          }
          break;
        case "DepartmentName":
          {
            //4

            dataElements['departmentName'] = v;
          }
          break;
        case 'CostCenter':
          {
            dataElements['costCenter'] = v;
          }
          break;
        case "BranchID":
          {
            //dyamic 5
            try {
              if (int.tryParse(v.toString()) == null) {
                v = 999;
              }
              dataElements['branchId'] = int.parse(v.toString());
              String bn = dropDownCodes.getBranchNames(int.parse(v.toString()));
              dataElements['branchName'] = bn;
            } catch (e) {
              print('line 54: $v $imp');
              throw Exception('line 55 error for int');
            }
          }
          break;
        // case 'LastTouched': {
        //   bool b = dropDownCodes.isNullEmptyOrFalse(v);
        //   if (b == false) {
        //     dynamic dte = dropDownCodes.reformatDate(v,isTime:false);
        //      print('line 55: $v $dte');
        //     if (dte != null) {
        //       dataElements[5] = DateTime.parse(dte);
        //    } else {
        //    dataElements[5] = null;
        //    }
        //   } else {
        //     dataElements[5] = null;
        //   }
        //  }
        //   break;
        case "Note":
          {
            //dynamic null 6
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['note'] = v;
            } else {
              dataElements['note'] = '';
            }
          }
          break;
        case "StatusID":
          {
            //string 7
            dataElements['statusId'] = v;
            String bn = dropDownCodes.getClientStatus(v);
            dataElements['statusDescription'] = bn;
          }
          break;
        case "FirstServiced":
          {
            //Date 7
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: true);
                if (lutc.isNotEmpty) {
                  dataElements['firstServicedDate'] = DateTime.utc(
                      lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5]);
                } else {
                  dataElements['firstServicedDate'] =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
                }
              }
            } else {
              dataElements['firstServicedDate'] =
                  DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
            }
          }
          break;
        case "LastServiced":
          {
            //Date 7
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: true);
                if (lutc.isNotEmpty) {
                  dataElements['lastServicedDate'] = DateTime.utc(
                      lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5]);
                } else {
                  dataElements['lastServicedDate'] =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
                }
              }
            } else {
              dataElements['lastServicedDate'] =
                  DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
            }
          }
          break;
        case 'UseClientPhysicalAddress':
          {
            dataElements['useClientPhysicalAddress'] = (v == true);
          }
          break;
        case "M_Addr1":
          {
            //dynamic string 16
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['mailingAddress1'] = v;
            } else {
              dataElements['mailingAddress1'] = '';
            }
          }
          break;
        case "M_Addr2":
          {
            //string null 17
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['mailingAddress2'] = v;
            } else {
              dataElements['mailingAddress2'] = '';
            }
          }
          break;
        case "M_County":
          {
            //strig null 18
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['mailingCounty'] = v;
            } else {
              dataElements['mailingCounty'] = '';
            }
          }
          break;
        case "M_City":
          {
            //strig null 19
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['mailingCity'] = v;
            } else {
              dataElements['mailingCity'] = '';
            }
          }
          break;
        case "M_State":
          {
            //strig null 20
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['mailingState'] = v;
            } else {
              dataElements['mailingState'] = '';
            }
          }
          break;
        case "M_Zip":
          {
            //strig null 21
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['mailingZipCode'] = v;
            } else {
              dataElements['mailingZipCode'] = '';
            }
          }
          break;
        case 'UseClientBillingAddress':
          {
            dataElements['useClientBillingAddress'] = (v == true);
          }
          break;
        case 'BillingSameAsPhysical':
          {
            dataElements['billingSameAsPhysical'] = (v == true);
          }
          break;
        case "B_Name":
          {
            //strig null 19
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billingAddressName'] = v;
            } else {
              dataElements['billingAddressName'] = '';
            }
          }
          break;
        case "B_Attn":
          {
            //strig null 10
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billingAddressAttention'] = v;
            } else {
              dataElements['billingAddressAttention'] = '';
            }
          }
          break;
        case "B_Addr1":
          {
            //dynamic string 11
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billingAddress1'] = v;
            } else {
              dataElements['billingAddress1'] = '';
            }
          }
          break;
        case "B_Addr2":
          {
            //string null 12
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billingAddress2'] = v;
            } else {
              dataElements['billingAddress2'] = '';
            }
          }
          break;
        case "B_City":
          {
            //strig null 13
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billingCity'] = v;
            } else {
              dataElements['billCity'] = '';
            }
          }
          break;
        case "B_State":
          {
            //strig null 14
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billingState'] = v;
            } else {
              dataElements['billingState'] = '';
            }
          }
          break;
        case "B_Zip":
          {
            //strig null 15
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billingZipCode'] = v;
            } else {
              dataElements['billingZipCode'] = '';
            }
          }
          break;
        case 'UseClientPayment':
          {
            dataElements['useClientPayment'] = (v == true);
          }
          break;
        case 'PayorId':
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['payorId'] = v;
            } else {
              dataElements['payorId'] = null;
            }
          }
          break;
        case 'PaymentMethodCodeID':
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['paymentMethodCodeId'] = v;
            } else {
              dataElements['paymentMethodCodeId'] = null;
            }
          }
          break;
        case 'PaymentTermsCodeID':
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['paymentTermsCodeId'] = v;
            } else {
              dataElements['paymentTermsCodeId'] = null;
            }
          }
        case 'UseClientWeek':
          {
            dataElements['useClientWeek'] = (v == true);
          }
          break;
        case "Week_Start_Time":
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: true);
                if (lutc.isNotEmpty) {
                  dataElements['weekStartTime'] = DateTime.utc(
                      lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5]);
                } else {
                  dataElements['weekStartTime'] =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
                }
              }
            } else {
              dataElements['weekStartTime'] =
                  DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
            }
          }
          break;
        case "Week_Start_Day":
          {
            //dynamic 27
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['weekStartDay'] = v;
            } else {
              dataElements['weekStartDay'] = null;
            }
          }
          break;
        case "Weekend_Start_Time":
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: true);
                if (lutc.isNotEmpty) {
                  dataElements['weekendStartTime'] = DateTime.utc(
                      lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5]);
                } else {
                  dataElements['weekendStartTime'] =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
                }
              }
            } else {
              dataElements['weekendStartTime'] =
                  DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
            }
          }
          break;
        case "Weekend_Start_Day":
          {
            //dynamic 29
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['weekendStartDay'] = v;
            } else {
              dataElements['weekendStartDay'] = null;
            }
          }
          break;
        case "Weekend_End_Time":
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: true);
                if (lutc.isNotEmpty) {
                  dataElements['weekendEndTime'] = DateTime.utc(
                      lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5]);
                } else {
                  dataElements['weekendEndTime'] =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
                }
              }
            } else {
              dataElements['weekendEndTime'] =
                  DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
            }
          }
          break;

        case "Weekend_End_Day":
          {
            //dynamic 31
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['weekendEndDay'] = v;
            } else {
              dataElements['weekendEndDay'] = null;
            }
          }
          break;
        //dynamic 31
        case 'OTTemplateID':
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['otTemplateID'] = v;
            } else {
              dataElements['OTTemplateID'] = null;
            }
          }
          break;
        case 'BillingIncludeOnCallInOT':
          {
            dataElements['billingIncludeOnCallInOT'] = (v == true);
          }
          break;
        case 'AcceptsOT':
          {
            dataElements['acceptsOT'] = (v == true);
          }
          break;
        case "TimeType":
          {
            dataElements['timeType'] = v;
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              String x = dropDownCodes.getTimeTypes(v);
              dataElements['timeTypeDescription'] = x;
            } else {
              dataElements['timeTypeDescription'] = '';
            }
          }
          break;
        case 'SplitShifts':
          {
            dataElements['splitShifts'] = (v == true);
          }
          break;
        case 'SplitWeekends':
          {
            dataElements['splitWeekends'] = (v == true);
          }
          break;
        case 'SplitHolidays':
          {
            dataElements['splitHolidays'] = (v == true);
          }
          break;
        case 'UseClientPayModifiers':
          {
            dataElements['useClientPayModifiers'] = (v == true);
          }
          break;
        case "P_Hol":
          {
            //dymamic 49
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['payHolidayRate'] = double.parse(v.toString());
            } else {
              dataElements['payHolidayRate'] = null;
            }
          }
          break;
        case "P_Hol_Plus":
          {
            //dymamic 50
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['payHolidayPlusRate'] = double.parse(v.toString());
            } else {
              dataElements['payHolidayPlusRate'] = null;
            }
          }
          break;
        case "P_Max":
          {
            //dymamic 51
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['payHolidayMaxRate'] = double.parse(v.toString());
            } else {
              dataElements['payHolidayMaxRate'] = null;
            }
          }
          break;
        case "P_Max_Plus":
          {
            //dymamic 52
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['payHolidayMaxPlusRate'] =
                  double.parse(v.toString());
            } else {
              dataElements['payHolidayMaxPlusRate'] = null;
            }
          }
          break;
        case 'UseClientBillModifiers':
          {
            dataElements['useClientBillModifiers'] = (v == true);
          }
          break;
        case "B_Ot":
          {
            //dymamic 45
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billOTRate'] = double.parse(v.toString());
            } else {
              dataElements['billOTRate'] = null;
            }
          }
          break;
        case "B_Ot_Plus":
          {
            //dymamic 46
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billOTPlusRate'] = double.parse(v.toString());
            } else {
              dataElements['billOTPlusRate'] = null;
            }
          }
          break;
        case "B_Dbl":
          {
            //dymamic 47
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billDblRate'] = double.parse(v.toString());
            } else {
              dataElements['billDblRate'] = null;
            }
          }
          break;
        case "B_Dbl_Plus":
          {
            //dymamic 48
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billDblPlusRate'] = double.parse(v.toString());
            } else {
              dataElements['billDblPlusRate'] = null;
            }
          }
          break;
        case "B_Hol":
          {
            //dymamic 49
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billHolidayRate'] = double.parse(v.toString());
            } else {
              dataElements['billHolidayRate'] = null;
            }
          }
          break;
        case "B_Hol_Plus":
          {
            //dymamic 50
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billHolidayPlusRate'] = double.parse(v.toString());
            } else {
              dataElements['billHolidayPlusRate'] = null;
            }
          }
          break;
        case "B_Max":
          {
            //dymamic 51
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billMaxRate'] = double.parse(v.toString());
            } else {
              dataElements['billMaxRate'] = null;
            }
          }
          break;
        case "B_Max_Plus":
          {
            //dymamic 52
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['billMaxPlusRate'] = double.parse(v.toString());
            } else {
              dataElements['billMaxPlusRate'] = null;
            }
          }
          break;
        case "UseClientTax":
          {
            dataElements['userClientTax'] = (v == true);
          }
          break;
        case "SalesTaxID":
          {
            //dymamic 41
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['salesTaxId'] = v;
            } else {
              dataElements['salesTaxId'] = '';
            }
          }
          break;
        case "UseClientCreditCard":
          {
            dataElements['useClientCreditCard'] = (v == true);
          }
          break;
        case "CreditCardTypeCodeID":
          {
            //dymamic 55
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['creditCardTypeCodeId'] = v;
            } else {
              dataElements['creditCardTypeCodeId'] = '';
            }
          }
          break;
        case "CreditCardNumber":
          {
            //dymamic 56
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['creditCardNumber'] = v;
            } else {
              dataElements['creditCardNumber'] = '';
            }
          }
          break;
        case "ExpirationDate":
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: true);
                if (lutc.isNotEmpty) {
                  dataElements['creditCardExpirationDate'] = DateTime.utc(
                      lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5]);
                } else {
                  dataElements['creditCardExpirationDate'] =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
                }
              }
            } else {
              dataElements['creditCardExpirationDate'] =
                  DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0);
            }
          }
          break;
        case "CardHolderName":
          {
            //dymamic 58
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['cardHolderName'] = v;
            } else {
              dataElements['cardHolderName'] = '';
            }
          }
          break;
        case "ChargeIncrement":
          {
            //dymamic 59
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['chargeIncrement'] = double.parse(v.toString());
            } else {
              dataElements['chargeIncrement'] = null;
            }
          }
          break;
        case "ChargeWhenInvoiced":
          {
            dataElements['chargeWhenInvoiced'] = (v == true);
          }
          break;
        case "UseClientInvoicing":
          {
            dataElements['UseClientInvoicing'] = (v == true);
          }
          break;
        case "InvoiceFormatCodeID":
          {
            //dymamic 53
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['invoiceFormatCodeId'] = v;
            } else {
              dataElements['invoiceFormatCodeId'] = '';
            }
          }
          break;
        case "PrintQueue":
          {
            //dymamic 61
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['printQueue'] = v;
            } else {
              dataElements['printQueue'] = '';
            }
          }
          break;
        case "PrintQueueCopies":
          {
            //dymamic  64
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['printQueueCopies'] = int.parse(v.toString());
            } else {
              dataElements['printQueueCopies'] = 0;
            }
          }
          break;
        case "OMRQueue":
          {
            dataElements['omrQueue'] = (v == true);
          }
          break;
        case "EmailQueue":
          {
            dataElements['emailQueue'] = (v == true);
          }
          break;

        case "EmailQueuePDF":
          {
            dataElements['emailQueuePDF'] = (v == true);
          }
          break;
        case "EmailQueueXLS":
          {
            dataElements['emailQueueXLS'] = (v == true);
          }
        case "PrintImages":
          {
            dataElements['printImages'] = (v == true);
          }
          break;
        case "ImagesPerPage":
          {
            //dymamic 68
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['imagesPerPage'] = int.parse(v.toString());
            } else {
              dataElements['imagesPerPage'] = 0;
            }
          }
          break;
        case "InvoiceComments":
          {
            //dymamic 69
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['invoiceComments'] = v;
            } else {
              dataElements['invoiceComments'] = '';
            }
          }
          break;
        case "InvoiceEmailTemplateID":
          {
            //dymamic 91
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['invoiceEmailTemplateId'] = v;
            } else {
              dataElements['invoiceEmailTemplateId'] = '';
            }
          }
          break;
        case "PayrollLocationID":
          {
            //dymamic 26
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['payrollLocationId'] = v;
            } else {
              dataElements['payrollLocationId'] = '';
            }
          }
          break;
        case "MunicipalityID":
          {
            //dymamic 22
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['municipalityId'] = v;
            } else {
              dataElements['municipalityId'] = '';
            }
          }
          break;

        case "MunicipalityName":
          {
            //dymamic 23
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['municipalityName'] = v;
            } else {
              dataElements['municipalityName'] = '';
            }
          }
          break;
        case "SchoolDistrictID":
          {
            //dymamic 24
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['schoolDistrictId'] = v;
            } else {
              dataElements['schoolDistrictId'] = '';
            }
          }
          break;
        case "SchoolDistrictName":
          {
            //dymamic 25
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['schoolDistrictName'] = v;
            } else {
              dataElements['schoolDistrictName'] = '';
            }
          }
          break;
        case "Latitude":
          {
            //dymamic 100
            v ??= 0;
            if (double.tryParse(v.toString()) == null) {
              v = 0;
            }
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['latitude'] = double.parse(v.toString());
            } else {
              dataElements['latitude'] = null;
            }
          }
          break;
        case "Longitude":
          {
            //dymamic 101
            v ??= 0;
            if (double.tryParse(v.toString()) == null) {
              v = 0;
            }
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              dataElements['longitude'] = double.parse(v.toString());
            } else {
              dataElements['longitude'] = null;
            }
          }
          break;
        case 'ownerId':
          {
            dataElements['ownerId'] = v.toString();
          }
          break;
        default:
          {}
          break;
      }
    });
    print('line 802 get clident data model exiting...');
    return dataElements;
  }
}
