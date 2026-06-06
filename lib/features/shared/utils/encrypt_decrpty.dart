
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show debugPrint;
class EncryptData {

  static String cryptoData(String data, String keyStr) {
    debugPrint('line 16 cryptofile');
    late final Key key;
    late final IV iv;
    key = Key.fromUtf8(keyStr);
    iv = IV.fromUtf8(utf8.decode((keyStr).codeUnits));
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  static String decryptData(String data,String keyStr) {
 //   debugPrint('line 28 decrpt');
    late final Key key;
    late final IV iv;
    key = Key.fromUtf8(keyStr);
    iv = IV.fromUtf8(utf8.decode((keyStr).codeUnits));
    final encrypter = Encrypter(AES(key, padding: null));
    final decrypted = encrypter.decrypt(Encrypted.from64(data), iv: iv);
    return decrypted;
  }
}
// class EncryptData{
// //for AES Algorithms
//
//   static Encrypted? encrypted;
//   static var decrypted;
//
//   static List<dynamic>showResults(dynamic da01,dynamic da02,dynamic da03,
//       dynamic da04,dynamic da05) {
//     debugPrint('line 14 in show results: $da05');
//     // debugPrint('line 15 $da03 $da04');
//     // debugPrint('line 16: $da05');
//    // final plainText = 'YXDEQM5kZh4NcQJ4@';
//   // final key = Key.fromUtf8('thesunsetwillnotebetomorrownight');
//   //final key = Key.fromUtf8(da05);
//  // debugPrint('line 20: ${key.base64}');
//   //   final iv = IV.fromLength(16);
//   //   debugPrint('line 22 $iv');
//   //   Encrypter encrypter = Encrypter(AES(key));
//   //  // final encrypted = encrypter.encrypt(da04, iv: iv);
//   //   debugPrint('line 25 $encrypter');
//   //   String soccer = encrypter.decrypt(da04, iv: iv);
//   //   debugPrint('line 27: $soccer');
//   //   final key1 = Key.fromUtf8(soccer);
//   //   Encrypter encrypter1 = Encrypter(AES(key1));
//   //   final dynamic baseball = encrypter1.decrypt(da01, iv: iv);
//   //   final dynamic football = encrypter1.decrypt(da02, iv: iv);
//   //   final dynamic basketball =  encrypter1.decrypt(da03, iv: iv);
//   //   final dynamic jsonBasketball = jsonDecode(basketball);
//    final dynamic encryptedSoccer = decryptAES(da04, da05);
//
//     debugPrint('line 33 $encryptedSoccer');
//   //  List<dynamic> dnl = [football,baseball,jsonBasketball];
//     return [encryptedSoccer];
//   }
//   static dynamic encryptAES(String plainText,String keyStr){
//     final key = Key.fromUtf8(keyStr);
//     final iv = IV.fromUtf8(keyStr);
//     final encrypter = Encrypter(AES(key));
//     encrypted = encrypter.encrypt(plainText, iv: iv);
//     debugPrint('line 45 ${encrypted!.base64}');
//     return encrypted;
//     }
//
//   static dynamic decryptAES(String enc, String keyStr){
//     final key = Key.fromUtf8(keyStr);
//     debugPrint('line 51 decrupt: $key $keyStr');
//     final iv = IV.fromLength(16);
//     debugPrint('line 53 decrupt: $iv');
//     final encrypter = Encrypter(AES(key));
//     debugPrint('line  55: $encrypter $enc');
//
//     final  decrypted =  encrypter.decrypt(Encrypted.fromUtf8(enc),iv:iv);
//     debugPrint('line 57: $decrypted');
//     return decrypted;
//   }
//   static String cryptoData(String data, keyStr) {
//     late final Key key;
//     late final IV iv;
//     key = Key.fromUtf8(keyStr ?? '');
//     iv = IV.fromUtf8(utf8.decode((keyStr ?? '').codeUnits));
//     final encrypter = Encrypter(AES(keyStr, padding: null));
//     final encrypted = encrypter.encrypt(data, iv: iv);
//     return encrypted.base64;
//   }
//   static String decryptData(String data, keyStr) {
//     late final Key key;
//     late final IV iv;
//     key = Key.fromUtf8(keyStr ?? '');
//     iv = IV.fromUtf8(utf8.decode((keyStr ?? '').codeUnits));
//     final encrypter = Encrypter(AES(key, padding: null));
//     final decrypted = encrypter.decrypt(Encrypted.from64(data), iv: iv);
//     return decrypted;
//   }
// }
//
