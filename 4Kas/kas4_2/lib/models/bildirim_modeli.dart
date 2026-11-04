class BildirimModeli{
  final String id;//id tanımlama
  final String baslik;//baslik tanımlama
  final String icerik;//içerik tanımla
  final DateTime tarih;//tarih tanımla
  final bool okunduMu;//okundumu tanımla

  const BildirimModeli({
    required this.id,//id değer atamsı zorunlu
    required this.baslik,//baslik deger ataamsı zorunlu
    required this.icerik,//içerik değer ataması zorunlu
    required this.tarih,//tarih deger ataması zorunlu
    this.okunduMu=false,//okundumu deger ataması false
  });

  BildirimModeli copywith({//tanımlana değişlkenlerin kopyasını oluşturma
    String? id,
    String? baslik,
    String? icerik,
    DateTime? tarih,
    bool? okunduMu,
  }){
    return BildirimModeli(//oluşturulan kopyalar eğer değişikliğie uğrarsa değişikliğe uğrayan değişkeni orjinali ile değiştirme
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      icerik: icerik ?? this.icerik,
      tarih: tarih ?? this.tarih,
      okunduMu: okunduMu ?? this.okunduMu
      );
  }
}