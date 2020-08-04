import 'package:e_vote/backend/Election.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:e_vote/backend/Candidate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

String adminkey='';


class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<String> Address = <String>[];
  final List<String> Key = <String>[];
  final List<String> Proposal = <String>[];
Election election=Election();


  TextEditingController candidateControlleraddress = TextEditingController();
  TextEditingController candidateControllerkey = TextEditingController();
  TextEditingController candidateControllerproposal = TextEditingController();

  void checkifempty() {
    String text1,text2,text3 ;

    // Getting Value From Text Field and Store into String Variable
    text1 = candidateControlleraddress.text ;
    text2 = candidateControllerkey.text ;
    text3 = candidateControllerproposal.text ;

    // Checking all TextFields.
    if(text1 == '' || text2 == '' || text3 == '')
    {
      // Put your code here which you want to execute when Text Field is Empty.
      print('Text Field is empty, Please Fill All Data');

    }else{

      ;
    }

  }


  void addCandidatesToList() {
    setState(() {
      Address.insert(0, candidateControlleraddress.text);
      Key.insert(0, candidateControllerkey.text);
      Proposal.insert(0, candidateControllerproposal.text);
    });
  }
  bool isNameValid = true;
  RegExp regExp = new RegExp(r'^[a-zA-Z]+$',);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('               CANDIDATES'),
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, false),
        ),
      ),
      backgroundColor: Colors.white,

      body:
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: candidateControlleraddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CANDIDATE NAME',
                  errorText: isNameValid ? null : "Invalid name"
              ),
            ),

          ),
          SizedBox(height: 15.0),

          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              onChanged: (value){
                if(regExp.hasMatch(value)){
                  isNameValid = true;
                } else {
                  isNameValid = false;
                }
                setState(() {

                });
              },
              controller: candidateControllerkey,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ADMIN PRIVATE KEY',
                  errorText: isNameValid ? null : "Invalid name"
              ),
            ),

          ),

          SizedBox(height: 15.0),

          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(

              controller: candidateControllerproposal,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CANDIDATE PROPOSAL',
                  errorText: isNameValid ? null : "Invalid name"
              ),
            ),
          ),

          RaisedButton(
            child: Text('ADD'),
            onPressed: () async{
              addCandidatesToList();
              adminkey=candidateControllerkey.text;
              election.addCandidate(candidateControlleraddress.text,candidateControllerproposal.text , adminkey);

              candidateControllerkey.clear();
              candidateControlleraddress.clear();
              candidateControllerproposal.clear();


            },
          ),
          SizedBox(height: 15.0),

          RaisedButton(
            child: Text('PROCEED'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Thirdroute()));
            },
          ),






          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: Address.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70.0,
                    margin: EdgeInsets.all(2),
                    color: Colors.deepPurpleAccent,
                    child: Center(
                      child: Text(
                        ' CANDIDATE ${index + 1} :- \n'
                            'NAME: ${Address[index]} \n'
                            'PROPOSAL: ${Proposal[index]}',
                        style: TextStyle(fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),

                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );

  }
}



class Thirdroute extends StatefulWidget {
  @override
  _ThirdrouteState createState() => _ThirdrouteState();
}

class _ThirdrouteState extends State<Thirdroute> {
  final List<String> Addressv = <String>[];
  final List<String> Keyv = <String>[];
  TextEditingController voterControlleraddress = TextEditingController();
  TextEditingController voterControllerkey = TextEditingController();
  Election election=Election();

  void addvotersToList() {
    setState(() {
      Addressv.insert(0, voterControlleraddress.text);
      Keyv.insert(0, voterControllerkey.text);

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('                    VOTERS'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        backgroundColor: Colors.white,

        body:
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: voterControlleraddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'VOTER ADDRESS',
                ),
              ),

            ),
            SizedBox(height: 20.0),

            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: voterControllerkey,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'VOTER NAME',
                ),
              ),

            ),
            RaisedButton(
              child: Text('ADD'),
              onPressed: () async{
                addvotersToList();
                election.addVoter(voterControlleraddress.text, adminkey);
                voterControllerkey.clear();
                voterControlleraddress.clear();

              },
            ),
            SizedBox(height: 20.0),

            RaisedButton(
              child: Text('PROCEED'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Firstroute()));
              },
            ),






            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: Addressv.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 70.0,
                      margin: EdgeInsets.all(2),
                      color: Colors.deepPurpleAccent,
                      child: Center(
                        child: Text(
                          ' CANDIDATE ${index+1} :- \n ADDRESS: ${Addressv[index]} \n NAME: ${Keyv[index]}',
                          style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      );


  }
}

class Firstroute extends StatelessWidget {
  Election election=Election();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),

      backgroundColor: Colors.white,

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: 205.0,
              height: 700.0,
              child: Card(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'Start a new Election',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 21.0,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 100.0,
                      height: 200.0,),

                    RaisedButton(
                      textColor: Colors.black,
                      color: Colors.white,
                      child: Text(
                        'START',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async{
                       election.startElection(adminkey);
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                    SizedBox(height: 150.0),
                    Icon(
                      Icons.check,
                      size: 100.0,
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 50.0),

            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: 205.0,
              height: 700.0,
              child: Card(
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'End an Election',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 21.0,
                        ),
                      ),
                    ),

                    SizedBox(
                        width: 50.0,
                        height: 200.0),

                    RaisedButton(

                      textColor: Colors.black,
                      color: Colors.white,
                      child: Text(
                        'END',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async{
                      election.endElection(adminkey);
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                    SizedBox(height: 150.0),

                    Icon(
                      Icons.clear,
                      size: 100.0,
                    ),
                  ],
                ),
              ),

            ),

          ],
        ),
      ),
    );












  }
}


