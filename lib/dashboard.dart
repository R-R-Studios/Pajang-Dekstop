import 'dart:io';

import 'package:beben_pos_desktop/commingsoon/menu_comming_soon.dart';
import 'package:beben_pos_desktop/content/cubit/content_cubit.dart';
import 'package:beben_pos_desktop/content/view/content_screen.dart';
import 'package:beben_pos_desktop/customer/cubit/customer_cubit.dart';
import 'package:beben_pos_desktop/customer/view/customer_view.dart';
import 'package:beben_pos_desktop/dashboard_bloc.dart';
import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/product/screen/menu_product.dart';
import 'package:beben_pos_desktop/receivings/menu_receivings.dart';
import 'package:beben_pos_desktop/reports/reports_merchant.dart';
import 'package:beben_pos_desktop/sales/sales_input.dart';
import 'package:beben_pos_desktop/ui/delivery/view/delivery_view.dart';
import 'package:beben_pos_desktop/ui/transaction/cubit/transaction_cubit.dart';
import 'package:beben_pos_desktop/ui/transaction/view/transaction_view.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/fireship/fireship_encrypt.dart';
import 'model/navigation_model.dart';
import 'ui/delivery/cubit/delivery_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  
  List<NavigationModel> _navModel = [
    // NavigationModel(
    //     name: "Customer", icon: "assets/images/ic_dashboard_customer.png"),
    NavigationModel(
      key: "product", 
      name: "Produk", 
      icon: "assets/images/ic_items.png"),
    // NavigationModel(
    //     name: "Units", icon: "assets/images/ic_dashboard_item_kits.png"),
    // NavigationModel(
    //     name: "Supplier", icon: "assets/images/ic_dashboard_suppliers.png"),
    NavigationModel(
        key: "receivings",
        name: "Penerimaan",
        icon: "assets/images/ic_receivings.png"),
    NavigationModel(
        key: "sales", name: "Penjualan", icon: "assets/images/ic_sales.png"),
    NavigationModel(
        key: "reports", name: "Laporan", icon: "assets/images/ic_reports.png"),
    NavigationModel(
        key: "content",
        name: "Content",
        icon: "assets/images/ic_gift_cards.png"),
    NavigationModel(
        key: "messages", name: "Pesan", icon: "assets/images/ic_messages.png"),
    NavigationModel(
        key: "transaction",
        name: "transaksi",
        icon: "assets/images/ic_expenses.png"),
    NavigationModel(
        key: "delivery",
        name: "Pengiriman",
        icon: "assets/images/ic_expenses_category.png"),
    NavigationModel(
        key: "customer",
        name: "Customer",
        icon: "assets/images/ic_cashups.png"),
    NavigationModel(
        key: "office", name: "Kantor", icon: "assets/images/ic_office.png"),
  ];

  late TabController _tabController =
      new TabController(vsync: this, length: _navModel.length);

  String username = "Logout";
  var isDeviceConnected = false;
  var _formKey = GlobalKey<FormState>();

  ProfileDB profile = ProfileDB();
  DashboardBloc dashboardBloc = DashboardBloc();

  @override
  void initState() {
    // TODO: implement initState
    checkingConnectionStatus();
    dashboardBloc.getProfileDB();
    dashboardBloc.scanBarcodeController.listen((value) {
      openAddProduct();
      print("isOpenAddProduct");
    });
    super.initState();
  }

  void checkingConnectionStatus() async {
    isDeviceConnected = await GlobalFunctions.checkConnectivityApp();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home: DefaultTabController(
        length: _navModel.length,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xff182735),
                centerTitle: true,
                leading: Padding(
                  padding: EdgeInsets.only(left: 25, top: 30),
                  child: StreamBuilder<ProfileDB>(
                      stream: dashboardBloc.streamProfile,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          profile = snapshot.data ?? ProfileDB();
                        }
                        if (profile.merchantName != null) {
                          return Text(
                            "${profile.merchantName}",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          );
                        } else {
                          return Text(
                            "",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          );
                        }
                      }),
                ),
                leadingWidth: MediaQuery.of(context).size.width * 0.2,
                title: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('Beben POS'),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  controller: _tabController,
                  tabs: [
                    for (final tab in _navModel)
                      Tab(
                        icon: Image.asset(
                          tab.icon ?? "",
                          height: 40,
                          width: 40,
                        ),
                        text: tab.name,
                      )
                  ],
                ),
                actions: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 5, right: 5, top: 20),
                    child: IconButton(
                      onPressed: () {
                        dialogSetupPrinter();
                      },
                      icon: Icon(Icons.print),
                    ),
                  ),
                  isDeviceConnected
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            onPressed: () {
                              checkingConnectionStatus();
                            },
                            child: Text(
                              "Online mode",
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                      : Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              checkingConnectionStatus();
                            },
                            child: Text(
                              "Offline mode",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 5, right: 5, top: 20),
                    child: Text(
                      "|",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff182735),
                        ),
                        onPressed: () {
                          exitApp();
                        },
                        child: Text(
                          "Tutup Sementara",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 5, right: 5, top: 20),
                    child: Text(
                      "|",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 40, top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff182735),
                        ),
                        onPressed: () {
                          dialogLogout();
                        },
                        child: Text(
                          username,
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // for (final tab in _navModel)
                //   tab.name == "Customer" ? MenuCustomer() :  Container()
                for (final tab in _navModel)
                  // if (tab.name == "Customer") MenuCustomer()
                  if (tab.key == "reports")
                    ReportsMerchant()
                  else if (tab.key == "sales")
                    SalesInput()
                  // else if (tab.name == "Gift Card") GiftScreen()
                  else if (tab.key == "product")
                    MenuProduct(dashboardBloc)
                  else if (tab.key == "receivings")
                    MenuReceivings(dashboardBloc)
                  // else if (tab.name == "Units") MenuUnits()
                  else if (tab.key == "content")
                    BlocProvider(
                      create: (context) => ContentCubit(),
                      child: ContentScreen(),
                    )
                  else if (tab.key == "transaction")  
                    BlocProvider(
                      create: (context) => TransactionCubit(),
                      child: TransactionView()
                    )
                  else if (tab.key == "delivery")  
                    BlocProvider(
                      create: (context) => DeliveryCubit(),
                      child: DeliveryView()
                    )
                  else if (tab.key == "customer")  
                    BlocProvider(
                      create: (context) => CustomerCubit(),
                      child: CustomerView()
                    )
                  else
                    MenuCommingSoon(tab)
              ],
            )),
      ),
    );
  }

  void dialogLogout() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          // return AlertDialog(
          //   contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          //   titlePadding: EdgeInsets.zero,
          //   actionsAlignment: MainAxisAlignment.spaceEvenly,
          //   title: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Container(
          //         color: Colors.lightBlue,
          //         child: Padding(
          //           padding: const EdgeInsets.all(12.0),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Anda yakin ingin Logout?",
          //                 style: TextStyle(
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.white),
          //               ),
          //               IconButton(
          //                 onPressed: () {
          //                   GlobalFunctions.logOut(ctx);
          //                   // Navigator.pop(ctx);
          //                 },
          //                 tooltip: "Close",
          //                 icon: Icon(Icons.close),
          //                 color: Colors.white,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   content: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //         width: MediaQuery.of(context).size.width * 0.3,
          //         child: Center(
          //           child: Text(
          //             "Anda yakin ingin Logout dari akun?",
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   actions: [
          //     ElevatedButton(
          //       onPressed: () {
          //         Navigator.pop(ctx);
          //       },
          //       style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
          //       child: Container(
          //         width: SizeConfig.blockSizeHorizontal * 12,
          //         height: 30,
          //         child: Center(
          //           child: Text(
          //             "Tidak",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         logout();
          //       },
          //       style: TextButton.styleFrom(shadowColor: Colors.grey),
          //       child: Container(
          //         width: SizeConfig.blockSizeHorizontal * 12,
          //         height: 30,
          //         child: Center(
          //           child: Text(
          //             "Ya",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colors.lightBlue),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // );
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Apakah anda yakin untuk keluar ?'),
                    SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(ctx);
                              }, child:
                          Container(
                            width: SizeConfig.screenWidth * 0.12,
                            height: 30,
                            child: Center(
                              child: Text(
                                "Tidak",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),),
                          SizedBox(
                            width: 24,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              logout();
                            },
                            style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                            child: Container(
                              width: SizeConfig.screenWidth * 0.12,
                              height: 30,
                              child: Center(
                                child: Text(
                                  "Ya",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void logout() async {
    // Hive.deleteBoxFromDisk(FireshipBox.BOX_PROFILE);
    // Hive.deleteBoxFromDisk(FireshipUtilityBox.TABEL_NAME);
    GlobalFunctions.logOut(context);
    // Hive.deleteFromDisk();
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginScreen()),
    //     ModalRoute.withName('/login'));
  }

  void exitApp() {
    exit(0);
  }

  void openAddProduct() {
    setState(() {
      _tabController.animateTo(0);
      print("openAddProduct");
    });
  }

  void dialogSetupPrinter() async {
    var initialAdress = await FireshipCrypt().getPrinterAddress();
    var printerAddressController = TextEditingController(text: initialAdress);
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
            title: Container(
              width: 300,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Setting Printer"),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      tooltip: "Close",
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.close))
                ],
              ),
            ),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.only(bottom: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: Text("Alamat Printer"),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: TextFormField(
                                controller: printerAddressController,
                                validator: (value){
                                  if (value!.isEmpty) {
                                    return 'Masukan printer address';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    onSetupPrinter(value, ctx);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Alamat Printer',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              onSetupPrinter(printerAddressController.text, ctx);
                            },
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(color: Colors.white),
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 15,
                                    bottom: 15),
                                primary: Color(0xff3498db)),
                            child: Text("Simpan"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  void onSetupPrinter(String address, BuildContext ctx) {
    var form = _formKey.currentState;
    if(form!= null && form.validate()){
      FireshipCrypt().setPrinterAddress(address);
      Navigator.pop(ctx);
    }
  }
}
