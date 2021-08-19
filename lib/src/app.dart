import 'package:flutter/material.dart';
import 'package:proyecto/src/conecction/serverController.dart';
import 'package:proyecto/src/models/user.dart';
import 'package:proyecto/src/screens/homePage.dart';
import 'package:proyecto/src/screens/loginPage.dart';
import 'package:proyecto/src/screens/validationDetailPage.dart';
import 'package:proyecto/src/screens/validationPage.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activos',
      initialRoute: "/",
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.lightBlue,
          indicatorColor: Colors.white),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginPage(_serverController);
            case "/home":
              User userLogged = settings.arguments as User;
              return HomePage(_serverController, userLogged);
            case "/validateProcess":
              Map<dynamic, dynamic> process = settings.arguments as Map;
              return ValidationPage(
                  process["user"],_serverController, process["processId"], process["processName"]);
            case "/validateDetail":
              Map<String, String> arguments =
                  settings.arguments as Map<String, String>;
              return DetailPage(
                  _serverController,
                  arguments["processId"] as String,
                  arguments["userId"] as String,
                  arguments["userName"] as String);
            default:
              return ElevatedButton(
                  onPressed: () {}, child: Text("Error 404!"));
          }
        });
      },
    );
  }
}
