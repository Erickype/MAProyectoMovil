import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:proyecto/src/conecction/serverController.dart';
import 'package:proyecto/src/models/validationDetails.dart';

class DetailPage extends StatefulWidget {
  final ServerController _serverController;
  final String processId;
  final String userId;
  final String userName;

  DetailPage(this._serverController, this.processId, this.userId, this.userName,
      {Key? key})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<ValidationDetails> processDetail = [];
  String scanResult = "";
  late List<bool> _visibility = [];
  late List<TextEditingController> _textController = [];
  late String _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userName,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await scanBarcode();
         final snackbar = SnackBar(content: Text(_message));
         ScaffoldMessenger.of(context).showSnackBar(snackbar); 
        },
        
        child: Icon(Icons.camera_alt),
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
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            processDetail[index].nombreActivo,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (_visibility[index] == false) {
                                        _visibility[index] = true;
                                      } else {
                                        _visibility[index] = false;
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.note_add),
                                  label: Text("")),
                              Switch(
                                  key: Key(index.toString()),
                                  value:
                                      processDetail[index].estadoActivo == "R"
                                          ? false
                                          : true,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      if (processDetail[index].estadoActivo ==
                                          "R") {
                                        processDetail[index].estadoActivo =
                                            "OK";
                                      } else {
                                        processDetail[index].estadoActivo = "R";
                                      }
                                    });
                                  }),
                            ],
                          )
                        ],
                      ),
                      Visibility(
                        visible: _visibility[index],
                        child: Container(
                          child: TextField(
                            maxLength: 50,
                            controller: _textController[index],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Observación',
                            ),
                            onEditingComplete: () {
                              processDetail[index].descripcion =
                                  _textController[index].text;
                              widget._serverController.observacionActivo(
                                  processDetail[index].idActivo,
                                  processDetail[index].descripcion);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  //subtitle: Text("Cédula ${processDetail[index].userId}"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    for (var i = 0; i < processDetail.length; i++) {
                      widget._serverController.updateDetalleActivos(
                          widget.processId,
                          processDetail[i].idActivo,
                          processDetail[i].estadoActivo);
                    }
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 1), () {
                            var count = 0;
                            Navigator.popUntil(context, (route) {
                              return count++ == 2;
                            });
                          });
                          return AlertDialog(
                            title: Text("Éxito"),
                            content: Text("Activos validados"),
                          );
                        });
                    //Navigator.of(context).pop();
                  },
                  child: Text("Guardar"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green[400] as Color)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.red[400] as Color)),
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

    processDetail = await widget._serverController
        .detalleActivos(widget.processId, widget.userId);

    for (var i = 0; i < processDetail.length; i++) {
      _visibility.add(false);
      _textController.add(TextEditingController());
    }

    setState(() {});
  }

  Future<void> scanBarcode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6655", "Cancelar", true, ScanMode.BARCODE);
      print("ESTE ES EL RESULTADO:" + scanResult);
    } on PlatformException {
      scanResult = "Algo salió mal!!";
    }

    if (!mounted) return;

    setState(() {
      for (var i = 0; i < processDetail.length; i++) {
        if (processDetail[i].codigoBarras == scanResult &&
            processDetail[i].estadoActivo == "R") {
          processDetail[i].estadoActivo = "OK";
          _message = processDetail[i].nombreActivo + " validado!";
          break;
        } else {
          _message = processDetail[i].nombreActivo + " ya está validado!";
          break;
        }
      }
    });
  }
}
