import 'package:conect_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:conect_chat/models/user.dart';


class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User( uid: '1', nombre: 'Jesus', email: 'jesus3c12gmail.com', online: true ),
    User( uid: '2', nombre: 'Julian', email: 'julian12gmail.com', online: false ),
    User( uid: '3', nombre: 'Jazmin', email: 'jaz3c12gmail.com', online: true ),
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( usuario?.nombre ?? 'Sin Nombre', style: TextStyle(color: Colors.black87 ) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: () {

            // TODO: Desconectar del socket server
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();

          }, 
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: Icon( Icons.check_circle, color: Colors.blue[400] ),
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
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UserListTile( users[i] ),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: users.length
    );
  }

  ListTile _UserListTile(User user) {
    return ListTile(
        title: Text(user.nombre),
        subtitle: Text ( user.email ),
        leading: CircleAvatar(
          child: Text(user.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color:  user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }
  _loadingUsers() async{

     await Future.delayed(const Duration(milliseconds: 1000));
     _refreshController.refreshCompleted();

  }
}