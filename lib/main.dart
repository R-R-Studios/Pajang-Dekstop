import 'dart:io';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/merchant_product_db.dart';
import 'package:beben_pos_desktop/db/parent_child_unit_conversion_db.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/product_receivings_db.dart';
import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/db/transaction_failed_db.dart';
import 'package:beben_pos_desktop/db/transaction_failed_product_db.dart';
import 'package:beben_pos_desktop/db/unit_conversions_db.dart';
import 'package:beben_pos_desktop/db/unit_list_db.dart';
import 'package:beben_pos_desktop/session/login_screen.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:nav_router/nav_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart' as window_size;
import 'dashboard.dart';
import 'db/price_list_db.dart';
import 'db/product_db.dart';
import 'core/fireship/fireship_database.dart';
import 'core/fireship/fireship_utility_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' if (dart.library.html) 'src/stub/path.dart'
    as path_helper;
import 'db/units_db.dart';

Future<void> main() async {
  // var appDocumentDirectory = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDirectory.path);
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isMacOS){
    window_size.PlatformWindow window = await window_size.getWindowInfo();
    Size maxsize = await window_size.getWindowMaxSize();
    Size minsize = await window_size.getWindowMinSize();
    print("WINDOW INFO ${window.screen!.frame.size}");
    print("WINDOW MAXSIZE $maxsize");
    print("WINDOW MINSIZE $minsize");
    window_size.setWindowFrame(window.screen!.frame);
  }

  // doWhenWindowReady(() {
  //   var initialSize = Size(1280.0, 800.0);
  //   appWindow.minSize = initialSize;
  //   appWindow.maxSize = initialSize;
  //   appWindow.size = initialSize;
  //   appWindow.alignment = Alignment.center;
  //   appWindow.title = "BEBEN POS";
  //   appWindow.show();
  //   // appWindow.show();
  //   print("initialSize $initialSize}");
  // });

  await Hive.deleteFromDisk();
  if (!kIsWeb) {
    var appDir = await getApplicationDocumentsDirectory();
    Hive.init(path_helper.join(appDir.path));
  }
  Hive.registerAdapter(ProductModelAdapter()); // Hive ProducModelAdapter generate from product_db.g.dart
  Hive.registerAdapter(ProductModelDBAdapter()); // Hive ProducModelAdapter generate from product_db.g.dart
  Hive.registerAdapter(UnitsDBAdapter()); // Hive ProducModelAdapter generate from product_db.g.dart
  Hive.registerAdapter(ProductReceivingsDBAdapter()); // Hive ProducModelAdapter generate from product_db.g.dart
  Hive.registerAdapter(UnitListDBAdapter()); // Hive ProducModelAdapter generate from product_db.g.dart
  Hive.registerAdapter(PriceListDBAdapter());
  Hive.registerAdapter(TransactionFailedDBAdapter());
  Hive.registerAdapter(TransactionFailedProductDBAdapter());
  Hive.registerAdapter(MerchantProductDBAdapter());
  Hive.registerAdapter(ProfileDBAdapter());
  Hive.registerAdapter(UnitConversionDBAdapter());
  Hive.registerAdapter(ParentChildUnitDBAdapter());
  // Hive ProducModelAdapter generate from product_db.g.dart
  await Hive.openBox(FireshipBox.BOX_PRODUCT);
  await Hive.openBox(FireshipBox.BOX_TRANSACTION);
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    _setupLogging();
    checkLogin();
    super.initState();
  }

  void _setupLogging() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((rec) {
      GlobalFunctions.logPrint(
          "", '${rec.level.name}: ${rec.time}; ${rec.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navGK,
        builder: BotToastInit(),
        initialRoute: '/',
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
        },
        title: "Dashboard",
        home:
        isLogin ? DashboardScreen() :
        LoginScreen());
  }

  void checkLogin() async {
    var utilityBox = await FireshipDatabase.openBoxDatabase(FireshipUtilityBox.TABEL_NAME);
    setState(() {
      isLogin = utilityBox.isNotEmpty;
    });
  }
}
