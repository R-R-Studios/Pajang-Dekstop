import 'package:beben_pos_desktop/content/cubit/bank_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/banner_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/content_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/discount_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/employee_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/vehicle_cubit.dart';
import 'package:beben_pos_desktop/content/view/bank_screen.dart';
import 'package:beben_pos_desktop/content/view/banner_view.dart';
import 'package:beben_pos_desktop/content/view/discount_view.dart';
import 'package:beben_pos_desktop/content/view/employee_view.dart';
import 'package:beben_pos_desktop/content/view/product_screen.dart';
import 'package:beben_pos_desktop/content/view/vehicle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentScreen extends StatelessWidget {

  const ContentScreen({Key? key}) : super(key: key);

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
          return ProductScreen(
            callback: () => BlocProvider.of<ContentCubit>(context)
                .navgation(ContentMenu.initial),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              BlocProvider.of<ContentCubit>(context).navgation(ContentMenu.banner);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.view_in_ar,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Banner",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<ContentCubit>(context)
                  .navgation(ContentMenu.product);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.view_in_ar,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Product",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<ContentCubit>(context)
                  .navgation(ContentMenu.bank);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.money,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Bank",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<ContentCubit>(context)
                  .navgation(ContentMenu.employee);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.money,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Pegawai",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<ContentCubit>(context).navgation(ContentMenu.discount);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.money,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Diskon",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<ContentCubit>(context).navgation(ContentMenu.vehicle);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.car_rental,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Kendaraan",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}
