import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path/path.dart' if (dart.library.html) 'src/stub/path.dart'
    as path_helper;

class PdfSales {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    // Directory dir = await getTemporaryDirectory();
    var appDir = await getApplicationDocumentsDirectory();
    final file = File(path_helper.join(appDir.path, name));
    // GlobalFunctions.showToast("${file.path}");
    try {
      await file.writeAsBytes(await pdf.save(), flush: true);
    } catch (e) {
      GlobalFunctions.showToast(e.toString());
    }

    return file;
  }

  Future openFile(File file) async {
    final url = file.path;
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(url);
    } else {
      // User canceled the picker
    }
  }
}
