import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'model/data_response.dart';
import 'model/login_request.dart';
import 'model/studio_response.dart';

class HomeScreen extends StatefulWidget{

  final LoginRequest loginRequest;

  HomeScreen({this.loginRequest});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}


class HomeScreenState extends State<HomeScreen>{

  Future<StudioResponse> _studioResponse ;

  @override
  void initState() {
    super.initState();
    _studioResponse = fetch(widget.loginRequest.user_id, widget.loginRequest.app_key);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(


      appBar: AppBar(

        title: Text('Home Screen',style: TextStyle(fontSize: 18),),
      ),
      body: getFutureBuilder(),
    );
  }


  Widget getFutureBuilder(){

    return FutureBuilder(builder:(BuildContext context, AsyncSnapshot<StudioResponse> snapshot){
      if (snapshot.connectionState == ConnectionState.none &&
          snapshot.hasData == null) {
        return Container();
      }
      if(snapshot.hasData){
        if(snapshot.data.code==200)
        return getListViewWidget(snapshot.data.dataList);
        else
          return Center(
            child: Container(child:Column(

              children: <Widget>[
                Text('code: ${snapshot.data.code}'),
                Text('msg: ${snapshot.data.message}')
              ],
            )),
          );
      }

      else
        return Center(child: CircularProgressIndicator());
    }
    ,future: _studioResponse,);
  }

  Widget getListViewWidget(List<Data> dataList){

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text('name: ${dataList[index].name}'),
              Text('category: ${dataList[index].category}'),
              Text('location: ${dataList[index].locality}')
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),

    );
  }


  /////////////////////////////////////////////////////////////////////////////
  //
  //
  //              /*
  //              *  Fetch API response from backend
  //              * */
  //
  //
  //  /////////////////////////////////////////////////////////////////////////////


  Future<StudioResponse> fetch(int userId,String appKey) async{

    Position _myPosition;
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {

      _myPosition = position;

    }).catchError((e) {
      print(e);
      throw Exception(e);
    });

    return fetchData(userId,appKey,_myPosition.latitude,_myPosition.longitude);
  }

  Future<StudioResponse> fetchData(int userId,String appKey,double lat,double lng) async {
    final response = await http.get('http://api.fitpass.dev/customer/studios?page_number=1&latitude'
        '=$lat&longitude=$lng',headers:

    <String,String>{
      'x-appkey':'508048CEA704E7718091B81AE378267A',
      'x-authkey':'dgfJlO10QAoZzaiT8FXrF8bgBBQ5jghe7FNrd9t8D0u',
      'http-x-device-type':'sfgsdhfsdhsd',
      'x-user-id':'1',
      'x-device_token':'kjjsfhsdkjfhdsfsadkfshdafsadfhsa',
      'x-device-type':'android',
      'x-app-version':'5.4.91',
      'x-device-name':'Moto G4',
      'x-device-os':'7.0.1',
      'Content-Type':'application/x-www-form-urlencoded',
      'X-HEADER-PAYLOAD':'TCqKj0/jIxfgghJha5aYfDbEE/9R0Ccsai80MjJg1s+BXaYE5CbKDCjMPZ/Cn4y7PISHm3YZXrjqKyk3RNMr4Uirtn6Q1rGq79c8OHOstljbnuZKXrm7g6ClLwXHdVleFkaoOlli6WO5f8QRj0npWZQS',
      'X-device-id':'123',

    }
    );


    if (response.statusCode == 200) {
      print(response.body);
      StudioResponse studioResponse = StudioResponse.fromJson(json.decode(response.body));
      return studioResponse;

    } else {
      throw Exception('fetching failed');
    }
  }
}