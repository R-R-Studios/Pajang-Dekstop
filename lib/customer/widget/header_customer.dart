import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:flutter/material.dart';

class HeaderCustomer extends StatefulWidget {

  final List<HeadColumnModel> checkboxModel;
  final List<String> exportMap;
  HeaderCustomer(this.checkboxModel, this.exportMap);

  @override
  _HeaderCustomerState createState() => _HeaderCustomerState();
  
}

class _HeaderCustomerState extends State<HeaderCustomer> {

  late List<HeadColumnModel> _checkboxModel = widget.checkboxModel;
  late List<String> _exportMap = widget.exportMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(right: 5, left: 5),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    label: Text("New Customer"),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        primary: Color(0xff3498db),
                    textStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    label: Text("Import"),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        primary: Color(0xff3498db),
                        textStyle: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, right: 5, left: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Delete & Email
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        label: Text("Delete"),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 15),
                            primary: Color(0xff3498db),
                            textStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        label: Text("Email"),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 15),
                            primary: Color(0xff3498db),
                            textStyle: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                          width: 200,
                          child: TextField(
                            style: TextStyle(
                                fontSize: 14, color: Colors.blue),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Search"),
                          )
                      ),
                    ),
                    PopupMenuButton(
                      tooltip: "Filter Field",
                      icon: Icon(Icons.grid_view_sharp),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        for(final model in _checkboxModel)
                          PopupMenuItem(
                            child: StatefulBuilder(
                              builder: (_context, _setState) =>
                                  CheckboxListTile(
                                    activeColor: Colors.black,
                                    value: model.ischecked,
                                    onChanged: (value) {
                                      _setState((){
                                        model.ischecked = value!;
                                      });
                                    },
                                    title: Text(model.name!),
                                  ),
                            ),
                          ),
                      ],
                    ),
                    PopupMenuButton(
                      tooltip: "Export Data",
                      icon: Icon(Icons.file_upload_sharp),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        for(final export in _exportMap)
                          PopupMenuItem(
                            child: StatefulBuilder(
                              builder: (_context, _setState) =>
                                  ListTile(
                                    title: Text(export, style: TextStyle(fontSize: 14)),
                                    onTap: (){
                                      _setState((){

                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}