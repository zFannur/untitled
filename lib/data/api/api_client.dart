import 'package:untitled/data/models/converter.dart';
import 'package:untitled/data/models/operation_api.dart';

import '../../domain/entity/operation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../domain/repository/api_repository.dart';

//сделать обработку ошибок

class ApiClientImpl implements ApiClient{
  static const uri =
      "https://script.google.com/macros/s/AKfycbySJsChZ2hhhjSqc5V_MPdic2rSMzhBIqs1MFSHsOi_Gpxl5UKR_t-pIPHlZHSF1EQrhg/exec";

  @override
  Future<List<Operation>> getForm() async {
    try{
      return await http.get(Uri.parse(uri)).then((response) {
        var jsonForm = convert.jsonDecode(response.body) as List;
        return ConvertOperation.operationApiToOperationList(jsonForm.map((json) => OperationApi.fromJson(json)).toList());
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> postForm(Operation operation) async {
    final operationApi = ConvertOperation.operationToOperationApi(operation);
    String message = '';
    try {
      final url = Uri.parse(uri);

      var json = operationApi.toJson();

      await http.post(url, body: json).then((response) async {
        if (response.statusCode == 302) {
          var unary = Uri.parse(response.headers['location']!);
          await http.get(unary).then((response) {
            message = (convert.jsonDecode(response.body)['status']);
          });
        } else {
          message =  'StatusCodeError';
        }
      });
    } catch (e) {
      message = 'error';
    }
    return message;
  }
}