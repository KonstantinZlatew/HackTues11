import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  final GlobalKey<FormState> _registerFormState = GlobalKey<FormState>();

  String? _name, _email, _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_titleWidget(), _registrationForm(), _registerButton()],
        ),
      ),
    )));
  }

  Widget _titleWidget() {
    return const Text(
      "Eco Soil",
      style: TextStyle(
          fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }

  Widget _registrationForm() {
    return Container(
      height: _deviceHeight! * 0.3,
      child: Form(
          key: _registerFormState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _nameTextField(),
              _emailTextField(),
              _passwordTextField()
            ],
          )),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Name..."),
      validator: (_value) => _value!.length > 0 ? null : "please enter a name.",
      onSaved: (_value) {
        setState(() {
          _name = _value;
        });
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Email..."),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (_value) {
        bool _result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return _result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(hintText: "Password..."),
        onSaved: (_value) {
          setState(() {
            _password = _value;
          });
        },
        validator: (_value) => _value!.length > 6
            ? null
            : "Please enter a password greater than 6 char");
  }

  Widget _registerButton() {
    return MaterialButton(
      onPressed: _registerUser,
      minWidth: _deviceWidth! * 0.50,
      height: _deviceHeight! * 0.05,
      color: Colors.red,
      child: const Text(
        "Register",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      ),
    );
  }

  void _registerUser() {
    if (_registerFormState.currentState!.validate()) {
      print(true);
    } else {
      print(false);
    }
    if (_registerFormState.currentState!.validate()) {
      _registerFormState.currentState!.save();
    }
  }
}
