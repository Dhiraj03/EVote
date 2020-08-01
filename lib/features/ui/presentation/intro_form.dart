import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/database/firestore_repository.dart';
import 'package:e_vote/features/ui/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/typicons_icons.dart';

class IntroForm extends StatefulWidget {
  final FirestoreRepository firestoreRepository;
  IntroForm({Key key, @required this.firestoreRepository}) : super(key: key);
  @override
  _IntroFormState createState() => _IntroFormState();
}

class _IntroFormState extends State<IntroForm> {
  final TextEditingController privateKeyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  final UserRepository userRepository = UserRepository();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
              controller: privateKeyController,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Private Key',
              )),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              icon: Icon(Typicons.address),
              labelText: 'Ethereum Address',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              disabledColor: Colors.blue,
              disabledTextColor: Colors.black,
              child: Text('Submit'),
              onPressed: () async {
                BlocProvider.of<DashboardBloc>(context).add(RegisterUser(
                    address: addressController.text,
                    privateKey: privateKeyController.text));
              })
        ],
      ),
    ));
  }
}
