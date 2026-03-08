
class CredentialCode {
  const CredentialCode({
  //  required this.id,
    required this.credentialId,
    required this.credentialDescription,
    required this.credentialCodeId,
    required this.credentialCodePC,
    required this.credentialAddA,
    required this.credentialAQD,
    required this.credentialCodeA,
    required this.credentialCodeL,
    required this.credentialCodeU,
    required this.credentialCodeV,
    required this.credentialExpired,
    required this.credentialHasL,
    required this.credentialHours,
    required this.credentialOver,
    required this.credentialOverL,
    required this.credentialScoreP,
    required this.credentialSponsor,
    required this.credentialSystemR,
    required this.credentialTitle,
    required this.credentialType,
    required this.NTTestId,
    required this.nurseTest,
    required this.NTNurseType,
    required this.byPassTrigger,
    required this.hasDisciplines,
    required this.hasSpecialties,
    required this.hasClients,
    required this.hideRegistryPortal,
    required this.hideOnlineApplication,
    required this.noNotifications,
    required this.assessmentType,
    required this.jobCategoryId,
    required this.credentialRegistrantPassFail,
    required this.FSMLinked,
    required this.testingPicCodeId,
    required this.requestDocuments,
    required this.isDisabled
  });
 // final ObjectId id;
  final String credentialId;
  final String? credentialDescription;
  final String? credentialCodeId;
  final bool credentialCodePC;
  final bool credentialAddA;
  final String? credentialAQD;
  final String? credentialCodeA;
  final bool credentialCodeL;
  final String? credentialCodeU;
  final bool credentialCodeV;
  final String? credentialExpired;
  final String? credentialHasL;
  final bool credentialHours;
  final String? credentialOver;
  final String? credentialOverL;
  final double credentialScoreP;
  final String? credentialSponsor;
  final bool credentialSystemR;
  final String? credentialTitle;
  final String? credentialType;
  final int NTTestId;
  final int nurseTest;
  final bool NTNurseType;
  final int byPassTrigger;
  final bool hasDisciplines;
  final bool hasSpecialties;
  final bool hasClients;
  final bool hideRegistryPortal;
  final bool hideOnlineApplication;
  final String? noNotifications;
  final String? assessmentType;
  final String? jobCategoryId;
  final bool credentialRegistrantPassFail;
  final String? FSMLinked;
  final String? testingPicCodeId;
  final bool requestDocuments;
  final bool isDisabled;

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    col['credentialId'] = credentialId;
    col['credentialDescription'] = credentialDescription;
    col['credentialCodeId'] = credentialCodeId;
    col['credentialCodePC'] = credentialCodeId;
    col['credentialAddA'] = credentialAddA;

    if (credentialAQD != '' && credentialAQD != null) {
      col['credentialAQD'] = credentialAQD;
    }
    if (credentialCodeA != '' && credentialCodeA  != null) {
      col['credentialCodeA '] = credentialCodeA;
    }
    col['credentialCodeL'] = credentialCodeL;

    if (credentialCodeU != '' && credentialCodeU != null) {
      col['credentialCodeU'] = credentialCodeU;
    }
    col[' credentialCodeV'] = credentialCodeV;

    if (credentialExpired != '' && credentialExpired != null) {
      col['credentialExpired'] = credentialExpired;
    }
    if (credentialHasL != '' && credentialHasL != null) {
      col['credentialHasL'] = credentialHasL;
    }
    col['credentialHours'] =  credentialHours;

    if ( credentialOver != '' &&  credentialOver != null) {
      col['credentialOver'] =  credentialOver;
    }
    if ( credentialOverL != '' &&   credentialOverL != null) {
      col['credentialOverL'] = credentialOverL;
    }

    col['credentialScoreP'] =  credentialScoreP;

    if (credentialSponsor != '' &&  credentialSponsor != null) {
      col['credentialSponsor'] = credentialSponsor;
    }
    col['credentialSystemR'] =credentialSystemR;

    if ( credentialTitle != '' &&   credentialTitle != null) {
      col[' credentialTitle'] =  credentialTitle;
    }

    col['credentialType'] = credentialType;

    col['NTTestId'] = NTTestId;

    col['nurseTest'] = nurseTest;

    col['NTNurseType'] = NTNurseType;

    col['NTNurseType'] = NTNurseType;

    col['hasDisciplines'] = hasDisciplines;

    col['hasSpecialties'] = hasSpecialties;

    col['hasClients'] = hasClients;

    col['hideRegistryPortal'] = hideRegistryPortal;

    col['hideRegistryPortal'] = hideRegistryPortal;

    if (hideRegistryPortal != '') {
      col['hideRegistryPortal'] = hideRegistryPortal;
    }

    if (assessmentType != '' && assessmentType != null) {
      col['assessmentType'] = assessmentType;
    }

    if (jobCategoryId != '' && jobCategoryId != null) {
      col['jobCategoryId'] = jobCategoryId;
    }

    col['credentialRegistrantPassFail;'] = credentialRegistrantPassFail;

    if (FSMLinked != '' && FSMLinked != null) {
      col['FSMLinked'] = FSMLinked;
    }
    if (testingPicCodeId != '' && testingPicCodeId != null) {
      col['testingPicCodeId'] = testingPicCodeId;
    }

    col['requestDocuments'] = requestDocuments;

    col['isDisabled'] = isDisabled;

    return col;
  }

}