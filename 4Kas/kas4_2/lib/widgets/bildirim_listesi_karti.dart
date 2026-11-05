import 'package:flutter/material.dart';
import '../models/bildirim_modeli.dart';

class BildirimListesiKarti extends StatelessWidget{//widget tanımı
  final List<BildirimModeli> bildirimler;//değişken tanımları
  final String? token;
  final bool konuyaAboneMi;
  final ValueChanged<bool> onAboneDegisti;
  final VoidCallback? onTestBildirimiGonder;

  const BildirimListesiKarti({
    super.key,//üst sınıfa key parametresini iletir
    required this.bildirimler,//tanımı zorunlu değişkenler
    required this.token,
    required this.konuyaAboneMi,
    required this.onAboneDegisti,
    this.onTestBildirimiGonder,
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
                  color:Color(0xFF0F172A),
                ),
                ),
                ),
              Switch(
                value: konuyaAboneMi,//görünüm bu değere göre belirlenir
                 onChanged: onAboneDegisti,//kullanıcı dokununca bu değişken çağırılır
                activeColor:  const Color.fromARGB(255, 160, 40, 50),
                 ),
            ],
            ),
            Text(
              konuyaAboneMi ? 'Tüm sınıf yayını aktif' : 'Yayın kapalı',
              style:TextStyle(//konuyaAboneminin durumuna göre text yazımı ve renk değişim
                fontSize:12,
                color:konuyaAboneMi ? const Color.fromARGB(255, 24, 159, 17)
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
                    color: Colors.white70,
                    fontSize:11,
                  ),
                  ),
                  const SizedBox(height: 2),//boşluk
                  SelectableText(//uzun basıp kopyalanabilen text
                    token ?? 'token alınıyor',//token null değilse tokeni nullsa token alınıyor yazar
                    style:const TextStyle(//text ayarları
                      color: Color(0xff38bdf8),
                      fontSize:11,
                      fontFamily:'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),//boşluk
            if (onTestBildirimiGonder != null) ...[
              OutlinedButton.icon(
                onPressed: onTestBildirimiGonder,
                icon: const Icon(Icons.notifications_active),
                label: const Text('Test Bildirimi Gönder'),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Gelen Bildirimler (${bildirimler.length}):',//gelen bilidirimler ve gelen bildirim sayısı
              style: const TextStyle(//text ayarlar
                fontWeight:FontWeight.bold,
                fontSize:14,
                color: Color(0xFF0F172A),
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount:bildirimler.length,//gelen bildirim sayısı
              separatorBuilder:(_,_)=>const Divider(height:1),//1 px yüksekliğinde yatay çizgi
              itemBuilder: (context,index){
                final b =bildirimler[index];
                return ListTile(
                  contentPadding:EdgeInsets.zero,
                  leading:const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 224, 242, 254),
                    child: Icon
                    (Icons.mark_email_unread_outlined,
                    color:Color.fromARGB(255, 2, 132, 199),
                    size:20
                    ),
                  ),
                  title:Text(
                    b.baslik,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:14,
                    ),
                  ),
                  subtitle: Text(b.icerik),
                  trailing:Text(
                    '${b.tarih.hour.toString().padLeft(2,'0')}:${b.tarih.minute.toString().padLeft(2,'0')}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                );
              },//itembuilderi kapatma
            ),
        ],
      ),
      ),
    );
  }
  }