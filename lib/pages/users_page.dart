import 'package:conect_chat/services/chat_services.dart';
import 'package:conect_chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:conect_chat/services/socket_service.dart';
import 'package:conect_chat/services/auth_service.dart';

import 'package:conect_chat/models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final usuarioService = new UsuariosService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];


  @override
  void initState() {
    _loadingUsers();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( usuario.nombre, style: const TextStyle(color: Colors.black87 ) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: () {

            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();

          }, 
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only( right: 10 ),
            child: ( socketService.serverStatus == ServerStatus.Online )
            ? Icon( Icons.check_circle, color: Colors.blue[400] )
            : Icon( Icons.offline_bolt, color: Colors.red ),
            //child: Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadingUsers,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUsers(),
      )
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UserListTile( usuarios[i] ),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length
    );
  }

  ListTile _UserListTile( Usuario usuario ) {
    return ListTile(
        title: Text( usuario.nombre),
        subtitle: Text ( usuario.email ),
        leading: CircleAvatar(
          child: Text( usuario.nombre.substring(0,2) ),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color:  usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: (){
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _loadingUsers() async{

    usuarios = await usuarioService.getUsuarios();
    setState(() {});
     //await Future.delayed(const Duration(milliseconds: 1000));
     _refreshController.refreshCompleted();

  }
}