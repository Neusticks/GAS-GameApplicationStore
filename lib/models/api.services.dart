import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class APIServices {
  static String userUrl='https://localhost:44363/api/user';

  static Future fetchUser() async {
    return await http.get(Uri.parse(userUrl));
  }
}
