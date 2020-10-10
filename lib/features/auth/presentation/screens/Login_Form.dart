import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:e_vote/features/auth/presentation/widgets/create_account_button.dart';
import 'package:e_vote/features/auth/presentation/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//the LoginForm widget is made Stateful so as to handle the TextEditingControllers' state.
class LoginForm extends StatefulWidget {
  // This instance UserRepository is received/injected from the LoginScreen widget.
  final UserRepository _userRepository;

  //The key is used to uniquely identify the form widget.
  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // An instance of LoginBloc has been provided by the parent widget (LoginScreen)
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  //Just checks if password and email are empty
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  
  //Checks if password and email are valid, and the state is not under submission
  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && !state.isSubmitting && isPopulated;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(
        context); //The parent class' bloc is used here.
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        //state.isFailure => email, password and failure are True, but submitting and success are false
        if (state.isFailure)
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );

        //state.isSubmitting => email, password and isSubmitting is true, whereas success and failure are false
        if (state.isSubmitting)
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        // state.isSuccess => email, password and success are true - LoggedIn() event is dispatched to the AuthBloc
        if (state.isSuccess) BlocProvider.of<AuthBloc>(context).add(LoggedIn());
      },
      child: BlocBuilder<LoginBloc, LoginState>(
          bloc: _loginBloc,
          builder: (BuildContext context, LoginState state) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                  child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Container(height: 110),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/colored-ballot-box.png", fit: BoxFit.contain)),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Email'),
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid  ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), labelText: 'Password'),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid password' : null;
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            LoginButton(
                              onPressed: isLoginButtonEnabled(state)
                                  ? _onFormSubmitted
                                  : null,
                            ),
                            CreateAccountButton(
                                userRepository: _userRepository),
                          ]))
                ],
              )),
            );
          }),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  /* The three functions responsible for dispatching the three different types of events - 
    EmailChanged, PasswordChanged and LoginWithCredentialsPassed
   */
  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted()
  {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text, 
        password: _passwordController.text)
    );
  }
}
