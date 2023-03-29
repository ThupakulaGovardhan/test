import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_5/colors.dart';
import 'package:flutter_application_5/deleteuser.dart';

import 'package:http/http.dart' as http;

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {

 final _formKey = GlobalKey<FormState>();


  final TextEditingController _controllerFirst_name = new TextEditingController();
  final TextEditingController _controllerLast_name = new TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Page"),
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
            controller: _controllerFirst_name,
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
         const SizedBox(height: 30,),
          TextFormField(
            controller: _controllerLast_name,
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
            createNewUser();
            setState(() async {
                  if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();         
            }});
          }, child: Text("Done",style: TextStyle(color: white),),),
        ],
      ),
    );
  }
  createNewUser() async {
    var first_name = _controllerFirst_name.text;
    var last_name = _controllerLast_name.text;
    if(first_name.isNotEmpty && last_name.isNotEmpty){
    
      var bodyData = json.encode({
        "first_name":first_name,
  "last_name": last_name,
  "nick_name": "venky",
  "email": "venkatesh5256@gmail.com1",
  "password": "1234516",
  "dateofbirth": "2023-01-11",
  "gender": "M",
  "mobile": "96457812561",
  "address": "bangaloe1",
  "token": "N6&Sy{4;Hq`uQxr_"
      });
      var url = Uri.parse( "http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/govardhan/create");
      var response = await http.post(url,headers: {
        "Content-Type" : "application/json",
       
      },body: bodyData);
      log(response.body.toString());
      if(response.statusCode == 200){
        var message = json.decode(response.body)['message'];
        showMessage(context,message);
        setState(() {
          _controllerFirst_name.text = "";
          _controllerLast_name.text = "";
          
        });
      }else {
        var messageError = "Can not create new user!!";
        showMessage(context,messageError);
      }

    }
  }
}