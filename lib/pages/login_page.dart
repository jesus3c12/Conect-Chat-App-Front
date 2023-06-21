import 'package:conect_chat/helpers/mostrar_alerta.dart';
import 'package:conect_chat/services/socket_service.dart';
import 'package:conect_chat/widgets/btn_blue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:conect_chat/services/auth_service.dart';

import '../widgets/label.dart';
import '../widgets/logo.dart';
import 'package:conect_chat/widgets/custom_input.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics:  const BouncingScrollPhysics(),
          child: Container(
            height:  MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: const <Widget> [
                
                Logo( titulo: 'Soporte Conect',),
                  
                _Form(),
                  
                Labels( 
                  rute: 'register',
                  tittle: '¿No tienes una cuenta?',
                  subtittle: 'Crea una ahora!',
                ),
                  
                Text('Terminos y condiciones de uso', 
                style: TextStyle( 
                  fontWeight: FontWeight.w200
                ) ),
              ],
            ),
          ),
        ),
      )
    );
  }
}



class _Form extends StatefulWidget {

   const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>( context );

    return Container(
      margin: const EdgeInsets.only( top: 50 ),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      child:  Column(
        children: <Widget> [
          CustomInput(
            icon: Icons.mail_outlined,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl,
          ),

          BtnBlue(
            text: 'Ingrese', 
            onPressed: authService.autenticando 
            ? null 
            : () async {

              FocusScope.of(context).unfocus();

              
              final loginOk = await authService.login( 
                emailCtrl.text.trim(), 
                passCtrl.text.trim() 
              );
              if ( loginOk ) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
              } else {
                // Mostrar alerta
                mostrarAlerta(
                  context, 'Login incorrecto', 'Revise sus credenciales nuevamente'
                );
              }
            },
          )
        ],
      ),
    );
  }
}
