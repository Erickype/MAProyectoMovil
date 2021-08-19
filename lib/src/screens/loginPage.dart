import 'package:flutter/material.dart';
import 'package:proyecto/src/conecction/serverController.dart';
import 'package:proyecto/src/models/user.dart';

class LoginPage extends StatefulWidget {
  final ServerController _serverController;

  const LoginPage(this._serverController, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  var user = User(userId: "user1", password: "1");
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userId = "";
  String password = "";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.cyanAccent,
                  Colors.lightBlue,
                ]),
              ),
              child: Image.asset(
                "assets/images/loginIcon.png",
                color: Colors.black45,
                height: 200,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Usuario",
                          ),
                          onSaved: (value) {
                            userId = value as String;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Campo Obligatorio";
                            }
                          },
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                          ),
                          onSaved: (value) {
                            password = value as String;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Campo Obligatorio";
                            }
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 40),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(indicatorColor: Colors.yellow),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                _login(context);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Ingresar",
                                ),
                                if (_loading)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.only(left: 20),
                                    child: CircularProgressIndicator(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red,
                              fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    if (!_loading) {
      setState(() {
        _errorMessage = "";
      });

      User? user = await widget._serverController.login(userId, password);

      if (user.userId != "") {
        Navigator.of(context).pushReplacementNamed("/home", arguments: user);
      } else {
        setState(() {
          _errorMessage = "Usuario o contraseña incorrectos!!";
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
