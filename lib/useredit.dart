import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_5/colors.dart';
import 'package:flutter_application_5/deleteuser.dart';
import 'package:flutter_application_5/usercreate.dart';


import 'package:http/http.dart' as http;

class EditUser extends StatefulWidget {
  String userId;
  String first_name;
  String last_name;
  EditUser({required this.userId,required this.first_name,required this.last_name});
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {

  final _formKey = GlobalKey<FormState>();

  
  final TextEditingController _controllerFirst_Name = new TextEditingController();
  final TextEditingController _controllerLast_Name = new TextEditingController();
 

  String userId = '';
  @override
  void initState() {
    
    super.initState();


    setState(() {
      userId = widget.userId;
     _controllerFirst_Name.text = widget.first_name;
     _controllerLast_Name.text = widget.last_name;
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          SizedBox(height: 30,),
          TextFormField(
            controller: _controllerFirst_Name,
            cursorColor: primary,
            decoration:const InputDecoration(
              hintText: "First_Name",
            ),
             validator: (value) {
                   if (value!.isEmpty) {
                return "Please Enter first_name";
                  }
                return null;
                  },  
          ),
          SizedBox(height: 30,),
          TextFormField(
            controller: _controllerLast_Name,
            cursorColor: primary,
            decoration:const InputDecoration(
              hintText: "Last_Name",
            ),
             validator: (value) {
                   if (value!.isEmpty) {
                return "Please Enter last_name";
                  }
                return null;
                  },  
          ),
          SizedBox(height: 40,),
    
          ElevatedButton(
         
          onPressed: (){
            editUser();
            setState(() {
              setState(() async {
                  if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();         
            }});
            });
          }, child: Text("Done",style: TextStyle(color: white),))
        ],
      ),
    );
  }
 editUser() async {

    var first_name = _controllerFirst_Name.text;
    var last_name = _controllerLast_Name.text;
    if(first_name.isNotEmpty && last_name.isNotEmpty){
    
      var bodyData = json.encode({
    "first_name":first_name,
    "last_name":last_name,
    "nick_name":"venky1",
    "email":"venkatesh5256@gmail.com1",
    "password":"1234516",
    "dateofbirth":"2023-01-11",
    "gender":"M",
    "mobile":"96457812561",
    "address":"bangaloe1",
    "token":"N6&Sy{4;Hq`uQxr_"
      });
    
   var url = Uri.parse( "http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/govardhan/update/$userId");
      var response = await http.post(url,headers: {
        "Content-Type" : "application/json",
      },body: bodyData);
      log(response.body.toString());
      if(response.statusCode == 200){
        var messageSuccess = json.decode(response.body)['message'];
        showMessage(context,messageSuccess);
      }else {
         var messageError = "Can not update this user!!";
        showMessage(context,messageError);
      }
    }
  }
}


