// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:jewelerybroker/config/styles.dart';

// class DefaultTextField extends StatelessWidget {
//   final String title;
//   final Function? validateField;
//   final TextEditingController controller;
//   final bool hidden;
//   String? response;
//   String? Validate(String? value) {
//     return response!;
//   }

//   DefaultTextField(
//       {required this.title,
//       required this.validateField,
//       required this.hidden,
//       required this.controller});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
//       child: TextFormField(
//         textAlignVertical: TextAlignVertical.center,
//         controller: controller,
//         validator: (value) => validateField!(controller.text),
//         enableInteractiveSelection: true,
//         style: kInputStyle,
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         obscureText: hidden,
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
//           helperStyle: kInputHintStyle,
//           errorStyle: GoogleFonts.mulish(
//             color: Colors.red,
//             fontSize: 13.5,
//             fontWeight: FontWeight.w500,
//           ),
//           hintStyle: kInputHintStyle,
//           labelText: title,
//           labelStyle: kInputHintStyle,
//           fillColor: Color(0xFFEFEFEF),
//           filled: true,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: BorderSide(color: Colors.black87, width: 1),
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: BorderSide(color: Colors.black87, width: 1),
//           ),
//         ),
//       ),
//     );
//   }
// }
