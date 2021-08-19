import 'dart:convert';

import 'package:proyecto/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/src/models/userProcess.dart';
import 'package:proyecto/src/models/validationDetails.dart';

class ServerController {
  static const API = "http://20.83.40.78/ma/views";

  Future<User> login(String userId, String password) async {
    return http
        .get(Uri.parse(
            API + "/login.php?ced_usu=" + userId + "&cla_cue=" + password))
        .then((data) {
      final user = User(userId: "", password: "");
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        if (jsonData["0"] != null) {
          user.userId = jsonData["0"]["ced_usu"];
          user.password = jsonData["0"]["cla_cue"];
        }
      }
      return user;
    });
  }

  Future<List<UserProcess>> procesosCargo(String userId) async {
    return http
        .get(Uri.parse(API + "/procesosAcargo.php?id_res_pro=" + userId))
        .then((data) {
      final processes = <UserProcess>[];
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        if (jsonData["0"] != null) {
          for (var i = 0; i < jsonData.length; i++) {
            var process = UserProcess(
                processId: jsonData[i.toString()]["id_pro"],
                processName: jsonData[i.toString()]["nom_pro"],
                processDate:
                    DateTime.parse(jsonData[i.toString()]["fec_hor_pro"]),
                processState: jsonData[i.toString()]["est_pro"]);

            processes.add(process);
            print(process);
          }
        }
      }
      return processes;
    });
  }

  Future<List<User>> detalleProcesoUsuarios(String processId) async {
    return http
        .get(Uri.parse(API + "/verActivoDetalle.php?id_val_per=" + processId))
        .then((data) {
      final processes = <User>[];
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        if (jsonData["0"] != null) {
          for (var i = 0; i < jsonData.length; i++) {
            var process = User(
                userId: jsonData[i.toString()]["ced_usu"],
                password: jsonData[i.toString()]["nom_usu"]);

            processes.add(process);
            print(process);
          }
        }
      }
      return processes;
    });
  }

  Future<List<ValidationDetails>> detalleActivos(
      String processId, String userId) async {
    return http
        .get(Uri.parse(API +
            "/detallXVista.php?id_val_per=" +
            processId +
            "&ced_usu=" +
            userId))
        .then((data) {
      final details = <ValidationDetails>[];
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        if (jsonData["0"] != null) {
          for (var i = 0; i < jsonData.length; i++) {
            var detail = ValidationDetails(
                idActivo: jsonData[i.toString()]["id_act_per"],
                estadoActivo: jsonData[i.toString()]["est_val"],
                nombreActivo: jsonData[i.toString()]["nom_act"],
                codigoBarras: jsonData[i.toString()]["cod_bar_act"],
                descripcion: jsonData[i.toString()]["des_act"]);

            details.add(detail);
            print(detail);
          }
        }
      }
      return details;
    });
  }

  Future observacionActivo(
      String idActivo, String abservacionAct) async {
    return http
        .get(Uri.parse(API +
            "/actualizarObser.php?id_act=" +
            idActivo +
            "&des_act=" +
            abservacionAct))
        .then((data) {
      if (data.statusCode == 200) {
      }
      return "";
    });
  }

  Future updateDetalleActivos(
      String processId, String activeId, String valState) async {
    return http
        .get(Uri.parse(API +
            "/actulizarDetalle.php?id_act_per=" +
            activeId +
            "&id_val_per=" +
            processId +
            "&est_val=" +
            valState))
        .then((data) {
      return "";
    });
  }

  Future endValidationProcess(String processId) async {
    return http
        .get(Uri.parse(API + "/estaValidacion.php?id_pro=" + processId))
        .then((data) {
      return "";
    });
  }
}
