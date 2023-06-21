import 'dart:io';

import 'package:conect_chat/models/mensajes_reponse.dart';
import 'package:conect_chat/services/auth_service.dart';
import 'package:conect_chat/services/chat_services.dart';
import 'package:conect_chat/services/socket_service.dart';
import 'package:conect_chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode =  FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {

    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on( 'mensaje-personal', _listenMessage );

    _historyMessages( chatService.usuarioPara.uid );
  }
  void _historyMessages( String usuarioID ) async {

    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((m) => ChatMessage(
      text: m.mensaje, 
      uid: m.de, 
      animationController: AnimationController(
        vsync: this, duration: Duration( milliseconds: 0))
        ..forward(),
    ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage( dynamic payload) {
    
    ChatMessage message = ChatMessage(
      text: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5,
        title: Column(
          children: <Widget> [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 16,
              child: Text( usuarioPara.nombre.substring(0, 2), 
              style: const TextStyle(fontSize: 14 ) ),
            ),
            const SizedBox( height: 3 ),
            Text( usuarioPara.nombre, 
            style: const TextStyle( color:  Colors.black87, fontSize: 14 ) ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget> [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              )
            ),
            const Divider( height: 1 ),

            //TODO: caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 8.0 ),
        child: Row(
          children: <Widget> [

            Flexible(
              child: TextField(
                onTapOutside:(event){
                  _focusNode.unfocus();
                },
                
                textCapitalization: TextCapitalization.sentences,
                controller: _textController,
                onSubmitted: _hanledSubmmit,
                onChanged: ( text ){
                  setState(() {
                    if ( text.trim().length > 0 ){
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            //Boton de enviar
            Container(
              margin: const EdgeInsets.symmetric( horizontal:  4.0 ),
              child: Platform.isIOS
              ? CupertinoButton(
                child: const Text('Enviar'), 
                onPressed: _isWriting
                    ? () => _hanledSubmmit( _textController.text.trim() )
                    : null, 
              )

              : Container(
                margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
                child: IconTheme(
                  data: IconThemeData( color: Colors.blue[400] ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon( Icons.send ),
                    onPressed: _isWriting
                    ? () => _hanledSubmmit( _textController.text.trim() )
                    : null, 
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
    
  }
  _hanledSubmmit(String texto) {

    if ( texto.length == 0 ) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: texto,
       uid: authService.usuario.uid, 
       animationController: AnimationController( vsync: this, duration: const Duration( milliseconds: 300 ) ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;    
    });

    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }
  @override
  void dispose() {

    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }

    socketService.socket.off( 'mensaje-personal' );
    super.dispose();
  }
      
}

