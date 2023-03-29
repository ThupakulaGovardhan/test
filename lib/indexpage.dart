import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_5/colors.dart';
import 'package:flutter_application_5/usercreate.dart';
import 'package:flutter_application_5/useredit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:http/http.dart' as http;



class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;
  @override
  void initState() {
    
    super.initState();
    this.fetchUser();
  }
  fetchUser() async {
    setState(() {
      isLoading = true;
    });
 
 var url = Uri.parse( "http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/govardhan/fetch?token=N6%26Sy{4;Hq`uQxr_");
    var response = await http.get(url);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      setState(() {
        users = items;
        isLoading = false;
      });
    }else{
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listing Users"),
        actions: <Widget>[
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUser()));
          }, child: Icon(Icons.add,color: white,))
        ],
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    if(isLoading || users.length == 0){
      return Center(child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      )
      );
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context,index){
      return cardItem(users[index]);
    });
  }
  Widget cardItem(item){
    var first_name = item['first_name']??'';
    var last_name = item['last_name']??'';

    return Card(
      
         child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
           child: Container( 
            color: Colors.white, 
            child: ListTile( title: Text(first_name),
             subtitle: Text(last_name),
              ),
              ),
              secondaryActions: <Widget>[
           IconSlideAction(
              caption: 'Edit',
              color: Colors.blueAccent,
              icon: Icons.edit,
              onTap: () => editUser(item),
           ),
           IconSlideAction(
             caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => showDeleteAlert(context,item),  
        
        ),  ]
         ),
    );
  }


  editUser(item){
    var userId = item['id'].toString();
    var first_name = item['first_name'].toString();
    var last_name = item['last_name'].toString();
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditUser(userId: userId,first_name: first_name,last_name: last_name,)));
  }
  deleteUser(userId) async {
   
  var url = Uri.parse( 'http://ec2-3-137-201-63.us-east-2.compute.amazonaws.com/api/govardhan/delete/$userId?token=N6%26Sy{4;Hq`uQxr_');
    var response = await http.post(url,headers: {
      "Content-Type" : "application/json",
    });
    log(response.body.toString());
    if(response.statusCode == 200){
      this.fetchUser();
    }
  }
  showDeleteAlert(BuildContext context,item) {
    Widget noButton = ElevatedButton(
      child: Text("No",style: TextStyle(color: primary),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = ElevatedButton(
      child: Text("Yes",style: TextStyle(color: primary)),
      onPressed:  () {
        Navigator.pop(context);
       
        deleteUser(item['id']);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Would you like to delete this user?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}