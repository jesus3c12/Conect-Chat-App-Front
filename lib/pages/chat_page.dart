import 'dart:io';

import 'package:conect_chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode =  FocusNode();

  final List<ChatMessage> _messages = [
    
  ];

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5,
        title: Column(
          children: <Widget> [
            CircleAvatar(
              child: Text( 'In', style: TextStyle(fontSize: 14 ) ),
              backgroundColor: Colors.blue[100],
              maxRadius: 16,
            ),
            const SizedBox( height: 3 ),
            const Text( 'Ines Flores', style: TextStyle( color:  Colors.black87, fontSize: 14 ) ),
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
              //  onTapOutside:(event){
              //    _focusNode.unfocus();
              //  },
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

    print( texto );
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: texto,
       uid: '123', 
       animationController: AnimationController( vsync: this, duration: const Duration( milliseconds: 500 ) ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;    
    });
  }
  @override
  void dispose() {
    // TODO: Off del socket
    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }
    super.dispose();
  }
      
}

