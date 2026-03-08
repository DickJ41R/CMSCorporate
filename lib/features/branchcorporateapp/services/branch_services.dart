//

//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchServices {
  final int? branchId;
  final String? branchName;

  BranchServices({this.branchId, this.branchName});

  // BranchServices copyWith({dynamic branchId, String? branchName}) {
  //   return BranchServices(branchId: ?? branchId : this.xxx,
  //       branchName: ?? branchName : this.branchName);
  // }

  Future<List<dynamic>> getBranches(List<int> branchIds) async {
    print('line 28 getbranches: $branchIds');
    try {
      List<Map<String, dynamic>> branches = [];
      await FirebaseFirestore.instance
          .collection('CMSBranch')
          .where("branchId", whereIn: branchIds)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          branches.add(obj);
        }
      });
      if (branches.length != branchIds.length) {
        int i = 0;
        while (i < branches.length) {
          int id = branches[i]['branchId'];
          if (!branchIds.contains(id)) {
            branches.removeAt(i);
            i = 0;
            continue;
          }
          i += 1;
        }
      }
      print('line 33 $branches');
      return branches;
    } catch (e) {
      print('line 38 error: $e');
      throw Exception(e);
    }
  }
}
