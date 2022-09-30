import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:flutter/material.dart';

class ShiftView extends StatelessWidget {

  final VoidCallback callback;

  const ShiftView({ required this.callback, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constant.paddingScreen,
      child: ListView(
        children: [
          const SizedBox(height: 20,),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: callback,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 16.0,
                ),
                label: Text("Back"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                  primary: Color(0xff3498db)
                ),
              ),
            ],
          ),
        ]
      )
    );
                  
  }
}