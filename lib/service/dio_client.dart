import 'package:beben_pos_desktop/content/model/bank_create.dart';
import 'package:beben_pos_desktop/content/model/banner_create.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_endpoint.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  @GET(FireshipEndpoint.MERCHANT_BANNER)
  Future<CoreModel> bannerList();

  @POST(FireshipEndpoint.MERCHANT_BANNER)
  Future<CoreModel> bannerCreate(
    @Body() BannerCreate body
  );

  @DELETE(FireshipEndpoint.MERCHANT_BANNER)
  Future<CoreModel> bannerDelete(
    @Body() BannerCreate body
  );

  @GET(FireshipEndpoint.MERCHANT_BANK)
  Future<CoreModel> bankList();

  @POST(FireshipEndpoint.MERCHANT_BANK)
  Future<CoreModel> bankCreate(
    @Body() BankCreate body
  );

  @DELETE(FireshipEndpoint.MERCHANT_BANK)
  Future<CoreModel> bankDelete(
    @Body() BankCreate body
  );

  @GET(FireshipEndpoint.MERCHANT_EMPLOYEES)
  Future<CoreModel> employeeList();

  @POST(FireshipEndpoint.MERCHANT_EMPLOYEES)
  Future<CoreModel> employeeCreate(
    @Body() BankCreate body
  );

  @GET(FireshipEndpoint.TAXES)
  Future<CoreModel> taxes();

  @GET(FireshipEndpoint.PAYMENT_METHOD)
  Future<CoreModel> paymentMethod();

  @GET(FireshipEndpoint.BANK)
  Future<CoreModel> bank();

  @GET(FireshipEndpoint.MERCHANT_DELIVERY_ORDER_OPERATION_LIST)
  Future<CoreModel> transactionList();

  @GET(FireshipEndpoint.MERCHANT_TRANSACTION_LIST)
  Future<CoreModel> merchantTransactionList();

  @GET(FireshipEndpoint.MERCHANT_TRANSACTION_DETAIL)
  Future<CoreModel> transactionDetail(@Query('transaction_code') String id);

  @GET(FireshipEndpoint.MERCHANT_DELIVERY_ORDER_LIST)
  Future<CoreModel> merchantDeliveryList();

  @GET(FireshipEndpoint.MERCHANT_DELIVERY_ORDER_EMPLOYEE_LIST)
  Future<CoreModel> merchantDeliveryEmployee();

  @GET(FireshipEndpoint.MERCHANT_DELIVERY_ORDER_OPERATION_LIST)
  Future<CoreModel> merchantDeliveryOperation();

  @GET(FireshipEndpoint.CUSTOMER_LIST)
  Future<CoreModel> customerList();

  @POST(FireshipEndpoint.CUSTOMER)
  Future<CoreModel> customerCreate(
    @Body() Map<String, dynamic> body
  );

  @GET(FireshipEndpoint.MERCHANT_DISCOUNT)
  Future<CoreModel> discountList();

  @POST(FireshipEndpoint.MERCHANT_DISCOUNT)
  Future<CoreModel> discountCreate(
    @Body() Map<String, dynamic> body
  );
}