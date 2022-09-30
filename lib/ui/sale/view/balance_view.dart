import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

import '../cubit/balance_cubit.dart';

class BalanceView extends StatelessWidget {

  final VoidCallback callback;

  const BalanceView({ required this.callback, Key? key }) : super(key: key);

  dialogCreate(currentContext){
    final TextEditingController valueController = TextEditingController();
    showDialog(
      context: navGK.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Container(
            width: 500,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Perbaharui Saldo"),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  tooltip: "Tutup",
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close)
                )
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Component.text("Nominal"),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Nomonal',
                  border: OutlineInputBorder(),
                ),
                controller: valueController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Nominal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                  BlocProvider.of<BalanceCubit>(currentContext).onUpdateBalance(valueController.text);
                },
                child: Card(
                  color: Colors.green,
                  child: Container(
                    alignment: Alignment.center,
                    width: SizeConfig.blockSizeHorizontal * 60,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Component.text("Perbaharui", colors: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constant.paddingScreen,
      child: BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, state) {
          if (state is BalanceLoading) {
            return Center(child: CupertinoActivityIndicator());
          } else if (state is BalanceLoaded) {
            return ListView(
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
                const SizedBox(height: 50,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal * 50,
                        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Component.text("Saldo Kasir saar ini adalah"),
                            const SizedBox(height: 10,),
                            Component.text(
                              CoreFunction.moneyFormatter(state.balanceResponse.balance),
                              fontSize: 35,
                              colors: ColorPalette.black,
                              fontWeight: FontWeight.bold
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: (){
                            dialogCreate(context);
                          },
                          child: Text("Refresh Saldo"),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            primary: Color(0xff3498db)
                          ),
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: callback,
                          child: Text("Update Saldo"),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            primary: Color(0xff3498db)
                          ),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Component.text(CoreFunction.timeNow())
              ]
            );
          } else {
            return Container();
          }
        },
      )
    );
  }
}