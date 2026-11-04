import 'package:flutter/material.dart';
import '../models/bildirim_modeli.dart';

class BildirimListesiKarti extends StatelessWidget{//widget tanımı
  final List<BildirimModeli> bildirimler;//değişken tanımları
  final String? token;
  final bool konuyaAboneMi;
  final ValueChanged<bool> onAboneDegisti;

  const BildirimListesiKarti({
    super.key,//üst sınıfa key parametresini iletir
    required this.bildirimler,//tanımı zorunlu değişkenler
    required this.token,
    required this.konuyaAboneMi,
    required this.onAboneDegisti,
  });

  @override
  Widget build(BuildContext context){//widget oluşturm
    return Card(//card açılımı
      elevation: 0,//gölge yüksekliği
      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(16),//Köşelerin yuvarlanması
        side:BorderSide(color: Colors.grey.shade300),////kenarlık ekler
      ),
      child:Padding(padding:const EdgeInsets.all(16),//iç boşluk
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,//boyutunu zorla uzatır
        children:[
          Row(
            children:[
              const Icon(//ıcon tanımı
                Icons.notifications_active_outlined,//ıcon simgesi
                color: Colors.green,//ıcon rengi
              ),
              const SizedBox(width:8),//8px boşluk
              const Expanded(//yayma amaçlı expanded
                child:Text('FCM Bildirim Merkezi',style:TextStyle(//text yazımı ve text özellikleri
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:Color(0xFFF172A),
                ),
                ),
                ),
              Switch(
                value: konuyaAboneMi,//görünüm bu değere göre belirlenir
                 onChanged: onAboneDegisti,//kullanıcı dokununca bu değişken çağırılır
                activeColor:  const Color.fromARGB(15, 160, 40, 50),
                 ),
            ],
            ),
            Text(
              konuyaAboneMi ? 'Tüm sınıf yayını aktif' : 'Yayın kapalı',
              style:TextStyle(//konuyaAboneminin durumuna göre text yazımı ve renk değişim
                fontSize:12,
                color:konuyaAboneMi ? const Color.fromARGB(15, 24, 59, 17)
                :  Colors.grey.shade600, 
                fontWeight:FontWeight.w600,
              ),
            ),
            const SizedBox(height:12),//boşluk
            Container(//container açılımı
              padding: const EdgeInsets.all(10),//iç boşluk
              decoration: BoxDecoration(
                color: const Color(0XFF0F172A),//renk tanımı
                borderRadius: BorderRadius.circular(8),//köşelerin yuvarlaklık
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,//soldan başlangıç
                children:[
                  const Text(//text yazımı
                  "Cihazın FCM Tokeni",
                  style: TextStyle(//text renk ve boyutu
                    color: Color.fromARGB(255, 26, 40, 52),
                    fontSize:11,
                  ),
                  ),
                  const SizedBox(height: 2),//boşluk
                  SelectableText(//uzun basıp kopyalanabilen text
                    token ?? 'token alınıyor',//token null değilse tokeni nullsa token alınıyor yazar
                    style:const TextStyle(//text ayarları
                      color: Color(0xff388888),
                      fontSize:11,
                      fontFamily:'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),//boşluk
            Text(
              'Gelen Bildirimler (${bildirimler.length}):',//gelen bilidirimler ve gelen bildirim sayısı
              style: const TextStyle(//text ayarlar
                fontWeight:FontWeight.bold,
                fontSize:14,
                color: Color.fromARGB(0, 5, 249, 253),
              ),
            ),
            const SizedBox(height: 8),//boşluk
            bildirimler.isEmpty ? Container(//bildirim yoksa container oluştur
              padding: const EdgeInsets.all(24),//iç boşluk
              alignment:Alignment.center,//merkeze hizala
              child: Text('Henüz gelen bildirim yok',//text
              textAlign: TextAlign.center,//texi merkeze hizala
              style:TextStyle(
                fontSize: 12,//font 12
                color:Colors.grey.shade600,//gri renk ve tonu
              ),
              ),
            ) 
            : ListView.separated(
              shrinkWrap:true,//sonsuz kaydırma
              itemCount:bildirimler.length,//gelen bildirim sayısı
              separatorBuilder:(_,_)=>const Divider(height:1),//1 px yüksekliğinde yatay çizgi
              itemBuilder: (context,index){},//itembuilder çağırma
            ),
        ],
      ),
      ),
    );
  }
  }