import 'dart:io';



class Enviroment {
  //static String apiUrl =  'http://192.168.0.18:3000/api';
  //: 'http://0.0.0.0:3000/api';
  
  //static String socketUrl = 
  //'http://192.168.0.18:3000'; //: 'http://0.0.0.0/:3000';
   //127.0.0.1

  static String apiUrl    = Platform.isAndroid ? 'http://192.168.0.18:3000/api' : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.0.18:3000'     : 'http://localhost:3000';
}