import 'package:beben_pos_desktop/sales/model/bank.dart';
import 'package:beben_pos_desktop/sales/model/payment_method.dart';
import 'package:beben_pos_desktop/sales/provider/sales_provider.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';

class DialogTransaction extends StatefulWidget {

  final PaymentMethod paymentMethod;
  final int totalProduct;
  final double totalQuantity;
  final double totalAmount;
  final double totalTax;
  final double subTotal;

  const DialogTransaction({ 
    required this.paymentMethod,
    required this.totalProduct,
    required this.totalQuantity,
    required this.totalAmount,
    required this.totalTax,
    required this.subTotal,
    Key? key 
  }) : super(key: key);

  @override
  State<DialogTransaction> createState() => _DialogTransactionState();
}

class _DialogTransactionState extends State<DialogTransaction> {

  final TextEditingController accountNumberController = TextEditingController();
  double totalPayment = 0;
  double totalChange = 0;

  Bank? bank;
  List<Bank> listBank = [];
  late PaymentMethod paymentMethod;

  @override
  void initState() {
    super.initState();
    getBank();
  }

  getBank() async {
    listBank = await SalesProvider.bank();
    setState(() {
      
    });
  }

  setBank(Bank value){
    setState(() {
      bank = value;
    });
  }

  sumTotal(double value) async {
    totalPayment = value;
    totalChange = totalPayment - widget.totalAmount;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.35,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Masukan Pembayaran",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: "Close",
                  icon: Icon(Icons.close),
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Jumlah ${widget.totalProduct} Produk"),
                    Text("${widget.totalQuantity} Qty"),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Pajak",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("${Core.converNumeric(widget.totalTax.toString())}"),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("${Core.converNumeric(widget.subTotal.toString())}"),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Belanja",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("${Core.converNumeric(widget.totalAmount.toString())}"),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Metode Pembayaran",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(widget.paymentMethod.name ?? ""),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Bayar",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("${Core.converNumeric(totalPayment.toString())}"),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Kembalian",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("${Core.converNumeric(totalChange.toString())}"),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                form()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget form () {
    FocusNode dialogSaveFocus = FocusNode();
    if (widget.paymentMethod.name?.toLowerCase() == "tunai") {
      return Column(
        children: [
          TextFormField(
            onChanged: (value) {
              sumTotal(double.parse(value));
            },
            autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 14, height: 1),
            onFieldSubmitted: (String value) {
              dialogSaveFocus.requestFocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon isi pembayaran terlebih dahulu';
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
            ],
            decoration: new InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              prefixIcon: Icon(
                Icons.shopping_cart,
                color: Colors.lightBlue[800],
              ),
              contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: 'Total Bayar',
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(shadowColor: Colors.grey),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 12,
                  height: 30,
                  child: Center(
                    child: Text(
                      "Batal",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              ElevatedButton(
                focusNode: dialogSaveFocus,
                onPressed: () async {
                  if (totalPayment < widget.totalAmount) {
                    double minus = (widget.totalAmount - totalPayment).toDouble();
                    GlobalFunctions.showSnackBarWarning("Uang Customer Kurang ${Core.converNumeric("$minus")}");
                  } else {
                    Navigator.of(context).pop(widget.paymentMethod);
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 12,
                  height: 30,
                  child: Center(
                    child: Text(
                      "Simpan",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Bank",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 200,),
              Flexible(
                child: DropdownButton<Bank>(
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  value: bank,
                  underline: const SizedBox(),
                  hint: Text(
                    'Pilih Bank',
                  ),
                  items: listBank.map((Bank data) {
                    return DropdownMenuItem(
                      value: data,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          data.name ?? '',
                          style: const TextStyle(fontSize: 14, ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setBank(newValue!);
                  } 
                )
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: accountNumberController,
            autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 14, height: 1),
            onFieldSubmitted: (String value) {
              dialogSaveFocus.requestFocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon isi terlebih dahulu';
              }
              return null;
            },
            inputFormatters: [
              // FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
            ],
            decoration: new InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              prefixIcon: Icon(
                Icons.credit_card_rounded,
                color: Colors.lightBlue[800],
              ),
              contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: 'No Kartu / No Rekening',
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(shadowColor: Colors.grey),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 12,
                  height: 30,
                  child: Center(
                    child: Text(
                      "Batal",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              ElevatedButton(
                focusNode: dialogSaveFocus,
                onPressed: () async {
                  if (bank == null) {
                    GlobalFunctions.showSnackBarWarning("Pilih Bank terlebih dahulu");
                  } else if (accountNumberController.text.isEmpty) {
                    GlobalFunctions.showSnackBarWarning("Masukan no kartu kredit");
                  } else {
                    paymentMethod = widget.paymentMethod;
                    paymentMethod.cardNumber = accountNumberController.text;
                    paymentMethod.bankId = bank?.id;
                    Navigator.of(context).pop(paymentMethod);
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 12,
                  height: 30,
                  child: Center(
                    child: Text(
                      "Simpan",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

}