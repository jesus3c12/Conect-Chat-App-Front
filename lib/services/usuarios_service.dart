import 'package:http/http.dart' as http;
import 'package:conect_chat/global/enviroment.dart';
import 'package:conect_chat/models/usuarios_response.dart';
import 'package:conect_chat/services/auth_service.dart';
import 'package:conect_chat/models/user.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    String? token = await AuthService.getToken();
    try {

        final uri = Uri.parse('${ Enviroment.apiUrl }/usuarios');

        final resp = await http.get(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': '$token'
        }
      );

      final usuariosResponse = usuariosResponseFromJson( resp.body );

      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }

  }
}