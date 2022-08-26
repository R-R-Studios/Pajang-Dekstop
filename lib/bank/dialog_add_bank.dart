import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DialogAddBank extends StatefulWidget {
  const DialogAddBank({Key? key}) : super(key: key);

  @override
  State<DialogAddBank> createState() => _DialogAddBankState();
}

var _formKey = GlobalKey<FormState>();
TextEditingController _bankNameController = TextEditingController();
TextEditingController _bankOwnerController = TextEditingController();
TextEditingController _bankRekeningController = TextEditingController();

class _DialogAddBankState extends State<DialogAddBank> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: 500,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tambah Bank"),
            IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: Icon(
                Icons.close,
              ),
              tooltip: "Tutup",
              padding: EdgeInsets.all(0),
            )
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Text("Nama Bank"),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Nama Bank",
                              border: OutlineInputBorder(),
                            ),
                            controller: _bankNameController,
                            enabled: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Masukkan nama bank";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Text("Pemilik Rekening"),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Pemilik Rekening",
                              border: OutlineInputBorder(),
                            ),
                            controller: _bankOwnerController,
                            enabled: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Masukkan pemilik rekening";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Text("Nomor Rekening"),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Nomor Rekening",
                              border: OutlineInputBorder(),
                            ),
                            controller: _bankRekeningController,
                            enabled: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Masukkan nomor rekening";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Simpan"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
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
        ),
      ),
    );
  }
}
