import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ShiftWidget extends StatelessWidget {
  ShiftWidget({required this.model,required this.screenWidth,
    required this.textEditingController
  }); // if you decide to not make a model class, you would pass each value individually

  final Map<String,dynamic> model;
  final double screenWidth;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    // obviously this can be any widget you want
    debugPrint('line 16: $model');
    return Container(
      padding:EdgeInsets.fromLTRB(3, 0, 0, 0),
      height:92,
      width: 184,
        decoration: BoxDecoration(
       color: Colors.grey[200],
        border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(12)
      ),
        child: Column(
            children: [
              Container(
                height:24,
                width: 128,
                child: Text(model['shiftName'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                height: 24,
                width: 128,
                child: Text(model['shiftTime'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 14,

                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height:32,
                width:128,
                child: TextFormField(
                  controller: textEditingController,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged:  ( (text) {
                    textEditingController.text = text;
                  }),
                  readOnly: false,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  decoration: InputDecoration(
                    // hintText: "Discipline Count",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade200,
                    ),
                    labelText: "#of " + model['disciplineName'],
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),

                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
        ),
    );

  }
}