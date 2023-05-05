import 'dart:ffi';

import 'package:conect_chat/widgets/btn_blue.dart';
import 'package:conect_chat/widgets/custom_input.dart';
import 'package:flutter/material.dart';

import '../widgets/label.dart';
import '../widgets/logo.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});


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
                
                Logo(titulo: 'Registro'),
                  
                _Form(),
                  
                Labels( 
                  rute: 'login',
                  tittle: '¿Ya tienes una cuenta?',
                  subtittle: 'Ingresa ahora!',
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

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( top: 50 ),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      child:  Column(
        children: <Widget> [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
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
            onPressed: () {
              print( emailCtrl );
              print( passCtrl );
            },
          )
        ],
      ),
    );
  }
}
