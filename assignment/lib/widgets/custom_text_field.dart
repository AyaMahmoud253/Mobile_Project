
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String? hint;
    final valid;
    //final onSubmit;
    final controllerText;
    bool obsText;
    String? label;
    Widget? icon;
    final ValueChanged<String>? onChanged;
   CustomTextField({super.key,this.hint,this.valid,this.controllerText,required this.obsText,this.label,this.icon,this.onChanged,});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
                      controller: controllerText,
                      //onFieldSubmitted: onSubmit,
                      validator: valid,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(
                          color: Colors.grey,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text(label!),
                        suffixIcon: icon,
                      ),
                      obscureText: obsText,
                      obscuringCharacter:'*' ,
                      onChanged: onChanged,
                    ),
      ),
    );
  }
}