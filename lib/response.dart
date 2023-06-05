import 'dart:convert';
import 'constants.dart';
import 'package:http/http.dart' as http;


Future<String>getResponse(String prompt) async
{
  var url=Uri.https('api.openai.com', '/v1/completions');
  final response= await http.post(
    url,
    headers: {
      'Content-Type':'application/json',
      'Authorization':'Bearer $apikey',
    },
    body: jsonEncode({
      'model':'text-davinci-003',
      'prompt':prompt,
      'temperature':0,
      'max_tokens':2000,
      'top_p':1,
      'frequency_penalty':0.0,
      'presence_penalty':0.0
    })
  );
  Map<String,dynamic> newresponse=jsonDecode(response.body);
  return newresponse['choices'][0]['text'];
}