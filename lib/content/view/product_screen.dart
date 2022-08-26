import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {

  final VoidCallback callback;

  const ProductScreen({ required this.callback, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Constant.paddingScreen,
        child: ListView(
          children: [
            const SizedBox(height: 20,),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: callback,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  label: Text("Back"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                    primary: Color(0xff3498db)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Component.text("Product Anda", fontSize: 17, colors: Colors.black),
                const Spacer(),
                InkWell(
                  onTap: (){
                    // dialogCreate();
                  },
                  child: Card(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          const SizedBox(width: 5,),
                          Component.text("Tambah", colors: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Card(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        const SizedBox(width: 5,),
                        Component.text("Hapus", colors: Colors.white),
                      ],
                    ),
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 20,),
            GridView.builder(
              itemCount: 20,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                // childAspectRatio: (100 / 20),
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl: "https://www.lg.com/id/images/lemari-es/md05832693/gallery/Digital_GN-C422SLCN_940x620-02.jpg",
                        fit: BoxFit.fill,
                      ),
                      Component.text(
                        "Kulkas 2 Pintu - Inverter Linear Compressor",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        colors: Colors.black
                      ),
                      const SizedBox(height: 10,),
                      Component.text(Core.converNumeric(200000.toString()))
                    ],
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}