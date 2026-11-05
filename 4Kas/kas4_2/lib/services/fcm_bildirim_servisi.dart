import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';//firebase mesajı için gerekli içerik
import 'package:flutter_local_notifications/flutter_local_notifications.dart';//bilidirm almak için gerekli içerik
import '../firebase_options.dart';

@pragma('vm:entry-point')//pragma uygulama arka plandayken bile bildirim yollaması için tüm metodların üstüne yazılır
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class FcmBildirimServisi {//bildirim servisi classı
  final FirebaseMessaging _fcm=FirebaseMessaging.instance;//_fcm değişken tanımı
  final FlutterLocalNotificationsPlugin _localPlugin=//_localPlugin tanımı
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'softit_fcm_chanel_id',
    'Softito bildirimleri',
    description: 'Fcm Push bildirimleri',
    importance: Importance.max,
  );

  Future<void> baslat({//başlat metodu
    required Function(RemoteMessage message) onMesajGeldi,//mesaj geldiğinde onMesajgeldi çağırılacak
  }) async{
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);//uygulama kapalı veya arkaplandayken gelecek bildirimleri işler

    await _fcm.requestPermission(//bildirim ayarları bildirim mesajı simgesi ve sesi
      alert: true,
      badge: true,
      sound: true,
    );

    await _fcm.setForegroundNotificationPresentationOptions(
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

    final androidPlugin = _localPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
    await androidPlugin?.requestNotificationsPermission();

    FirebaseMessaging.onMessage.listen((message){//uygulama açıkken bildirimlerei yayınlar
      _yerelBildirimGoster(message);
      onMesajGeldi(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message){//arka plandayken bildirime tıklanınca listeye ekler
      onMesajGeldi(message);
    });

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      onMesajGeldi(initialMessage);
    }
  }
  Future<String?> tokenAl() async{
    try{
      return await _fcm.getToken();
    }catch(_){
      return null;
    }
  }
  Future<void> konuyaAboneOl(String konu) async{
    await _fcm.subscribeToTopic(konu);
  }
  Future<void> konudanAyril(String konu) async{
    await _fcm.unsubscribeFromTopic(konu);
  }
  Future<void> _yerelBildirimGoster(RemoteMessage message) async{
    await yerelTestBildirimiGoster(
      baslik: message.notification?.title ?? 'Yeni Bildirim',
      icerik: message.notification?.body ?? '',
      id: message.hashCode,
    );
  }

  Future<void> yerelTestBildirimiGoster({
    required String baslik,
    required String icerik,
    int? id,
  }) async {
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
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      baslik,
      icerik,
      details,//NotificationDetails
    );
  }
}