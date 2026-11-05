import 'dart:io';
import 'package:flutter/material.dart';
import '../models/bildirim_modeli.dart';
import '../services/fcm_bildirim_servisi.dart';
import '../services/storage_servisi.dart';
import '../widgets/bildirim_listesi_karti.dart';
import '../widgets/gorsel_yukleme_karti.dart';

class StorageVeFcmEkrani extends StatefulWidget {
    const StorageVeFcmEkrani({super.key});

    @override
    State<StorageVeFcmEkrani> createState() => _StorageVeFcmEkraniState();
}
class _StorageVeFcmEkraniState extends State<StorageVeFcmEkrani>{
  final StorageServisi _storageServisi=StorageServisi();
  final FcmBildirimServisi _fcmBildirimServisi= FcmBildirimServisi();

  File? _SecilenDosya;
  String? _yuklenenUrl;
  double _yuklemeOrani=0.0;
  bool _yukleniyorMu=false;

  String? _fcmToken;
  bool konuyaAboneMi=false;
  final List<BildirimModeli> _bildirimler =[];

  @override
  void initState(){
    super.initState();
    _fcmKur();
  }

  Future<void> _fcmKur() async{
    await _fcmBildirimServisi.baslat(onMesajGeldi: (message){
      setState((){
        _bildirimler.insert(0,BildirimModeli(id:message.messageId ?? DateTime.now().
        toIso8601String(),baslik:message.notification?.title ?? 'Yeni Bildirim',
        icerik: message.notification?.body ?? '',
        tarih:DateTime.now()
        ),
        );
      });
    }
    );
    final token =await _fcmBildirimServisi.tokenAl();
    setState(() => _fcmToken=token);
  }

  Future<void> _gorselSec({required bool kameradan}) async{
    final dosya=await _storageServisi.gorselSec(kameradan:kameradan);
    if(dosya!=null){
      setState(() {
        _SecilenDosya=dosya;
        _yuklenenUrl=null;
        _yuklemeOrani=0.0;
      });
    }
  }

  Future<void> _bulutaYukle() async{
    if(_SecilenDosya==null) return;
    setState(()=>_yukleniyorMu=true);
    try{
      final dosyaAdi='profil_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final task=_storageServisi.yuklemeBaslat(dosya: _SecilenDosya!, dosyaAdi: dosyaAdi,);

      task.snapshotEvents.listen((snapshot){
        if(snapshot.totalBytes>0){
          setState(() {
            _yuklemeOrani=snapshot.bytesTransferred/snapshot.totalBytes;
          });
        }
      });
      final tamamlanan=await task;
      final url=await _storageServisi.urlGetir(tamamlanan.ref);

      setState(() {
        _yuklenenUrl=url;
        _yukleniyorMu=false;
      });

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Görsel Buluta Başarıyla Yüklendi'),backgroundColor:
          Color.fromARGB(0, 253, 1, 186),),
        );
      }
    } catch(e){
      setState(()=>_yukleniyorMu=false);
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:Text('Yükleme hatasi: $e'),
            backgroundColor: const Color.fromARGB(0, 12, 208, 0),
          ),
        );
      }
    }
  }




  Future<void> _aboneDegistir(bool deger) async{
    setState(()=> konuyaAboneMi=deger);
    if(deger){
      await _fcmBildirimServisi.konuyaAboneOl('tum_sinif');
    } else {
      await _fcmBildirimServisi.konudanAyril('tum_sinif');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFFF8FAF),
      appBar:AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Softito Storage ve fcm Çalışması',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold)),
            Text("Bulut Yükleme ve Push Bildirimleri",style: TextStyle(fontSize: 11,
            color:Colors.white),),
          ],
        ),
        backgroundColor:const Color(0xff00F172A),
        foregroundColor: Colors.white,
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GorselYuklemeKarti(
            secilenDosya: _SecilenDosya,
            yuklenenUrl: _yuklenenUrl,
            yuklemeOrani: _yuklemeOrani,
            yukleniyorMu: _yukleniyorMu,
            onGaleridenCek: () => _gorselSec(kameradan: false), 
            onKameradanCek: ()=> _gorselSec(kameradan: true), 
            onBulutaYukle: _bulutaYukle),
            const SizedBox(height:16),
            BildirimListesiKarti(
              bildirimler: _bildirimler, 
              token: _fcmToken, 
              konuyaAboneMi: konuyaAboneMi, 
              onAboneDegisti: _aboneDegistir)
          ],
          ),
      ),
    );
  }
}