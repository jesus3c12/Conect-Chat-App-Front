// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);
import 'package:conect_chat/models/user.dart';
import 'dart:convert';

UsuariosResponse usuariosResponseFromJson(String str) => 
  UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) => 
  json.encode(data.toJson());

class UsuariosResponse {
    final bool ok;
    final List<Usuario> usuarios;

    UsuariosResponse({
        required this.ok,
        required this.usuarios,
    });

    factory UsuariosResponse.fromJson(Map<String, dynamic> json) => 
    UsuariosResponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(
          json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}

