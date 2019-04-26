import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zwt_life_flutter_app/common/net/Address.dart';
import 'package:zwt_life_flutter_app/common/net/Api.dart';
import 'package:zwt_life_flutter_app/common/net/ResultData.dart';

dioGetSearchResult(String keyworld, [int page = 0]) async {
//  String url = Address.baseUrl1;
//  String path = "/ware/search._m2wq_list";
//  Map<String, String> requestParams = {
//    "keyword": "$keyworld",
//    "datatype": "1",
//    "callback": "C",
//    "page": "$page",
//    "pagesize": "10",
//    "ext_attr": "no",
//    "brand_col": "no",
//    "price_col": "no",
//    "color_col": "no",
//    "size_col": "no",
//    "ext_attr_sort": "no",
//    "merge_sku": "yes",
//    "multi_suppliers": "yes",
//    "area_ids": "1,72,2818",
//    "qp_disable": "no",
//    "fdesc": "%E5%8C%97%E4%BA%AC",
//  };
//
//  ResultData res = await HttpManager.netFetch(url, path, requestParams);
//  String body = res.data;
  String url =
      'https://so.m.jd.com/ware/search._m2wq_list?keyword=$keyworld&datatype=1&callback=C&page=$page&pagesize=10&ext_attr=no&brand_col=no&price_col=no&color_col=no&size_col=no&ext_attr_sort=no&merge_sku=yes&multi_suppliers=yes&area_ids=1,72,2818&qp_disable=no&fdesc=%E5%8C%97%E4%BA%AC';
  var res = await http.get(url);
  String body = res.body;

  String jsonString = body.substring(2, body.length - 2);
  //  debugPrint(jsonString.replaceAll('\\x2F', '/'));
  var json = jsonDecode(jsonString.replaceAll(RegExp(r'\\x..'), '/'));
  return json['data']['searchm']['Paragraph'] as List;
}



dioGetSuggest(String q) async {
  String url = Address.baseUrl2;
  String path = "/sug";
  Map<String, String> requestParams = {
    "q": "$q",
    "code": "utf-8",
    "area": "c2c",
  };
  ResultData res = await HttpManager.netFetch(url, path, requestParams);
  if (res != null && res.result) {
    List data = jsonDecode(res.data)['result'] as List;
    return data;
  } else {
    return [];
  }
}
