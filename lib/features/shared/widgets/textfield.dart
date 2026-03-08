import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
        required this.hint,
        required this.label,
        this.controller,
        this.isPassword = false});
  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          label: Text(label),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey, width: 1))),
    );
  }
}
// class CustomTextField extends StatelessWidget {
//   const CustomTextField({super.key, required this.controller,required this.hint, required this.label});
//
//   final String hint;
//   final String label;
//   final TextEditingController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
//       child: TextField(
//         decoration:  InputDecoration(
//           hintText: hint,
//             label: Text(label),
//             border: InputBorder.none,
//             fillColor: AppColors.primaryColor,
//             filled: true),
//         style: const TextStyle(fontSize: 50),
//         readOnly: true,
//         autofocus: true,
//         showCursor: true,
//       ),
//     );
//   }
// }