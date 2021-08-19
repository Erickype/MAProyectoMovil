import 'package:flutter/material.dart';
import 'package:proyecto/src/conecction/serverController.dart';
import 'package:proyecto/src/models/user.dart';
import 'package:proyecto/src/models/userProcess.dart';

class HomePage extends StatefulWidget {
  final User loggedUser;
  final ServerController _serverController;

  HomePage(this._serverController, this.loggedUser, {Key? key})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<UserProcess> processes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Validación de activos",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.red[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: ListView.separated(
        itemCount: processes.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
          color: Colors.black,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              processes[index].processName,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            subtitle: Text(
                "Fecha creación ${formatDateTime(processes[index].processDate)}"),
            onTap: () {
              var args = {
                "user": User(userId: "", password: ""),
                "processId": processes[index].processId,
                "processName": processes[index].processName
              };

              Navigator.of(context)
                  .pushNamed("/validateProcess", arguments: args)
                  .then((value) async {
                processes = await widget._serverController
                    .procesosCargo(widget.loggedUser.userId);
                if (!mounted) return;
                setState(() {});
              });
            },
          );
        },
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  void initState() {
    _fetchNotes();

    super.initState();
  }

  void _fetchNotes() async {
    processes =
        await widget._serverController.procesosCargo(widget.loggedUser.userId);
    setState(() {});
  }
}
