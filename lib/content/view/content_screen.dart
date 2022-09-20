import 'package:beben_pos_desktop/content/cubit/bank_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/banner_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/content_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/discount_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/employee_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/product_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/vehicle_cubit.dart';
import 'package:beben_pos_desktop/content/view/bank_screen.dart';
import 'package:beben_pos_desktop/content/view/banner_view.dart';
import 'package:beben_pos_desktop/content/view/discount_view.dart';
import 'package:beben_pos_desktop/content/view/employee_view.dart';
import 'package:beben_pos_desktop/content/view/product_screen.dart';
import 'package:beben_pos_desktop/content/view/vehicle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/content_menu.dart';

class ContentScreen extends StatelessWidget {
  ContentScreen({Key? key}) : super(key: key);

  final List<ContentMenuModel> listMenu = [
    ContentMenuModel(
        title: "Banner",
        description: "Tampilan Informasi pada halaman home pengguna",
        image: "",
        contentMenu: ContentMenu.banner),
    ContentMenuModel(
        title: "Product",
        description: "Daftar Produk anda",
        image: "",
        contentMenu: ContentMenu.product),
    ContentMenuModel(
        title: "Bank",
        description: "Daftar informasi bank anda saat transaksi pengguna",
        image: "",
        contentMenu: ContentMenu.bank),
    ContentMenuModel(
        title: "Pegawai",
        description: "pegawai anda",
        image: "",
        contentMenu: ContentMenu.employee),
    ContentMenuModel(
        title: "Diskon",
        description: "Pengaturan diskon product di aplikasi pengguna",
        image: "",
        contentMenu: ContentMenu.discount),
    ContentMenuModel(
        title: "Kendaraan",
        description: "Daftar Kendaraan anda",
        image: "",
        contentMenu: ContentMenu.vehicle),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        if (state is ContentInitial) {
          return menu(context);
        } else if (state is ContentBanner) {
          return BlocProvider(
            create: (context) => BannerCubit(),
            child: BannerView(
              callback: () => BlocProvider.of<ContentCubit>(context)
                  .navgation(ContentMenu.initial),
            ),
          );
        } else if (state is ContentProduct) {
          return BlocProvider(
            create: (context) => ProductCubit(),
            child: ProductScreen(
              callback: () => BlocProvider.of<ContentCubit>(context)
                  .navgation(ContentMenu.initial),
            ),
          );
        } else if (state is ContentBank) {
          return BlocProvider(
            create: (context) => BankCubit(),
            child: BankScreen(
                callback: () => BlocProvider.of<ContentCubit>(context)
                    .navgation(ContentMenu.initial)),
          );
        } else if (state is ContentEmployee) {
          return BlocProvider(
            create: (context) => EmployeeCubit(),
            child: EmployeeView(
                callback: () => BlocProvider.of<ContentCubit>(context)
                    .navgation(ContentMenu.initial)),
          );
        } else if (state is ContentDiscount) {
          return BlocProvider(
            create: (context) => DiscountCubit(),
            child: DiscountScreen(
                callback: () => BlocProvider.of<ContentCubit>(context)
                    .navgation(ContentMenu.initial)),
          );
        } else if (state is ContentVehicle) {
          return BlocProvider(
            create: (context) => VehicleCubit(),
            child: VehicleScreen(
                callback: () => BlocProvider.of<ContentCubit>(context)
                    .navgation(ContentMenu.initial)),
          );
        } else {
          return Container();
        }
      },
    ));
  }

  Widget menu(context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
        child: GridView.builder(
          itemCount: listMenu.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            childAspectRatio: (100 / 200),
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                BlocProvider.of<ContentCubit>(context)
                    .navgation(listMenu[index].contentMenu!);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.menu,
                        size: 100,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    listMenu[index].title ?? "",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    listMenu[index].description ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            );
          },
        ));
  }
}
