import 'dart:io';//dosya işlemleri için
import 'package:firebase_storage/firebase_storage.dart';//firebase veritabanı için
import 'package:image_picker/image_picker.dart';//fotoğraf çekmek veya seçmek için

class StorageServisi {
  final FirebaseStorage _storage=FirebaseStorage.instance;//storage deger ataması
  final ImagePicker _picker=ImagePicker();//picker metod atması

  Future<File?> gorselSec({bool kameradan=false})async{//kameradan veya galeriden medya çekme
    final XFile? xFile =await _picker.pickImage(
      source: kameradan ? ImageSource.camera : ImageSource.gallery,
      imageQuality:80,//kalite
      maxWidth:1200,//max genişlik
    );
    if(xFile==null) return null;//eğer dosya null ise null döner
    return File(xFile.path);//dosyayı döner
  }

  UploadTask yuklemeBaslat({
    required File dosya,//dosya tanımlaması zorunlu
    required String dosyaAdi,//zorunlu dosyadi tanımlaması
    String klasor='yuklemeler',//klasor tanımı
  }){
    final Reference ref=_storage.ref().child('$klasor/$dosyaAdi');//ref'e dosya yolunu atıyoruz
    final metadata =SettableMetadata(
      contentType: 'image/png',//dosyanın uzantısı
      customMetadata: {'ekleyen':'Ahmet Taş'},//yükleyen kişini açıklaması
    );
    return ref.putFile(dosya,metadata);//dosya yüklemesi
  }

  Future<String> urlGetir(Reference ref) async{
    return await ref.getDownloadURL();//dosyanın urlsini getirme
  }
  Future<void> dosyaSil(String dosyayolu) async{
    final Reference ref=_storage.ref().child(dosyayolu);//ref'e dosya tanımı
    await ref.delete();//ref'i silme
  }
}
