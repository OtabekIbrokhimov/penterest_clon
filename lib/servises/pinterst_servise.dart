
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pinterest/models/collection%20Model.dart';
import 'package:pinterest/models/pinterest_model.dart';


class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "https://api.unsplash.com";
  static String SERVER_PRODUCTION = "https://api.unsplash.com";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization":"Client-ID n-zkYVjrcC0CzZO-rMtY2fM9esck0ibpXrmvDig7fL8"
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, dynamic>? params) async {
    var options = BaseOptions(
      baseUrl: getServer(),
      headers: getHeaders(),
      connectTimeout: 10000,
      receiveTimeout: 3000,
    );
    Response response = await Dio(options).get(api, queryParameters: params);
    print(jsonEncode(response.data));
    if (response.statusCode == 200) return jsonEncode(response.data);
    return null;
  }



  /* Http Apis */
  static String API_LIST = "/photos";
  static String API_SEARCH = "search/photos";
  // static String API_UPDATE = "/photos/"; //{id}
  // static String API_DELETE = "/photos/"; //{id}

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = new Map();
    return params;
  }
  static Map<String, String> paramsEmpty2(int pageNum) {
    Map<String, String> params = new Map();
    params.addAll(
        {'page': pageNum.toString(),
        });
    return params;
  }
static Map <String, String> paramsSearch(int pageNum, String searcher){
    Map <String, String> params = Map();
    params.addAll(
      {'page': pageNum.toString(), "query":searcher
      }
    );
    return params;
}
  static List<Pinterest> parsePostList(String response) {
    List list = jsonDecode(response);
    List<Pinterest> photos = List<Pinterest>.from(list.map((x) => Pinterest.fromJson(x)));
    return photos;
  }
  static List<Pinterest> parseSearchParse(String response) {
    Map<String, dynamic> json = jsonDecode(response);
    List<Pinterest> photos = List<Pinterest>.from(json["results"].map((x) => Pinterest.fromJson(x)));
    return photos;
  }
  static List<Collections> parseCollectionResponse(String response) {
    List json = jsonDecode(response);
    List<Collections> collections = List<Collections>.from(json.map((x) => Collections.fromJson(x)));
    return collections;
  }
}