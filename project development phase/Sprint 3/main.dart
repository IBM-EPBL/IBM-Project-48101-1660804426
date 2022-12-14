import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartbins/Pages/login.dart';
import 'package:smartbins/Pages/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final _storage = FlutterSecureStorage();
  final all = await _storage.readAll();
  var status = false;
  if (all["status"]=="Authenticated"){
    status =true;
  }
  else{
    status = false;
  }
  runApp(MyApp(page_status: status,));

}
class MyApp extends StatelessWidget {
  final page_status;
  MyApp({
    this.page_status,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
//      theme: AppTheme.lightTheme,
        theme: ThemeData(primaryColor: Colors.deepOrange),
      home: page_status == true ? HomePage() : Login(),
//        onGenerateRoute: Router.generateRoute,
    );
  }
}
