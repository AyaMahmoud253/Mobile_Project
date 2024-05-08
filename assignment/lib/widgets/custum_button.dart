import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   CustomButton({super.key,required this.text, this.onPressed});

  final String text;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 350,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white,),
          ),
        ),
      ),
    );;
  }
}