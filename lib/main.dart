import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/fonts.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/services/injection_container.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/services/router.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async{
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await init();
  FlutterNativeSplash.remove();  
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter FoodNinja',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: Fonts.bentonSans,  
      ),
      onGenerateRoute: generateRoute,
    );
  }
}
