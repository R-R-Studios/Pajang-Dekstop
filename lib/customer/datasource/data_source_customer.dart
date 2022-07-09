import 'package:beben_pos_desktop/customer/widget/dialog_form_update_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/customer_model.dart';

class DataSourceCustomer extends DataTableSource {
  DataSourceCustomer(this.context, List<CustomerModel> customerModel) {
    _rows = customerModel;
  }

  final BuildContext context;
  List<CustomerModel> _rows = [];

  int _selectedCount = 0;

  var _formKey = GlobalKey<FormState>();

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(row.id!)),
        DataCell(Text(row.firstName!)),
        DataCell(Text(row.lastName!)),
        DataCell(Text(row.email!)),
        DataCell(Text(row.phoneNumber!)),
        DataCell(Text(row.totalSpent!)),
        DataCell(IconButton(
          tooltip: "Send SMS to ${row.firstName}",
          icon: Icon(Icons.sms_outlined),
          color: Colors.blue,
          onPressed: () {
            _showSendSms(row);
          },
        )),
        DataCell(IconButton(
          tooltip: "Update Customer ${row.firstName}",
          icon: Icon(Icons.edit_outlined),
          color: Colors.blue,
          onPressed: () {
            showDialog(context: context, builder: (BuildContext c){
              return DialogFormUpdateCustomer();
            });
          },
        )),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _showSendSms(CustomerModel customer) {
    showDialog(
        context: context,
        builder: (BuildContext mContext){
          return AlertDialog(
              title: Container(
                width: 500,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Send SMS"),
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        tooltip: "Close",
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.close))
                  ],
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              width: 200,
                              child: Text("First name"),
                            ),
                            Container(
                              width: 300,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: customer.firstName,
                                enabled: false,
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
                              child: Text("Last Name"),
                            ),
                            Container(
                              width: 300,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue: customer.lastName,
                                enabled: false,
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
                              child: Text("Phone Number*"),
                              width: 200,
                            ),
                            Container(
                              width: 300,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number*',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  initialValue: customer.phoneNumber,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Phone number is required";
                                    }
                                  }
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
                              child: Text("Message"),
                              width: 200,
                            ),
                            Container(
                              width: 300,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Message',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: 5,
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
                            if(form != null && form.validate()){
                              form.save();

                            }else{
                              SnackBar(
                                content: Text("Phone Number is required"),
                              );
                            }
                          },
                          child: Text(
                              "Submit"
                          ),
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
              )
          );
        });
  }

}