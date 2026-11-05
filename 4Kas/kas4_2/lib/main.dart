import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/storage_ve_fcm_ekrani.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // 1. Flutter bağlayıcısını hazırla
  await Firebase.initializeApp(               // 2. Firebase'i başlat ve BEKLE
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SoftitoFcmDemoApplication());  // 3. Ancak şimdi uygulamayı başlat
}
class SoftitoFcmDemoApplication extends StatelessWidget{
  const SoftitoFcmDemoApplication({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title:"Softito FCM Demo Application",
        theme:ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor:const Color.fromARGB(0, 0, 0, 0),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home:const StorageVeFcmEkrani(),
    );
  }
}