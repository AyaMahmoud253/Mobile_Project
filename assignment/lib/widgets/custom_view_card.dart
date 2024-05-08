

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
   CustomCard({super.key,this.title,this.subTitle});
  String? title;
  String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        child: Card(
          //color: Color.fromARGB(255, 165, 198, 213),
          shadowColor: Colors.grey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 5,),
              Text(subTitle!,
              style: TextStyle(
                fontSize: 14,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}