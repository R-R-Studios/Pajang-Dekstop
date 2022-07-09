import 'package:beben_pos_desktop/model/navigation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuCommingSoon extends StatelessWidget {
  final NavigationModel _navigationModel;

  MenuCommingSoon(this._navigationModel);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Image.asset(
              _navigationModel.icon ?? "",
              height: 60,
              width: 60,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("${_navigationModel.name} is Comming soon"),
          ),
        ],
      ),
    );
  }
}
