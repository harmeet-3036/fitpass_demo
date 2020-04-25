
import 'city.dart';

class LoginRequest{

  final int code;
  final String user_existing;
  final String mobile_no;
  final String preferred_location;
  final String app_key;
  final int user_id;
  final List<City> cities;
  LoginRequest({this.code,this.user_existing,this.mobile_no,this.preferred_location,this.app_key,this.user_id,this.cities});


  factory LoginRequest.fromJson(Map<String, dynamic> json) {

    var list = json['fitpass_available_in_city'] as List;
    List<City> cityList = list.map((i) => City.fromJson(i)).toList();

    return LoginRequest(
        code: json['code'],
        user_existing: json['user_existing'],
        mobile_no: json['mobile_no'],
        preferred_location: json['preferred_location'],
        app_key: json['app_key'],
        user_id: json['user_id'],
        cities: cityList
    );
  }

}