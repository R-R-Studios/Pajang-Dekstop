import 'package:beben_pos_desktop/customer/model/customer_model.dart';
import 'package:flutter/material.dart';

class DialogFormUpdateCustomer extends StatefulWidget {
  final CustomerModel _customerModel = CustomerModel();
  DialogFormUpdateCustomer({Key? key}) : super(key: key);

  @override
  _DialogFormUpdateCustomerState createState() =>
      _DialogFormUpdateCustomerState();
}

class _DialogFormUpdateCustomerState extends State<DialogFormUpdateCustomer> {
  var _formKey = GlobalKey<FormState>();
  bool _isConcentRegistration = false;
  late int _rbValue = widget._customerModel.gender;
  @override
  Widget build(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
        title: Container(
          width: 500,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Update Customer"),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: "Close",
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close))
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          width: 200,
                          child: Text("Registration Consent*"),
                        ),
                        Container(
                          width: 30,
                          child: Center(
                            child: CheckboxListTile(
                              onChanged: (bool? value) {
                                setState(() {
                                  _isConcentRegistration = value!;
                                });
                              },
                              value: _isConcentRegistration,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          width: 200,
                          child: Text("First name*"),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First Name*',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget._customerModel.firstName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "First Name is required";
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          width: 200,
                          child: Text("Last Name*"),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last Name*',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget._customerModel.lastName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Last Name is required";
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          child: Text("Gender"),
                          width: 200,
                        ),
                        Container(
                          width: 300,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rbValue = 1;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: _rbValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _rbValue = 1;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Male',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rbValue = 2;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio(
                                        value: 2,
                                        groupValue: _rbValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _rbValue = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Female',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        var form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          form.save();
                        } else {
                          SnackBar(
                            content: Text("Phone Number is required"),
                          );
                        }
                      },
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(color: Colors.white),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 15),
                          primary: Color(0xff3498db)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
    return alertDialog;
  }
}
