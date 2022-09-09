
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

  //? Content
  static const String MERCHANT_BANNER = "/api/pos/v1/merchant_banners";
  static const String MERCHANT_BANK = "/api/pos/v1/merchant_banks";
  static const String MERCHANT_EMPLOYEES = "/api/pos/v1/merchant_employees";

  //? Taxes
  static const String TAXES = "/api/v1/taxes";

  //? Payment Method
  static const String PAYMENT_METHOD = "/api/pos/v1/payment_methods";

  //? Bank
  static const String BANK = "/api/pos/v1/banks";

  //? Customer
  static const String CUSTOMER_LIST = "/api/pos/v1/list_enduser";

  //? Merchant Delivery Order
  static const String MERCHANT_DELIVERY_ORDER_TRANSACTION_LIST = "/api/pos/v1/transaction/merchant_delivery_orders/transaction_lists";
  static const String MERCHANT_DELIVERY_ORDER_VEHICLE_LIST = "/api/pos/v1/transaction/merchant_delivery_orders/vehicle_lists";
  static const String MERCHANT_DELIVERY_ORDER_EMPLOYEE_LIST = "/api/pos/v1/transaction/merchant_delivery_orders/employee_lists";
  static const String MERCHANT_DELIVERY_ORDER_OPERATION_LIST = "/api/pos/v1/transaction/merchant_delivery_orders/operation_lists";

  //? Merchant Discount
  static const String MERCHANT_DISCOUNT = "/api/pos/v1/merchant_discounts";

  //? User
  static const String CUSTOMER = "pos/v1/users";

}