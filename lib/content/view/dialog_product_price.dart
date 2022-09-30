import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/model/product_price_update.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogProductPrice extends StatefulWidget {

  const DialogProductPrice({ Key? key }) : super(key: key);

  @override
  State<DialogProductPrice> createState() => _DialogProductPriceState();
}

class _DialogProductPriceState extends State<DialogProductPrice> {

  bool isExcluedetax = false;
  final TextEditingController saleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constant.paddingScreen,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Component.text("Harga Jual"),
            const SizedBox(height: 10,),
            TextFormField(
              controller: saleController,
              decoration: InputDecoration(
                labelText: 'harga Jual',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              enabled: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Masukan harga jual';
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Component.text("Termasuk Pajak"),
                const SizedBox(width: 10,),
                Switch(
                  value: isExcluedetax, 
                  activeColor: ColorPalette.primary,
                  onChanged: (value){
                    setState(() {
                      isExcluedetax = !isExcluedetax;
                    });
                  }
                ),
              ],
            ),
            const SizedBox(height: 20,),
             InkWell(
              onTap: () async{
                Navigator.of(context).pop(ProductPriceUpdateRequest(
                  salePrice: int.parse(saleController.text),
                  type: isExcluedetax ? "include" : "exclude"
                ));
              },
              child: Card(
                color: Colors.green,
                child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.blockSizeHorizontal * 60,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Component.text("Tambah", colors: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}