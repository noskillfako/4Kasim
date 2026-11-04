import 'dart:io';//giriş ve çıkış işlemleri için 
import 'package:firebase_storage/firebase_storage.dart';//firebase data için

class StorageServisi {
  final FirebaseStorage _storage= FirebaseStorage.instance;//_storage tanımın

  UploadTask yuklemeBaslat({//UploadTask açılımı
    required File dosya,//gerekli dosya değişkeni
    required String hedefDizin,//dosyanın nereden yüklenmesi gerektiğini söyleyen gerekli hedefdizin
    required String dosyAdi,//dosyaAdi
  }){
    final Reference ref=_storage.ref().child('$hedefDizin/$dosyAdi');//ref değişkenine belge ataması ve onun konumu
    final metadata=SettableMetadata(//metdata tanımı
      contentType:'image/jpeg',//dosya türü
      customMetadata:{//yükleyen kişi notu
        'yukleyen':'Faik fahri fuat furkan fahrettin tek kişilik dev kadro'
        },
    );
    return ref.putFile(dosya,metadata);//yüklenen dosyayı döndürme
  }

  task.snapshot.listen((TaskSnapshot snapshot){//dosyanın yüklemesini yüzde kaçta olduğunu gösteren metod
    final double yuzde=snapshot.bytesTranferred/snapshot.totalBytes;
    print('yükleniyor %${(yuzde*100).toStringAsFixed(1)}');
  })
  
}
