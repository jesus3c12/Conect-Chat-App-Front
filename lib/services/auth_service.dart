import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:conect_chat/global/enviroment.dart';

import 'package:conect_chat/models/login_response.dart';
import 'package:conect_chat/models/user.dart';

class AuthService with ChangeNotifier {

  late Usuario usuario;
  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estatica
  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future<bool> login( String email, String password ) async {

    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Enviroment.apiUrl }/login');

    final resp = await http.post(uri, 
      body: jsonEncode(data), 
      headers: {
        'Content-Type' : 'application/json'
      }
    );

    autenticando = false;

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }

  }

  Future register ( String nombre, String email, String password ) async {

    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Enviroment.apiUrl }/login/new');

    final resp = await http.post(uri, 
      body: jsonEncode(data), 
      headers: {
        'Content-Type' : 'application/json'
      }
    );

    autenticando = false;

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${ Enviroment.apiUrl }/login/renew');


    final resp = await http.get(uri, 
  
      headers: {
        'Content-Type' : 'application/json',
        'x-token': token
      }
    );


    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken( String token ) async {

    return await _storage.write( key: 'token', value: token );

  }

  Future logout() async {
    await _storage.delete( key: 'token' );
  }

}