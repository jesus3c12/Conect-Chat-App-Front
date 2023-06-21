import 'package:conect_chat/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:conect_chat/services/socket_service.dart';
import 'package:conect_chat/services/auth_service.dart';

import 'package:conect_chat/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),
        ChangeNotifierProvider(create: ( _ ) => SocketService() ),
        ChangeNotifierProvider(create: ( _ ) => ChatService() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IL Conect Chat',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}