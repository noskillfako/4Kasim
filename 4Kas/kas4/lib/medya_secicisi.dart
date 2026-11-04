import 'dart:io';//yerel dosya sistemine erişim için
import 'package:image_picker/image_picker.dart';//foto eklemek için


class MedyaSeciciServis {//medyanın kameradan mı yoksa galeriden mi seçileceğine karar veren metod
  final ImagePicker _picker=ImagePicker();

  Future<File?> galeridenSec() async{//asenkron future metod başlangıcı
    final XFile? secilen= await _picker.pickImage(//fotoğraf eklemek için
      source:ImageSource.gallery,//galeriden fotoğraf çekmek için aslında medyanın kaynağını soruyor bu kısımda galeriden
      imageQuality: 80,//medya kalitesi
      maxWidth:1200,//maks genişlik
    );
    if(secilen==null) return null;//eğer medya null değerindeyse null döndür
    return File(secilen.path);//null değerinde değilse medyayı döndür
  }

  Future<File?> kameradanCek() async{//üstteki metodun aynıs lakin bu sefer galeriden değil de kameradan çekim
    final XFile? cekilen=await _picker.pickImage(
      source:ImageSource.camera,
      imageQuality:80,
      maxWidth:1200,
    );
    if(cekilen==null) return null;
    return File(cekilen.path);
  }
}