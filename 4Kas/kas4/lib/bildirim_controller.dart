import 'package:flutter_local_notifications/flutter_local_notifications.dart';//bildirim alabilmek için gerekli küütphane
import 'package:firebase_messaging/firebase_messaging.dart';//sunucuya istek gönderilir


class YerelBildirimYoneticisi{//class açılım
  static final FlutterLocalNotificationsPlugin _yerelBildirim=
  FlutterLocalNotificationsPlugin();//static final _yerelBildirimine metod tanımı

  static Future<void> kurulum() async{//static asenkron future
    const androidAyarlar=AndroidInitializationSettings('@mipmap/ic_launcher');//android uygulma simgesi
    const iosAyarlar=DarwinInitializationSettings();//ios ve mac simgesi
    const ayarlar=InitializationSettings(//ios ve android ayaarlar tanımı
      android: androidAyarlar,
      iOS: iosAyarlar,
    );
    await _yerelBildirim.initialize(settings: ayarlar);//_yerelBildirime değişkenine ayarları atama
  }

  static Future<void> bildirimGoster(RemoteMessage message) async{//static değişken kullandığımız için static future void oluşturuyoruz
    const androidDetay=AndroidNotificationDetails(//androidDetay kısmına metod tanımlıyoruz
      'softito_kanal_id',//kanal id
      'Softito Bildirimleri',//kanal adi
      importance: Importance.max,//önem derecesi
      priority: Priority.high,
      playSound: true,//ses oynatma
      );
      const detaylar=NotificationDetails(android:androidDetay);//tanımlama
      await _yerelBildirim.show(//show fonksiyonu açıyoruz
        id: message.hashCode,//string idyi inte çevirmek için hashcodea çeviriyoruz
        title: message.notification?.title ?? 'Yeni bildirim',//bildirim yoksa gösterme varsa yeni bildirim mesajı ver
        body: message.notification?.body ?? '',//body alanı varsa onu kullan yoksa boş döndür
        notificationDetails: detaylar,
      );
  }
}