

class CMSSpeciality {

   const CMSSpeciality({
   //   required this.id,
      required this.specialtyId,
      required this.specialtyName,
      required this.specialtyDescription,
      required this.hideOnlineApp
   });

 //  final ObjectId id;
   final int specialtyId;
   final String specialtyName;
   final String specialtyDescription;
   final bool hideOnlineApp;
}