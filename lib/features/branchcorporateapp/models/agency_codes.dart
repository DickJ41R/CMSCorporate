
class AgencyCodes {
    const AgencyCodes({
        //   required this.id,
           required this.codeId,
           required this.codeKey,
           required this.codeName,
           required this.codeDescription,
           required this.codeValue,
           required this.sortOrder,
           required this.color,
           required this.interfaceValue,
           required this.symmetryValue,
           required this.isDefault,
           required this.userTypeCodeId,
           required this.creditPreApprovedAmount,
           required this.creditLimit,
           required this.warnCreditLimitAmount,
           required this.suspendCreditLimitAmount,
           required this.allowEdit,
           required this.companyTaxId,
           required this.glAccount,
           required this.wageLimit,
           required this.taxRate,
           required this.hideOnlineApp
    });
 //   final ObjectId id;
    final dynamic codeId;
    final String codeKey;
    final String codeName;
    final dynamic codeDescription;
    final dynamic codeValue;
    final int sortOrder;
    final dynamic color;
    final dynamic interfaceValue;
    final dynamic symmetryValue;
    final bool isDefault;
    final dynamic userTypeCodeId;
    final double creditPreApprovedAmount;
    final double creditLimit;
    final double warnCreditLimitAmount;
    final double suspendCreditLimitAmount;
    final bool allowEdit;
    final dynamic companyTaxId;
    final dynamic glAccount;
    final double wageLimit;
    final double taxRate;
    final bool hideOnlineApp;

    Map<String, dynamic> setCollection() {
        Map<String, dynamic> col = {};
      //  col['id'] = id;
        col['codeId'] = codeId;
        col['codeKey'] = codeKey;
        col['codeName'] = codeName;
        if (codeDescription != 'NULL' && codeDescription != null) {
            col['codeDescription'] = codeDescription;
        }
        if (codeValue != 'NULL' && codeValue != null) {
            col['codeValue'] = codeValue;
        }
        col['sortOrder'] = sortOrder;
        if (color != 'NULL' && color != null) {
            col['color'] = color;
        }
        if (interfaceValue != 'NULL' && interfaceValue != null) {
            col['interfaceValue'] = interfaceValue;
        }
        col['isDefault'] = isDefault;
        if (userTypeCodeId != 'NULL' && userTypeCodeId != null) {
            col['userTypeCodeId'] = userTypeCodeId;
        }
        col['creditPreApprovedAmount'] =  creditPreApprovedAmount;
        col['creditLimit'] = creditLimit;
        col['warnCreditLimitAmount'] = warnCreditLimitAmount;
        col['suspendCreditLimitAmount'] = suspendCreditLimitAmount;
        col['allowEdit'] = allowEdit;
        if (companyTaxId != 'NULL' && companyTaxId != null) {
            col['companyTaxId'] = companyTaxId;
        }
        if (glAccount != 'NULL' && glAccount != null) {
            col['glAccount'] = glAccount;
        }
        col['wageLimit'] = wageLimit;
        col['taxRate'] = taxRate;
        col['hideOnlineApp'] = hideOnlineApp;
        return col;
    }

}