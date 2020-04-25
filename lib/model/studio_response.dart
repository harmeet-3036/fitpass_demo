
import 'data_response.dart';

class StudioResponse{

  final int code;
  final int total_results;
  final String message;
  final List<Data> dataList;

  StudioResponse({this.code,this.total_results,this.message,this.dataList});

  factory StudioResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;
    List<Data> dl;
    if(list!=null){
      dl = list.map((i) => Data.fromJson(i)).toList();
    }else
      {
        dl = new List();
      }


    return StudioResponse(
        code: json['code'],
        total_results: json['total_results'],
        message: json['message'],
        dataList: dl
    );
  }

}