import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hackware/services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight, _deviceWidth;

  FirebaseService? _firebaseService;

  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

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
            children: [
              _headerWidget(),
              _loginForm(),
              _loginButton(),
              _registerPageLink()
            ],
          ),
        ),
      )),
    );
  }

  Widget _headerWidget() {
    return Column(
      children: [
        Container(
          width: _deviceWidth! * 0.5,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            "Eco Soil",
            style: TextStyle(
              color: Colors.green,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade200,
          ),
          child: Center(
            child: Icon(
              Icons.eco,
              size: 50,
              color: Colors.green.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginForm() {
    return Container(
      height: _deviceHeight! * 0.23,
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _emailTextField(),
              SizedBox(
                height: 10,
              ),
              _passwordTextField()
            ],
          )),
    );
  }

  Widget _emailTextField() {
    return Container(
      height: _deviceHeight! * 0.1,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          labelText: "Email",
          hintText: "example@domain.com",
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24),
        ),
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
          if (_value.length == 0)
            return "Please enter an email!";
          else if (!_result)
            return "Invalid email format";
          else
            return null;
        },
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
        height: _deviceHeight! * 0.1,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.password),
              labelText: "Password",
              hintText: "Enter a strong password...",
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            onSaved: (_value) {
              setState(() {
                _password = _value;
              });
            },
            validator: (_value) {
              if (_value!.length == 0)
                return "Please enter a password!";
              else if (_value!.length < 6)
                return "Enter a password longer than 6 characters";
              else
                return null;
            }));
  }

  Widget _loginButton() {
    return Container(
      width: _deviceWidth! * 0.7,
      height: _deviceHeight! * 0.06,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: _loginUser,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: Text(
        "Don't have an account?",
        style: TextStyle(
            color: Colors.blue.shade600,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline),
      ),
    );
  }

  void _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool _result = await _firebaseService!
          .loginUser(email: _email!, password: _password!);

      if (_result)
        Navigator.popAndPushNamed(context, 'home');
      else {
        setState(() {
          _email = "";
          _password = "";
        });
        _loginFormKey.currentState!.reset();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext _context) {
              return AlertDialog(
                  backgroundColor: Colors.red,
                  title: Row(
                    children: [
                      Icon(Icons.cancel_sharp, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "Invalid credentials!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ));
            });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      }
    }
  }
}
