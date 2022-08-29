import 'package:beben_pos_desktop/bank/dialog_add_bank.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showCreateBank(context);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                            label: Text("Tambah Bank"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(color: Colors.white),
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 15,
                                bottom: 15,
                              ),
                              primary: Color(0xff3498db),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      dataTable(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dataTable() {
    // return PaginatedDataTable(columns: <DataColumn>, source: DataSourceCustomer)
    return Text("Data Bank");
  }

  _showCreateBank(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogAddBank();
        }).then((value) async {
      GlobalFunctions.logPrint("request Add Bank", '$value');
    });
  }
}
