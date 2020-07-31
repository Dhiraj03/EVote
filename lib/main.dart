import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend/Election.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Election>(
      create: (BuildContext context) => Election(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Vote',
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var election = Provider.of<Election>(context);
    return Scaffold(
      floatingActionButton: IconButton(icon: Icon(Icons.person), onPressed:() async 
      {
        election.addCandidate(
          'Dhiraj', 
          'lmao', 
          '2c2185a2dbcfb803ad01fae71bd34916c4a0d469a52fec6c0d6c126195f2d3f1'
          );
      }),
      appBar: AppBar(
        title: const Text('E-Vote'),
      ),
      body: Container(
        child: const Center(
          child: Text('Welcome to E-Vote'),
        ),
      ),
    );
  }
}
