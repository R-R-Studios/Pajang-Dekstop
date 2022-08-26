import 'package:beben_pos_desktop/sales/model/payment_method.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

class DialogPaymentMethod extends StatefulWidget {

  final List<PaymentMethod> listPayment;

  DialogPaymentMethod({required this.listPayment, Key? key}) : super(key: key);

  @override
  State<DialogPaymentMethod> createState() => _DialogPaymentMethodState();
}

class _DialogPaymentMethodState extends State<DialogPaymentMethod> {

  PaymentMethod? groupValue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: SizeConfig.screenWidth * 0.35,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.lightBlue,
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
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(18),
              itemCount: widget.listPayment.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: widget.listPayment[index], 
                      groupValue: groupValue, 
                      onChanged: (value) {
                        setState(() {
                          groupValue = widget.listPayment[index];
                        });
                      }
                    ),
                    const SizedBox(width: 10,),
                    Text(
                       widget.listPayment[index].name ?? ""
                    )
                  ],
                );
              },
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                // focusNode: dialogSaveFocus,
                onPressed: () async {
                  Navigator.of(context).pop(groupValue);
                },
                style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 12,
                  height: 30,
                  child: Center(
                    child: Text(
                      "Selanjutnya",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}