class Core {
  static Future<String> dateConverter(DateTime? dateToConvert) async {
    if (dateToConvert != null) {
      String hour = dateToConvert.hour < 10 ? "0${dateToConvert.hour}" : "${dateToConvert.hour}";
      String minute = dateToConvert.minute < 10 ? "0${dateToConvert.minute}" : "${dateToConvert.minute}";
      var formatDate =
          "${dateToConvert.year}-${dateToConvert.month}-${dateToConvert.day} $hour:$minute";
      return formatDate;
    } else {
      return "";
    }
  }

  static String reverseNumeric(String price) {
    var value = price.replaceAll(",", "");
    if (value.contains("Rp.")) {
      value = value.replaceAll("Rp.", "");
    }
    return value;
  }

  static String converNumeric(String price, {bool useCurrency = true}) {
    String value = price;
    if (value.length > 3) {
      // value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    }
    if (value.contains(".")) {
      List<String> listValue = value.split(".");
      value = listValue[0];
      if (listValue[1] != "0") {
        value = value + "." + listValue[1].substring(0, 1);
      }
    }
    if (useCurrency)
      return "Rp. $value";
    else
      return "$value";
  }

  static String convertToDouble(String convert) {
    String value = convert;
    if (value.contains(".")) {
      List<String> listValue = value.split(".");
      value = listValue[0];
      if (listValue[1] != "0") {
        value = value + "." + listValue[1].substring(0, 1);
      }
    }
    return "$value";
  }
}
