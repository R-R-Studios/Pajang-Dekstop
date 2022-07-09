
class FireshipEndpoint {
  static const String SIMPLE = "";
  static const String TEST = "v1/banner_advertises";

  static const String SESSION = "/api/v1/session";

  // Merchant Product
  static const String CREATE_PRODUCT = "/api/pos/v1/product";
  static const String LIST_PRODUCT = "/api/pos/v1/products";
  static const String GET_PRODUCT_UNITS = "/api/pos/v1/units";
  static const String CREATE_MERCHANT_PRODUCT = "/api/pos/v1/merchant_product";

  // Menu Sales
  static const String LIST_MERCHANT_PRODUCT = "/api/pos/v1/merchant_products";
  static const String MERCHANT_TRANSACTION = "/api/pos/v1/transaction";
  static const String REQUEST_TRANSACTION = "/api/pos/v1/transaction";
  static const String REQUEST_RETURN = "/api/pos/v1/transaction/return";

  // Receivings
  static const String LIST_PRODUCT_RECEIVINGS = "/api/pos/v1/product/get_product";
  static const String LIST_UNITS = "/api/pos/v1/units";
  static const String CREATE_RECEIVINGS = "/api/pos/v1/product";
  static const String SEARCH_TRANSACTION_PO = "/api/pos/v1/transaction/preview";

  // Report
  static const String GET_REPORT_STOCK_OUTGOING = "/api/pos/v1/reporting/product/stock_outgoing";
  static const String GET_REPORT_SALES_TRANSACTION = "/api/pos/v1/reporting/transactions";
  static const String GET_REPORT_SALES_TRANSACTION_V2 = "/api/pos/v1/reporting/sellings";
  static const String GET_REPORT_SALES_TRANSACTION_DETAIL_V2 = "/api/pos/v1/reporting/selling";
  static const String GET_REPORT_RECEIVINGS = "/api/pos/v1/reporting/product/receivings";
  static const String GET_REPORT_STOCK_IN = "/api/pos/v1/reporting/stocks";

  // Profile
  static const String GET_PROFILE = "/api/pos/v1/users";

  static const String GET_UNIT_CONVERSION = "/api/pos/v1/unit_conversions";
}