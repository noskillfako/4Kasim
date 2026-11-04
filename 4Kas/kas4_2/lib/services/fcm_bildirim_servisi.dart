import 'package:firebase_messaging/firebase_messaging.dart';//firebase mesajı için gerekli içerik
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';//bilidirm almak için gerekli içerik

@pragma('vm:entry-point')//pragma uygulama arka plandayken bile bildirim yollaması için tüm metodların üstüne yazılır
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}

class FcmBildirimServisi {//bildirim servisi classı
  final FirebaseMessaging _fcm=FirebaseMessaging.instance;//_fcm değişken tanımı
  final FlutterLocalNotificationsPlugin _localPlugin=//_localPlugin tanımı
  FlutterLocalNotificationsPlugin();

  Future<void> baslat({//başlat metodu
    required Function(RemoteMessage message) onMesajGeldi,//mesaj geldiğinde onMesajgeldi çağırılacak
  }) async{
    await _fcm.requestPermission(//bildirim ayarları bildirim mesajı simgesi ve sesi
      alert: true,
      badge: true,
      sound: true,
    );

    const androidSettings=AndroidInitializationSettings('@mipmap/ic_launcher');//android ayarları ve logosu
    const iosSettings=DarwinInitializationSettings();//ios ve mac ayarları
    const initSettings=InitializationSettings(//android ve iios ayarlarını atmama
      android:androidSettings,
      iOS:iosSettings,
    );

    await _localPlugin.initialize(initSettings);//_localPlugin değer ataması
    FirebaseMessaging.onMessage.listen((message){//uygulama açıkken bildirimlerei yayınlar
      _yerelBildirimGoster(message);
      onMesajGeldi(message);
    });
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);//uygulama kapalı veya arkaplandayken gelecek bildirimleri işler
  }
  Future<void> konuyaAboneOl(String konu) async{
    await _fcm.subscribeToTopic(konu);
  }
  Future<void> konudanAyril(String konu) async{
    await _fcm.unsubscribeFromTopic(konu);
  }
  Future<void> _yerelBildirimGoster(RemoteMessage message) async{
    const androidDetails=AndroidNotificationDetails(
      'softit_fcm_chanel_id',//kanal id
      'Softito bildirimleri',//kanal adı
      channelDescription: 'Fcm Push bildirimleri',//kanal açıklaması
      importance:Importance.max,//önem derecesi
      priority:Priority.high,//öncelik derecesi
    );
    const details=NotificationDetails(//details değişkenine androiddetails ve ios details atmama
      android:androidDetails,
      iOS:DarwinNotificationDetails(),
    );

    await _localPlugin.show(//show metodu ile _localPlugin bildirim detayları
      message.hashCode,//id'si inte çevirmek için hashcode
      message.notification?.title ?? 'Yeni Bildirim',//bildirim varsa yeni bildirim yazısı
      message.notification?.body ?? '',//body alanı varsa onu kullan yoksa boş döndür
      details,//NotificationDetails
    );
  }
}