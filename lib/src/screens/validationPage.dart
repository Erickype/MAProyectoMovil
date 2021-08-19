import 'package:flutter/material.dart';
import 'package:proyecto/src/conecction/serverController.dart';
import 'package:proyecto/src/models/user.dart';

class ValidationPage extends StatefulWidget {
  final User userLogged;
  final String processId;
  final String processName;
  final ServerController _serverController;

  const ValidationPage(
      this.userLogged, this._serverController, this.processId, this.processName,
      {Key? key})
      : super(key: key);

  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  late List<User> processDetail = [];
  var arguments = {'processId': "", 'userId': "", 'userName': ""};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.processName,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: processDetail.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0,
                color: Colors.black,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(
                        "Nombre: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      Text(
                        processDetail[index].password,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text("Cédula ${processDetail[index].userId}"),
                  onTap: () {
                    arguments["processId"] = widget.processId;
                    arguments["userId"] = processDetail[index].userId;
                    arguments["userName"] = processDetail[index].password;
                    print(arguments);
                    Navigator.of(context)
                        .pushNamed("/validateDetail", arguments: arguments);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Aviso"),
                            content: Text("¿Desea finalizar el proceso?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    widget._serverController
                                        .endValidationProcess(widget.processId);
                                    
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Aceptar")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(context);
                                  },
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          );
                          
                        }).then((value) => Navigator.of(context).pop());

                    //Navigator.of(context).pop();
                  },
                  child: Text("Finalizar"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green[400] as Color)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  void _fetchNotes() async {
    setState(() {});

    processDetail =
        await widget._serverController.detalleProcesoUsuarios(widget.processId);

    setState(() {});
  }
}
