import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Color(0xFFf4511e),
      onPressed: _onPressed,
      child: Text('Register'),
    );
  }
}