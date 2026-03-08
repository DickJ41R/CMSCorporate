import 'package:flutter/material.dart';

//ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({super.key,required this.text,
   required this.setState,required this.textInputFieldValues,
   required this.textEditingController, required this.inRules,
   required this.obscureText,required this.index,
   required this.textEditingControllers,
   required this.passwordVisible,
   required this.callback
  });
  final String text;
  final Function setState;
  final List<String>textInputFieldValues;
  final TextEditingController textEditingController;
  final List<dynamic>inRules;
  final bool obscureText;
  final int index;
  final List<TextEditingController> textEditingControllers;
  final bool passwordVisible;
  final Function callback;
// return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);

  bool? passwordVisibleLate;

  void initState() {
    passwordVisibleLate = passwordVisible;
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscureText ? true : false,
        obscuringCharacter: '*',
      decoration: InputDecoration(labelText: text,
        labelStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontFamily: 'AvenirLight'
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey,
                width: 1.0)
        ),
        suffixIcon: !text.toLowerCase().contains('password') ? null : IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
              obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            print('line 51: $passwordVisible');
              if (passwordVisibleLate == true) {
                passwordVisibleLate = false;
              } else {
                passwordVisibleLate = true;
              }
            callback(passwordVisibleLate,text);
          },
        ),

      ),
      style: const TextStyle(
        color: Colors.black
      ),
      validator: (String? value) {
        print('validataor called');
          List<dynamic>rls = inRules;
          switch (rls[0]) {
            case 0: {
            //email
            if (rls[1].hasMatch(value) ) {
              value = null;

            } else {
              value = 'Enter a valid email';
            }
            }
            print('lin 53 in text form field: $value');
              break;
            case 1:
              {
                if (value == null || value == '') {
                  value = 'Enter valid text.';
                } else {
                  value = null;
                }
              }
              break;
            case 2: {
              {
                if (value == null || value == '') {
                  value = 'Enter valid text.';
                } else {
                  value = null;
                }
              }
            }
              break;
            case 3: {
              if (value == null || value == '') {
              value = 'Enter a valid SSN term.';
              } else {
                int minLength = rls[1];
                int maxLength = rls[2];
                if (value.length < minLength ||
                    value.length > maxLength) {
                  value = 'Enter a text field containing from $minLength to $maxLength            characters.';
                } else {
                  value = null;
                }
              }
             }
              break;
            case 4: {
              //zip code
              if (rls[1].hasMatch(value) ) {
                value = null;
              } else {
                 value = 'Enter a valid zipcode.';
              }
            }
              break;
            case 5: {
              //password
              if (rls[1].hasMatch(value) ) {
                value = null;
              } else {
              //   value = 'Password must have a min of 8 chars; 1 uppercase, 1 lowercase, 1 numeric and 1 special character.';
                value = 'Invalid password format.';
              }
              }
              break;
            case 6:
              {
                if (value == null || value == '') {
                  value = 'Enter valid confirming password.';
                } else {
                  print('line 117: ${textEditingController.text},'
                      ' ${ textEditingControllers[index - 1].text}');
                  if (textEditingController.text !=
                      textEditingControllers[index - 1].text) {
                    value = "Your passwords do not match.";
                  } else {
                    value = null;
                  }
                }
              }
              break;
            default: {}
              break;
          }
      print('line 62 VALIDATOR: $value');
      return value;
    },
    // onChanged: (text) {
    //
    // },
    );
  }
}
