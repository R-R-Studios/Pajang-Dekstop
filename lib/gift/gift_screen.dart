
import 'package:flutter/material.dart';
import 'gift_data_source.dart';
import 'gift_model.dart';

class GiftScreen extends StatefulWidget {
  const GiftScreen({Key? key}) : super(key: key);

  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  List<String> _exportMap = ["JSON", "XML", "CSV", "TXT", "SQL", "MS-EXCEL", "PDF"];
  String selectedExport = "";

  List<GiftCheckboxModel> _giftCheckboxModel = [
    GiftCheckboxModel(id: 1, name: "Id", ischecked: false),
    GiftCheckboxModel(id: 2, name: "Last Name", ischecked: false),
    GiftCheckboxModel(id: 3, name: "First Name", ischecked: false),
    GiftCheckboxModel(id: 4, name: "Gift card Number", ischecked: false),
    GiftCheckboxModel(id: 5, name: "Value", ischecked: false),
  ];

  List<GiftModel> headerColumns = [];
  List<GiftModel> giftModels = [
    GiftModel(id: 1, firstName: "Andaru 1", lastName: "Munandar", giftCardNumber: "293888293", value: 1),
    GiftModel(id: 2, firstName: "Andaru 2", lastName: "Munandar", giftCardNumber: "293888293", value: 1),
    GiftModel(id: 3, firstName: "Andaru 3", lastName: "Munandar", giftCardNumber: "293888293", value: 1),
    GiftModel(id: 4, firstName: "Andaru 4 ", lastName: "Munandar", giftCardNumber: "293888293", value: 1),
  ];

  List<bool> checked = [true, true, false, false, true];

  Widget btnNewGiftCard() => Container(
    child: ElevatedButton.icon(
      icon: Icon(
        Icons.favorite,
        color: Colors.white,
        size: 18.0,
      ),
      label: Text(
        'New Gift Card',
        style: TextStyle(fontSize: 12),
      ),
      onPressed: () {
        print('Pressed');
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlue,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(2.0),
        ),
      ),
    ),
  );

  Widget btnAction() => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey,
                    size: 18.0,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    print('Pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(2.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 250,
                margin: EdgeInsets.only(left: 8),
                child: TextFormField(
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, height: 1),
                  decoration: new InputDecoration(
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(18, 18.0, 18, 18.0),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Start typing customer details..',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: PopupMenuButton(
                  tooltip: "Filter Field",
                  icon: Icon(Icons.grid_view_sharp),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    for(final model in _giftCheckboxModel)
                      PopupMenuItem(
                        child: StatefulBuilder(
                          builder: (_context, _setState) =>
                              CheckboxListTile(
                                activeColor: Colors.black,
                                value: model.ischecked,
                                onChanged: (value) {
                                  setState(() {
                                    model.ischecked = value!;
                                  });
                                },
                                title: Text(model.name!, style: TextStyle(fontSize: 12),),
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: PopupMenuButton(
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
                                  Navigator.pop(context);
                                },
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    child: btnNewGiftCard()),
              ),
              SizedBox(height: 12,),
              btnAction(),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10),
                  child: PaginatedDataTable(
                    rowsPerPage: 4,
                    columns: <DataColumn>[
                      for(final header in _giftCheckboxModel)
                        DataColumn(label: Text(header.name!)),
                    ], source: GiftDataSource(context, giftModels),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
