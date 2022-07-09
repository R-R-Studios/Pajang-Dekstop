
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/head_column_model.dart';
import 'model/customer_model.dart';
import 'widget/body_customer.dart';
import 'widget/header_customer.dart';

class MenuCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuCustomer();
}

class _MenuCustomer extends State<MenuCustomer> {
  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "ID", ischecked: false),
    HeadColumnModel(key: "2", name: "First Name", ischecked: false),
    HeadColumnModel(key: "3", name: "Last Name", ischecked: false),
    HeadColumnModel(key: "4", name: "Email", ischecked: false),
    HeadColumnModel(key: "5", name: "Phone Number", ischecked: false),
    HeadColumnModel(key: "6", name: "Total Spent", ischecked: false),
  ];
  List<String> _exportMap = ["JSON", "XML", "CSV", "TXT", "SQL", "MS-EXCEL", "PDF"];
  
  List<CustomerModel> _customerModel = [
    CustomerModel(id: "1", firstName: "Odon 1", lastName: "Kalapuna 9", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20001"),
    CustomerModel(id: "2", firstName: "Odon 2", lastName: "Kalapuna 4", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20002"),
    CustomerModel(id: "3", firstName: "Odon 3", lastName: "Kalapuna 7", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20003"),
    CustomerModel(id: "4", firstName: "Odon 4", lastName: "Kalapuna 6", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20004"),
    CustomerModel(id: "5", firstName: "Odon 5", lastName: "Kalapuna 2", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20005"),
    CustomerModel(id: "6", firstName: "Odon 6", lastName: "Kalapuna 1", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20009"),
    CustomerModel(id: "7", firstName: "Odon 7", lastName: "Kalapuna 3", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20008"),
    CustomerModel(id: "8", firstName: "Odon 8", lastName: "Kalapuna 5", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20007"),
    CustomerModel(id: "9", firstName: "Odon 9", lastName: "Kalapuna 8", email: "odonkalapuna@gmail.com", phoneNumber: "081312465791", totalSpent: "20006")
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderCustomer(_headColumnModel, _exportMap),
                  BodyCustomer(_customerModel, _headColumnModel)
                ]
            )
        )
    );
  }
}
