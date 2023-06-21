import 'package:conect_chat/models/mensajes_reponse.dart';
import 'package:conect_chat/models/user.dart';
import 'package:conect_chat/global/enviroment.dart';
import 'package:conect_chat/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioID ) async {
    String? token = await AuthService.getToken();

    final uri = Uri.parse('${ Enviroment.apiUrl }/mensajes/$usuarioID');

    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': '$token'
      }
    );

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes; 
  }
}