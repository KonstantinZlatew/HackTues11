import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hackware/services/firebase_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  final GlobalKey<FormState> _registerFormState = GlobalKey<FormState>();

  FirebaseService? _firebaseService;

  String? _name, _email, _password;

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
          children: [_headerWidget(), _registrationForm(), _registerButton()],
        ),
      ),
    )));
  }

  Widget _headerWidget() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.green,
                    size: 40,
                  )),
            ),
            SizedBox(
              width: _deviceWidth! * 0.07,
            ),
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
          ],
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
    return Container(
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
          icon: Icon(Icons.person),
          labelText: "Name",
          hintText: "e.g. Jane Smith",
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        validator: (_value) =>
            _value!.length > 0 ? null : "please enter a name.",
        onSaved: (_value) {
          setState(() {
            _name = _value;
          });
        },
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
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
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24),
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
          },
        ));
  }

  Widget _registerButton() {
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
        onPressed: _registerUser,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Text(
          "Register",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  void _registerUser() async {
    if (_registerFormState.currentState!.validate()) {
      _registerFormState.currentState!.save();
      bool _result = await _firebaseService!
          .registerUser(name: _name!, email: _email!, password: _password!);
      if (_result) Navigator.pop(context);
    }
  }
}
