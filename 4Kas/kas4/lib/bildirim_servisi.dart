import 'package:firebase_messaging/firebase_messaging.dart';//bildirim için kütüphane

@pragma('vm:entry-point')//arkaplanda çalışması için bildirim fonksiyonunu tutmak için yazılan pragma tüm metodların üsütnde yazılır
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print("Arka planda bildirim geldi:${message.notification?.title}");//arka plan bildirim mesajı
}

class BildirimServisi{
  final FirebaseMessaging _fcm=FirebaseMessaging.instance;//verialma
  Future<void> baslat() async{//başlat metodu asenkron
    NotificationSettings settings=await _fcm.requestPermission(//bildirim ayarları
      alert:true,//bildirim true
      badge:true,//bildirm simgesi
      sound:true,//ses true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print("Kullanıcı Bildirim iznini verdi");//kullanıcı bildirim izni sorgusu ve yazımı
    }
    final token=await _fcm.getToken();//token çekimi
    print('Cihazın FCM Tokenı: $token');//çekilen tokeni yazma
  }
}