import 'package:beben_pos_desktop/core/fireship/fireship_endpoint.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import 'model/core_model.dart';

part 'dio_client.g.dart';

@RestApi(baseUrl: '')
abstract class DioClient {
  factory DioClient(Dio dio, {String baseUrl}) = _DioClient;

  @POST(FireshipEndpoint.SESSION)
  Future<CoreModel> requestSession(@Body() Map<String, dynamic> body);

  @POST(FireshipEndpoint.CREATE_PRODUCT)
  Future<CoreModel> createProduct(@Body() Map<String, dynamic> body);

  @GET(FireshipEndpoint.LIST_PRODUCT)
  Future<CoreModel> listProduct();

  @GET(FireshipEndpoint.GET_PRODUCT_UNITS)
  Future<CoreModel> getListProductUnits();

  @GET(FireshipEndpoint.LIST_MERCHANT_PRODUCT)
  Future<CoreModel> listMerchantProduct(@Query('search') String searchProduct, @Query('type') String type);
  // Sales API
  @POST(FireshipEndpoint.MERCHANT_TRANSACTION)
  Future<CoreModel> requestMerchantTransaction(@Body() Map<String, dynamic> body);

  @GET(FireshipEndpoint.LIST_UNITS)
  Future<CoreModel> getListUnits();

  @GET(FireshipEndpoint.LIST_PRODUCT_RECEIVINGS)
  Future<CoreModel> listProductReceivings(@Query('type') String type);

  @POST(FireshipEndpoint.CREATE_RECEIVINGS)
  Future<CoreModel> createReceivings(@Body() Map<String, dynamic> body);

  @POST(FireshipEndpoint.SEARCH_TRANSACTION_PO)
  Future<CoreModel> searchTransactionPO(@Body() Map<String, dynamic> body);

  @GET(FireshipEndpoint.GET_REPORT_STOCK_OUTGOING)
  Future<CoreModel> getReportStockOutgoing(
      @Query('auth_token') String authToken,
      @Query('start_date') String startDate,
      @Query('end_date') String endDate
      );

  @GET(FireshipEndpoint.GET_REPORT_SALES_TRANSACTION)
  Future<CoreModel> getReportSalesTransaction(
      @Query('start_date') String fromDate,
      @Query('end_date') String toDate);

  @GET(FireshipEndpoint.GET_REPORT_SALES_TRANSACTION_V2)
  Future<CoreModel> getReportSalesTransactionV2(
      @Query('start_date') String fromDate,
      @Query('end_date') String toDate);

  @GET(FireshipEndpoint.GET_REPORT_SALES_TRANSACTION_DETAIL_V2)
  Future<CoreModel> getDetailReportSalesTransactionV2(
      @Query('id') String transactionCode);

  @GET(FireshipEndpoint.GET_REPORT_RECEIVINGS)
  Future<CoreModel> searchReportReceivings(
      @Query('merchant_id') String merchantId,
      @Query('product_name') String productName,
      @Query('start_date') String startDate,
      @Query('end_date') String endDAte);

  @GET(FireshipEndpoint.GET_REPORT_STOCK_IN)
  Future<CoreModel> searchReportStockIn(
      @Query('merchant_id') String merchantId,
      @Query('start_date') String startDate,
      @Query('end_date') String endDAte);

  @GET(FireshipEndpoint.GET_PROFILE)
  Future<CoreModel> getProfile();

  @GET(FireshipEndpoint.GET_UNIT_CONVERSION)
  Future<CoreModel> getUnitConversion();

  @POST(FireshipEndpoint.REQUEST_RETURN)
  Future<CoreModel> requestReturnTransaction(@Body() Map<String, dynamic> body);

  @POST(FireshipEndpoint.CREATE_MERCHANT_PRODUCT)
  Future<CoreModel> requestCreateMerchantProduct(@Body() Map<String, dynamic> body);
}