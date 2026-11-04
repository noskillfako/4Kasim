import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServisi {
  final FirebaseStorage _storage= FirebaseStorage.instance;

  UploadTask yuklemeBaslat({
    required File dosya,
    required String hedefDizin,
    required String dosyAdi,
  }){
    final Reference ref=_storage.ref().child('$hedefDizin/$dosyAdi');
    final metadata=SettableMetadata(
      contentType:'image/jpeg',
      customMetadata:{
        'yukleyen':'Faik fahri fuat furkan fahrettin tek kişilik dev kadro'
        },
    );
    return ref.putFile(dosya,metadata);
  }

  task.snapshot.listen((TaskSnapshot snapshot){
    final double yuzde=snapshot.bytesTranferred/snapshot.totalBytes;
    print('yükleniyor %${(yuzde*100).toStringAsFixed(1)}');
  })
  
}
