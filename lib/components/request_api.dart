import 'package:http/http.dart' as http;

class RequestNewApi {
  RequestNewApi();

  String apiUrl = 'https://192.168.1.50:3000';

  Future doRequestNewPage(
    String cid,
    String pincode,
    String telephone,
    String device_token,
  ) async {
    // localhost:3000/register/save -POST
    String _url = '$apiUrl/user/save';
    var body = {
      'cid': cid.toString(),
      'pincode': pincode.toString(),
      'telephone': telephone.toString(),
      'device_token': device_token.toString(),
    };

    return await http.post(Uri.parse(_url), body: body);
  }
}
