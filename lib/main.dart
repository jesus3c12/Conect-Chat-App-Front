import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:conect_chat/routes/routes.dart';
import 'package:conect_chat/services/auth_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),
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