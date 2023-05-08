import 'package:conect_chat/pages/login_page.dart';
import 'package:conect_chat/pages/users_page.dart';
import 'package:conect_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context, snapshot ) {
        return Center(
          child: Text('Esoere...'),
           );
        },
      ),
   );
  }

  Future checkLoginState ( BuildContext context ) async {

    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if ( autenticado ) {
      // TODO: conectar al socket server
      //Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => UsersPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    } else { 
       Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    }


  }
}