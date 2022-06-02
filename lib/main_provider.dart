import 'dart:convert';
import 'dart:io';

import 'package:currency_rate_api/api_response.dart';
import 'package:flutter/material.dart';

import 'currency_rate.dart';

import 'package:http/http.dart' as http;

class MainProvider extends ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial("Empty");

  final List<CurrencyRate> _currencyList = [];

  ApiResponse get responce {
    return _apiResponse;
  }

  List<CurrencyRate> get currencies {
    return _currencyList;
  }

  Future<ApiResponse> getCurrencyRate() async {
    String url = "https://nbu.uz/uz/exchange-rates/json/";
    Uri myUrl = Uri.parse(url);

    try {
      var response = await http.get(myUrl);
      List data = jsonDecode(response.body);

      _currencyList.clear();
      for (var element in data) {
        _currencyList.add(CurrencyRate.fromJson(element));
      }
      _apiResponse = ApiResponse.success(_currencyList);
    } catch (exception) {
      if (exception is SocketException) {
        _apiResponse = ApiResponse.error("");
      }
    }

    return _apiResponse;
  }
}
