import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';
import 'model/login_request.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitpass Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Fitpass Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FocusNode _focusNode = new FocusNode();
  String username,password;
  GlobalKey<FormState> _globalKey = new GlobalKey();
  bool autoValidate = false;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       resizeToAvoidBottomPadding: false,
      appBar: AppBar(

        title: Text(widget.title),
      ),

      body: Stack(
        children: _buildForm(context),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  List<Widget> _buildForm(BuildContext context) {
    Form form = new Form(
      child: Padding(padding: EdgeInsets.fromLTRB(20,80,20,20),child:

      Form(child: Column(

        children: <Widget>[
          usernameTextField(),
          passwordTextField(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: nextButton(),
          )

        ],
      ),autovalidate: autoValidate,key: _globalKey,)
        ,)
    );

    var l = new List<Widget>();
    l.add(form);

    if (_loading) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      l.add(modal);
    }

    return l;
  }
  Widget usernameTextField(){
    return TextFormField(
      maxLines: 1,
      style: TextStyle(fontSize: 18,color: Colors.black,),
      textInputAction:  TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Enter Username',

      ),
      onSaved: (value){
        username = value;
      },
      onEditingComplete: (){

        FocusScope.of(context).requestFocus(_focusNode);
      },
      validator: (String str){

        if(str.isEmpty){
          return 'Username must not be empty';
        }

      },
    );
  }

  Widget passwordTextField(){
    return TextFormField(
      maxLines: 1,
      obscureText: true,
      focusNode :_focusNode,
      style: TextStyle(fontSize: 18,color: Colors.black,),
      textInputAction:  TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'Enter password',

      ),
      onSaved: (value){
        password = value;
      },
        validator: (String str){

          if(str.isEmpty){
            return 'pasword must not be empty';
          }

        }
    );
  }

  Widget nextButton() {

    return RaisedButton(

      color: Colors.red,
      onPressed: (){

         validateInputs();

      },child: Text('Next',style: TextStyle(color: Colors.white,fontSize: 18),),
    );

  }




  void validateInputs(){

    if(_globalKey.currentState.validate()){

      _globalKey.currentState.save();

      setState(() {
        _loading = true;
      });

      doLogin(username, password).then((loginDetails) =>
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext bc)=>
              HomeScreen(loginRequest: loginDetails,))));
    }else{

      autoValidate = true;
    }
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


  Future<LoginRequest> doLogin(String username,String password) async {
    final response = await http.post('http://api.fitpass.dev/customer/loginwithsocialmedia',headers:

    <String,String>{
    'x-appkey':'rcmroes1UWF2GIcBBQ5jghe6xpwoQ4vqDqoIIcBTbZEE6',
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

    },body: jsonEncode(<String, String>{
      'mobile_no': username,
      'password': password,
    }
    ));


    setState(() {
      _loading = false;
    });
    if (response.statusCode == 200) {
      LoginRequest loginRequest = LoginRequest.fromJson(json.decode(response.body));
      return loginRequest;

    } else {
      throw Exception('login failed');
    }
  }
}
