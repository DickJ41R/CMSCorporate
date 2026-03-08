

class HCProfessional{
  const HCProfessional({
        // required this.id,   //_id
        // required this.mongodbId,  //from User
        required this.hcpId, //1
        required this.hcpEEId, //2
        required this.status, //3
        required this.branchName, //4
        required this.branchState, //5
        required this.lastname, //6
        required this.firstname, //7
        required this.middlename, //8
        required this.socialSecurityNumber, //9
        required this.disciplineName, //10
        required this.firstWorkDate, //11
        required this.lastWorkDate, //12
        required this.nickname, //13
        required this.gender, //14
        required this.disability, //15
        required this.birthDate, //16
        required this.hireDate, //17
        required this.ethnicity, //18
        required this.veteranType, //19
        required this.eeoMaritalStatus, //20
        required this.referralSourceType, //21
        required this.legalName, //22
        required this.workerType, //24
        required this.statusChangedDate, //25
        required this.createdDate,
        required this.branchId}); //25

  // final ObjectId id;
  // final ObjectId mongodbId;  //from user
  final int hcpId; //1
  final String hcpEEId; //2
  final String status; //3
  final String branchName; //4
  final String branchState; //5
  final String lastname; //6
  final String firstname; //7
  final String middlename; //8
  final String socialSecurityNumber; //9
  final String disciplineName; //10
  final DateTime? firstWorkDate; //11
  final DateTime? lastWorkDate; //12
  final String? nickname; //13
  final String gender; //14
  final String? disability; //15
  final DateTime? birthDate; //16
  final DateTime? hireDate; //17
  final String ethnicity; //18
  final String? veteranType; //19
  final String? eeoMaritalStatus; //20
  final String? referralSourceType; //21
  final String legalName; //22
  final String workerType; //23
  final DateTime? statusChangedDate; //24
  final DateTime? createdDate; //25
  final int branchId;

  Map<String, dynamic> setCollection() {
    int? il = 0;
    Map<String, dynamic> col = {};
      // col['id'] = id;
      // col['mongodbId'] = mongodbId;
      col['hcpId'] = il;
    if (hcpEEId != '') {
      //2
      col['hcpEEId'] = hcpEEId;
    }
    if (status != '') {
      //3
      col['status'] = status;
    }
    if (branchName != '') {
      //4
      col['branchName'] = branchName;
    }
    if (branchState != '') {
      //5
      col['branchState'] = branchState;
    }
    if (lastname != '') {
      //6
      col['lastname'] = lastname;
    }
    if (firstname != '') {
      //7
      col['firstname'] = firstname;
    }
    if (middlename != '') {
      //8
      col['middlename'] = middlename;
    }
    if (socialSecurityNumber != '') {
      //9
      col['socialSecurityNumber'] = socialSecurityNumber;
    }
    if (disciplineName != '') {
      //10
      col['disciplineName'] = disciplineName;
    }
    if (firstWorkDate != null) {
      //11
      col['firstWorkDate'] = firstWorkDate;
    }
    if (lastWorkDate != null) {
      //12
      col['lastWorKDate'] = lastWorkDate;
    }
    if (nickname != '') {
      //13
      col['nickname'] = nickname;
    }
    if (gender != '') {
      //14
      col['gender'] = gender;
    }
    if (disability != '') {
      //15
      col['disability'] = disability;
    }
    if (birthDate != null) {
      //16
      col['birthDate'] = birthDate;
    }
    if (hireDate != null) {
      //17
      col['hireDate'] = hireDate;
    }
    if (ethnicity != '') {
      //18
      col['ethnicity'] = ethnicity;
    }
    if (veteranType != '') {
      //19
      col['veteranType'] = veteranType;
    }
    if (eeoMaritalStatus != '') {
      //20
      col['eeoMaritalStatus'] = eeoMaritalStatus;
    }
    if (referralSourceType != '') {
      //21
      col['referralSourceType'] = referralSourceType;
    }
    if (legalName != '') {
      //22
      col['legalName'] = legalName;
    }
    if (workerType != '') {
      //23
      col['workerType'] = workerType;
    }
    if (statusChangedDate != null) {
      //24
      col['statusChangedDate'] = statusChangedDate;
    }
    if (createdDate != null) {
      //25
      col['createdDate'] = createdDate;
    }
    col['branchId'] = branchId;
    return col;
  }
}
