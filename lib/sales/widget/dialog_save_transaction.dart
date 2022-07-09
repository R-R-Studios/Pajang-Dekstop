
import 'package:beben_pos_desktop/sales/bloc/sales_bloc.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogSaveTransaction extends StatefulWidget {
  static final _formKey = new GlobalKey<FormState>();

  const DialogSaveTransaction(this.typeSaveTransaction ,this.salesBloc, this.totalTransactionPrice, {Key? key}) : super(key: key);

  final dynamic salesBloc;
  final double totalTransactionPrice;
  final String typeSaveTransaction;

  @override
  _DialogSaveTransactionState createState() => _DialogSaveTransactionState();
}

class _DialogSaveTransactionState extends State<DialogSaveTransaction> {

  double totalPaymentCustomer = 0;

  void validateAndSave(BuildContext context) async {
    if (DialogSaveTransaction._formKey.currentState!.validate()) {
       GlobalFunctions.logPrint("total_payment_customer", "$totalPaymentCustomer");
       GlobalFunctions.logPrint("total_transaction_price", "${widget.totalTransactionPrice}");
       GlobalFunctions.logPrint("transaction_from", "${widget.typeSaveTransaction}");
       Navigator.pop(context);
       bool isConnect = await GlobalFunctions.checkConnectivityApp();
       if(isConnect){
         await widget.salesBloc.requestMerchantTransaction(widget.totalTransactionPrice, totalPaymentCustomer);
       }else{
         await widget.salesBloc.addTransactionFailed(widget.totalTransactionPrice, totalPaymentCustomer);
       }

       // if (widget.typeSaveTransaction == "manual"){
       //   await widget.salesBloc.addTransactionFailed(widget.totalTransactionPrice, totalPaymentCustomer);
       //   await widget.salesBloc.deleteAll();
       //   GlobalFunctions.dismisLoading();
       // } else {
       //   await widget.salesBloc.requestMerchantTransaction(widget.totalTransactionPrice, totalPaymentCustomer);
       //   await widget.salesBloc.deleteAll();
       //   GlobalFunctions.dismisLoading();
       // }
    } else {
      BotToast.showText(text: 'Please Check Your input again');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: GlobalColorPalette.colorButtonActive,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Masukan Pembayaran",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
          ),
        ],
      ),
      content: Container(
        width: SizeConfig.screenWidth * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
            key: DialogSaveTransaction._formKey,
            child: TextFormField(
              onChanged: (newInput) {
                totalPaymentCustomer = double.parse(newInput);
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                  fontSize: 14, height: 1),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon isi pembayaran terlebih dahulu';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
              decoration: new InputDecoration(
                fillColor: Colors.white,
                filled: true,
                isDense: true,
                prefixIcon: Icon(
                  Icons.shopping_cart,
                  color: Colors.lightBlue[800],
                ),
                contentPadding:
                EdgeInsets.fromLTRB(
                    6.0, 18.0, 6.0, 18.0),
                focusedBorder:
                OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 0.0),
                ),
                enabledBorder:
                OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0),
                ),
                hintText: 'Total Pembayaran',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                validateAndSave(context);
              },
              style: ElevatedButton.styleFrom(
                primary: GlobalColorPalette.colorButtonActive,
                shape: new RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(
                      4.0),
                ),
              ), child:  Text(
              'Simpan Transaksi',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            ),
          ),
        ],
      )
      ),
    );
  }
}
