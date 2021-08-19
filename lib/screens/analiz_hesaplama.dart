import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:yildiz_metal/models/analiz.dart';
import 'package:yildiz_metal/utils/database_helper.dart';

class AnalizHesaplamaScreen extends StatefulWidget {
  const AnalizHesaplamaScreen({Key? key}) : super(key: key);

  @override
  _AnalizHesaplamaScreenState createState() => _AnalizHesaplamaScreenState();
}

class _AnalizHesaplamaScreenState extends State<AnalizHesaplamaScreen> {
  //1
  late DatabaseHelper _databaseHelper;
  late List<Analiz> analizListesi;
  var formKey = GlobalKey<FormState>();

  double kgToplam = 0;
  double analizOrani = 0;
  int elemanSayisi = 0;

  var malzemeAdi = TextEditingController();
  var kg = TextEditingController();
  var al = TextEditingController();

  int index1 = 0;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    as();
  }

  void as() async {
    super.initState();
    setState(() {
      analizListesi = <Analiz>[];
      _databaseHelper = DatabaseHelper();
      _databaseHelper.tumAnalizler().then((tumAnalizleriTutanMapListesi) {
        for (Map<String, dynamic> okunanAnalizMapi
            in tumAnalizleriTutanMapListesi) {
          analizListesi
              .add(Analiz.dbdenOkudugunMapiObjeyeDonustur(okunanAnalizMapi));
        }
        debugPrint(malzemeAdi.text.toString());
      });
    });
  }

  Future asd() async {
    await Future.value(
        _databaseHelper.tumAnalizler().then((tumAnalizleriTutanMapListesi) {
      for (Map<String, dynamic> okunanAnalizMapi
          in tumAnalizleriTutanMapListesi) {
        analizListesi
            .add(Analiz.dbdenOkudugunMapiObjeyeDonustur(okunanAnalizMapi));
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Analiz Hesaplayıcısı",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _tumTabloyuTemizle();
            },
            icon: Icon(Ionicons.trash_outline),
            splashRadius: 18,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "yeniSayfa");
            },
            icon: Icon(Ionicons.arrow_back),
            splashRadius: 18,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 15,
              child: SingleChildScrollView(
                child: DataTable(
                    columns: <DataColumn>[
                      dataColumn("Malzeme Adı"),
                      dataColumn("KG"),
                      dataColumn("Alaşım Oranı"),
                    ],
                    rows: List.generate(analizListesi.length, (index) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(analizListesi[index].malzemeAdlari),
                              onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  malzemeAdi.text =
                                      "${analizListesi[index].malzemeAdlari}";
                                  kg.text =
                                      analizListesi[index].kgler.toString();
                                  al.text =
                                      analizListesi[index].alasimlar.toString();

                                  return changeInformation(index);
                                });
                          }),
                          DataCell(Text(analizListesi[index].kgler.toString()),
                              onTap: () {
                            debugPrint("İndexxx : $index");
                            debugPrint("adasd : " +
                                analizListesi[index].kgler.toString());
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  malzemeAdi.text =
                                      "${analizListesi[index].malzemeAdlari}";
                                  kg.text =
                                      analizListesi[index].kgler.toString();
                                  al.text =
                                      analizListesi[index].alasimlar.toString();

                                  return changeInformation(index);
                                });
                          }),
                          DataCell(
                              Row(
                                children: [
                                  Text(analizListesi[index]
                                      .alasimlar
                                      .toString()),
                                  Icon(Ionicons.remove),
                                ],
                              ), onTap: () {
                            _analizSil(analizListesi[index], index);
                          }),
                        ],
                      );
                    })),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        width: 50,
                        height: 600,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Toplam KG:   ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: analizListesi.length == 0
                                          ? "0.0"
                                          : analizListesi.last.kgToplam
                                              .toString()),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Analiz Oranı :   ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text:
                                        // requiredListesi.first.analizOrani.toString()),
                                        analizListesi.length == 0
                                            ? "0.0"
                                            : analizListesi.last.analizOrani
                                                .toStringAsFixed(5),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(),
                          height: MediaQuery.of(context).size.height,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    malzemeAdi.clear();
                                    kg.clear();
                                    al.clear();
                                    return alertDialog();
                                  });
                            },
                            child: Icon(Icons.add),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () {
              try {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    //toplam kg bulucu
                    double geciciKgToplam = 0;

                    if (analizListesi.length >= 1) {
                      geciciKgToplam =
                          analizListesi.last.kgToplam + double.parse(kg.text);

                      kgToplam = geciciKgToplam;
                    } else {
                      geciciKgToplam = double.parse(kg.text);
                      kgToplam = geciciKgToplam;
                    }

                    //toplam analiz oranı bulucu

                    _analizEkle(Analiz(malzemeAdi.text, double.parse(kg.text),
                        double.parse(al.text), kgToplam, analizOrani));

                    debugPrint("Before for cycle : " +
                        analizListesi.length.toString());

                    elemanSayisi++;
                    Fluttertoast.showToast(
                        msg: malzemeAdi.text + " Eklendi",
                        gravity: ToastGravity.TOP);
                    Navigator.pop(context);
                  });
                }
              } catch (e) {
                Fluttertoast.showToast(
                    msg: "Hata : Sıfırdan büyük bir değer giriniz",
                    gravity: ToastGravity.TOP);
              }
            },
            child: Text("Ekle"))
      ],
      scrollable: true,
      title: Text("Veri Ekleme"),
      content: Container(
        child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: malzemeAdi,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Malzeme Adı"),
                ),
                alertInput("KG", kg),
                alertInput("Alaşım", al),
              ],
            )),
      ),
    );
  }

  AlertDialog changeInformation(int i) {
    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                _analizGuncelle(
                    Analiz.withID(analizListesi[i].id, malzemeAdi.text,
                        double.parse(kg.text), double.parse(al.text), 0, 0),
                    i);

                Fluttertoast.showToast(
                    msg: malzemeAdi.text + " Güncellendi",
                    gravity: ToastGravity.TOP);
                Navigator.pop(context);
              });
            },
            child: Text("Ekle"))
      ],
      scrollable: true,
      title: Text("Veri Güncelleme"),
      content: Container(
        child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: malzemeAdi,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Malzeme Adı"),
                ),
                alertInput("KG", kg),
                alertInput("Alaşım", al),
              ],
            )),
      ),
    );
  }

  nullCheck(element) {
    if (element.text > 0) {
      return double.parse(element.text);
    } else {
      return 0;
    }
  }

  bosMalzemeAdiKontrolcusu(e) {
    if (e.text.toString().length > 0) {
      return e.text;
    } else {
      return "";
    }
  }

  TextFormField alertInput(String text, controller) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      controller: controller,
      validator: (value) {
        try {
          if (value!.isEmpty || double.parse(controller.text) <= 0) {
            return 'Geçerli bir değer giriniz';
          }
          return null;
        } on FormatException catch (e) {
          Fluttertoast.showToast(
              msg: "Pozitif bir sayi giriniz ${e.message} ",
              gravity: ToastGravity.TOP);
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }

  DataColumn dataColumn(String column) {
    return DataColumn(
      label: Text(
        column,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  void _analizEkle(Analiz analiz) async {
    var eklenenYeniAnalizIDsi = await _databaseHelper.analizEkle(analiz);
    analiz.id = eklenenYeniAnalizIDsi;
    if (eklenenYeniAnalizIDsi > 0) {
      setState(() {
        analizListesi.insert(0, analiz);

        _updateValues();
      });
    }
    print("Analiz eklendi ");
  }

  void _tumTabloyuTemizle() async {
    var silinenElemanSayisi = await _databaseHelper.tumAnalizTablosunuSil();
    if (silinenElemanSayisi > 0) {
      print("tüm tablo temizlendi eleman sayisi : $silinenElemanSayisi");
      setState(() {
        analizListesi.clear();
        elemanSayisi = 0;
        kgToplam = 0;
        analizOrani = 0;
      });
    }
  }

  void _analizSil(dbdenSilmekIcinListeNumarasi, int index) async {
    var sonuc =
        await _databaseHelper.analizSil(dbdenSilmekIcinListeNumarasi.id);
    if (sonuc == 1) {
      print("kayıt silindi : " + dbdenSilmekIcinListeNumarasi.id.toString());
      setState(() {
        analizListesi.removeAt(index);
        elemanSayisi--;

        debugPrint(
            "Analiz sil after removeAt : " + analizListesi.length.toString());

        _updateValues();
        debugPrint("Set state sonu : " + analizListesi.length.toString());
      });
    }
  }

  void _analizGuncelle(Analiz analiz, int index) async {
    setState(() {
      analizListesi[index] = analiz;
      _updateValues();
    });
  }

  void _updateValues() {
    double geciciKilo = 0;
    double geciciAnaliz = 0;

    //kgToplam bulucu
    for (int i = 0; i < analizListesi.length; i++) {
      geciciKilo = geciciKilo + analizListesi[i].kgler;
    }
    for (int i = 0; i < analizListesi.length; i++) {
      analizListesi[i].kgToplam = geciciKilo;
    }

    //analizOrani bulucu
    for (int i = 0; i < analizListesi.length; i++) {
      geciciAnaliz = geciciAnaliz +
          ((analizListesi[i].kgler / analizListesi.last.kgToplam) *
              analizListesi[i].alasimlar);
    }

    for (int i = 0; i < analizListesi.length; i++) {
      analizListesi[i].analizOrani = geciciAnaliz;
    }
  }
}

/* class BottomBarDetails extends StatelessWidget {
  const BottomBarDetails({
    Key? key,
    required this.kgToplam,
    required this.analizOrani,
  }) : super(key: key);

  final double kgToplam;
  final double analizOrani;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
      width: 50,
      height: 600,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "Toplam Kilo :   ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "$kgToplam"),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "Analiz Oranı :   ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "${analizOrani.toStringAsFixed(4)}"),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
 */