import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/ui/sale/cubit/balance_cubit.dart';
import 'package:beben_pos_desktop/ui/sale/cubit/sale_cubit.dart';
import 'package:beben_pos_desktop/ui/sale/view/balance_view.dart';
import 'package:beben_pos_desktop/ui/sale/view/shift_view.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/global_color_palette.dart';
import '../model/sale_menu.dart';

class SaleView extends StatelessWidget {
  SaleView({Key? key}) : super(key: key);

  final List<SaleMenu> listMenu = [
    SaleMenu(saleTypeMenu: SaleTypeMenu.shift, title: "Pergatian Shift"),
    SaleMenu(saleTypeMenu: SaleTypeMenu.balance, title: "Saldo")
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaleCubit, SaleState>(
      builder: (context, state) {
        if (state is SaleInitial) {
          return SizedBox(
            width: SizeConfig.screenWidth * 0.5,
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: GlobalColorPalette.colorPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.social_distance,
                            color: GlobalColorPalette.white,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                'Menu Pejualan',
                                style: TextStyle(
                                    color: GlobalColorPalette.white,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: listMenu.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              BlocProvider.of<SaleCubit>(context)
                                  .navigation(listMenu[index].saleTypeMenu);
                            },
                            child: Container(
                                margin: EdgeInsets.all(14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      listMenu[index].title,
                                      style: TextStyle(),
                                    ),
                                  ],
                                )),
                          ),
                          Divider()
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is SaleBalance) {
          return BlocProvider(
            create: (context) => BalanceCubit(),
            child: BalanceView(
              callback: () => BlocProvider.of<SaleCubit>(context).navigation(SaleTypeMenu.initial)
            ),
          );
        } else if (state is SaleShift) {
          return ShiftView(
              callback: () => BlocProvider.of<SaleCubit>(context)
                  .navigation(SaleTypeMenu.initial));
        } else {
          return Container();
        }
      },
    );
  }
}
