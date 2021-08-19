import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:yildiz_metal/functions/maliyet_hesaplama_fonksiyonlar.dart';
import 'package:yildiz_metal/models/maliyet.dart';
import 'package:yildiz_metal/utils/db_helper.dart';
import '../ui/helper/context_extension.dart';

class MaliyetHesaplamaScreen extends StatefulWidget {
  const MaliyetHesaplamaScreen({Key? key}) : super(key: key);

  @override
  _MaliyetHesaplamaScreenState createState() => _MaliyetHesaplamaScreenState();
}

class _MaliyetHesaplamaScreenState extends State<MaliyetHesaplamaScreen> {
  late DatabaseHelper _databaseHelper;
  late List<Maliyet> maliyetListesi;
  var formKey = GlobalKey<FormState>();

  double kgToplam = 0;
  double analizOrani = 0;
  double toplamNetKG = 0;

  var malzemeAdi = TextEditingController();
  var kgBrutController = TextEditingController();
  var kgFiyatController = TextEditingController();
  var fireOraniController = TextEditingController();
  var iscilikMaliyetiController = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    maliyetListesi = <Maliyet>[];
    _databaseHelper = DatabaseHelper();
    _databaseHelper.tumMaliyetler().then((tumAnalizleriTutanMapListesi) {
      for (Map<String, dynamic> okunanAnalizMapi
          in tumAnalizleriTutanMapListesi) {
        maliyetListesi
            .add(Maliyet.dbdenOkudugunMapiObjeyeDonustur(okunanAnalizMapi));
      }

      debugPrint("adas");
      debugPrint(malzemeAdi.text.toString());
    });
  }

  @override
  double iscilikMaliyeti = 2.25;
  double tutarToplami = 0;
  double toplam = 0;
  double ortFireDegeri = 0;
  List<String> malzemeAdlari = [];
  List<double> kgBrut = [];
  List<double> kgFiyatlar = [];
  List<double> fireOranlari = [];
  List<double> kgNet = [];
  List<double> toplamTutar = [];

  var _formKey = GlobalKey<FormState>();
  var isLoading = false;

  int sira = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 15,
              child: dataTable(context),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.mValue,
                  vertical: context.lValue,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(flex: 3, child: iscilikButton(context)),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(flex: 20, child: bottomContainer(context)),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(flex: 10, child: newItemAddButton(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      title: Text(
        "Maliyet Hesaplayıcısı",
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
          splashRadius: context.dynamicHeight(0.025),
        ),
      ],
    );
  }

  SingleChildScrollView dataTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: <DataColumn>[
            dataColumn("Malzeme Adı"),
            dataColumn("KG"),
            dataColumn("Fire"),
            dataColumn("Net KG"),
            dataColumn("Fiyat"),
            dataColumn("Toplam Tutar"),
          ],
          rows: List.generate(maliyetListesi.length, (index) {
            return DataRow(
              cells: <DataCell>[
                datacellBuilder(
                    index, context, maliyetListesi[index].malzemeAdlari),
                datacellBuilder(index, context, maliyetListesi[index].kgBrut),
                datacellBuilder(
                    index, context, maliyetListesi[index].fireOranlari),
                datacellBuilder(index, context, maliyetListesi[index].kgNet),
                datacellBuilder(
                    index, context, maliyetListesi[index].kgFiyatlar),
                datacellBuilder(
                    index, context, maliyetListesi[index].toplamTutar),
              ],
            );
          })),
    );
  }

  DataCell datacellBuilder(int index, BuildContext context, e) {
    return DataCell(Text("$e"), onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            malzemeAdi.text = "${maliyetListesi[index].malzemeAdlari}";
            kgBrutController.text = "${maliyetListesi[index].kgBrut}";
            fireOraniController.text = "${maliyetListesi[index].fireOranlari}";
            kgFiyatController.text = "${maliyetListesi[index].kgFiyatlar}";

            return changeInformation(index, e);
          });
    });
  }

  Align iscilikButton(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return changeLaborCost();
                  });
            },
            child: Text("İşçilik Maliyeti: " +
                (maliyetListesi.length == 0
                        ? iscilikMaliyeti
                        : maliyetListesi.last.iscilikMaliyeti)
                    .toString())));
  }

  Container bottomContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
      width: context.dynamicWidth(1),
      child: Center(
          child: Padding(
        padding: EdgeInsets.all(context.mValue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: richtTextBuilder(
                    "Tutar Toplamı",
                    (maliyetListesi.length == 0
                            ? 0.0
                            : maliyetListesi.last.tutarToplami)
                        .toString())),
            Expanded(
                child: richtTextBuilder(
                    "KG Toplamı",
                    (maliyetListesi.length == 0
                            ? 0.0
                            : maliyetListesi.last.kgToplam)
                        .toString())),
            Expanded(
                child: richtTextBuilder(
                    "Ort. Fire Oranı",
                    (maliyetListesi.length == 0
                            ? 0.0
                            : maliyetListesi.last.ortFire)
                        .toString())),
            Expanded(
              child: richtTextBuilder(
                  "Net Mamul",
                  (maliyetListesi.length == 0
                          ? 0.0
                          : maliyetListesi.last.ortFire *
                              maliyetListesi.last.kgToplam)
                      .toString()),
            ),
          ],
        ),
      )),
    );
  }

  RichText richtTextBuilder(String text, value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        children: <TextSpan>[
          TextSpan(
              text: "$text  ", style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "$value"),
        ],
      ),
    );
  }

  Container newItemAddButton(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        height: context.dynamicHeight(1),
        width: context.dynamicHeight(1),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    malzemeAdi.clear();
                    kgBrutController.clear();
                    kgFiyatController.clear();
                    return alertDialog();
                  });
            },
            child: Text(
              "Yeni Veri Ekle",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )));
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                _maliyetEkle(Maliyet(
                    malzemeAdi.text,
                    double.parse(fireOraniController.text),
                    maliyetListesi.length == 0
                        ? iscilikMaliyeti
                        : maliyetListesi.last.iscilikMaliyeti,
                    double.parse(kgBrutController.text),
                    double.parse(kgFiyatController.text),
                    double.parse(kgBrutController.text) *
                        double.parse(fireOraniController.text),
                    0,
                    0,
                    0,
                    double.parse(kgBrutController.text) *
                        double.parse(fireOraniController.text) *
                        double.parse(kgFiyatController.text),
                    0));

                Fluttertoast.showToast(
                    msg: malzemeAdi.text + " Eklendi",
                    gravity: ToastGravity.TOP);
                Navigator.pop(context);
              });
            },
            child: Text("Ekle"))
      ],
      scrollable: true,
      title: Text("Veri Ekleme"),
      content: Container(
        child: formForAlert(),
      ),
    );
  }

  Form formForAlert() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextField(
              controller: malzemeAdi,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Malzeme Adı"),
            ),
            alertInput("KG", kgBrutController),
            alertInput("Fire Oranları", fireOraniController),
            alertInput("Fiyat", kgFiyatController),
          ],
        ));
  }

  AlertDialog changeInformation(int i, e) {
    return AlertDialog(
      actions: [changeInformationDone(i), changeInformationDelete(i, e)],
      scrollable: true,
      title: Text("Veri Güncelleme"),
      content: Container(
        child: Form(
            child: Column(
          children: [
            TextField(
              controller: malzemeAdi,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Malzeme Adı"),
            ),
            alertInput("KG", kgBrutController),
            alertInput("Fire Oranı", fireOraniController),
            alertInput("Fiyat", kgFiyatController),
          ],
        )),
      ),
    );
  }

  ElevatedButton changeInformationDone(int i) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _maliyetGuncelle(
                Maliyet.withID(
                    malzemeAdi.text,
                    double.parse(fireOraniController.text),
                    maliyetListesi.length == 0
                        ? iscilikMaliyeti
                        : maliyetListesi.last.iscilikMaliyeti,
                    maliyetListesi[i].id,
                    double.parse(kgBrutController.text),
                    double.parse(kgFiyatController.text),
                    double.parse(kgBrutController.text) *
                        double.parse(fireOraniController.text),
                    0,
                    0,
                    0,
                    double.parse(kgBrutController.text) *
                        double.parse(fireOraniController.text) *
                        double.parse(kgFiyatController.text),
                    0),
                i);
            Fluttertoast.showToast(
                msg: malzemeAdi.text + " Güncellendi",
                gravity: ToastGravity.TOP);
            Navigator.pop(context);
          });
        },
        child: Text("Güncelle"));
  }

  ElevatedButton changeInformationDelete(int i, e) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            debugPrint("e : " + i.toString());
            _maliyetSil(maliyetListesi[i], i);
            Fluttertoast.showToast(
                msg: malzemeAdi.text + " Silindi", gravity: ToastGravity.TOP);
            Navigator.pop(context);
          });
        },
        child: Text("Sil"));
  }

  AlertDialog changeLaborCost() {
    return AlertDialog(
      actions: [changeLaborCostDone()],
      scrollable: true,
      title: Text("İşçilik Maliyeti Güncelleme"),
      content: Container(
        child: Form(
            child: Column(
          children: [
            alertInput("İşçilik Maliyeti", iscilikMaliyetiController),
          ],
        )),
      ),
    );
  }

  ElevatedButton changeLaborCostDone() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            for (int i = 0; i < maliyetListesi.length; i++) {
              maliyetListesi[i].iscilikMaliyeti =
                  double.parse(iscilikMaliyetiController.text);
            }
            _updateValues();
            Fluttertoast.showToast(
                msg: "İşcilik Maliyeti Güncellendi", gravity: ToastGravity.TOP);
            Navigator.pop(context);
          });
        },
        child: Text("Güncelle"));
  }

  TextFormField alertInput(String text, controller) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
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
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: text),

      /*   child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: text),
      ), */
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

  void _maliyetEkle(Maliyet maliyet) async {
    var eklenenYeniAnalizIDsi = await _databaseHelper.maliyetEkle(maliyet);
    maliyet.id = eklenenYeniAnalizIDsi;
    if (eklenenYeniAnalizIDsi > 0) {
      setState(() {
        maliyetListesi.insert(0, maliyet);
        _updateValues();
      });
    }
  }

  void _tumTabloyuTemizle() async {
    var silinenElemanSayisi = await _databaseHelper.tumMaliyetTablosunuSil();
    if (silinenElemanSayisi > 0) {
      print("tüm tablo temizlendi eleman sayisi : $silinenElemanSayisi");
      setState(() {
        maliyetListesi.clear();
      });
    }
  }

  void _maliyetSil(dbdenSilmekIcinListeNumarasi, int index) async {
    var sonuc =
        await _databaseHelper.maliyetSil(dbdenSilmekIcinListeNumarasi.id);
    if (sonuc == 1) {
      print("kayıt silindi : " + dbdenSilmekIcinListeNumarasi.id.toString());
      setState(() {
        maliyetListesi.removeAt(index);
        _updateValues();
      });
    }
  }

  void _maliyetGuncelle(Maliyet maliyet, int index) async {
    setState(() {
      debugPrint("a : " + maliyetListesi.toString());
      maliyetListesi[index] = maliyet;
      _updateValues();
      debugPrint("i : " + maliyetListesi.toString());
    });
  }

  void _updateValues() {
    double geciciKilo = 0;
    double geciciNetKg = 0;
    double geciciTutar = 0;

    //kgToplam bulucu
    for (int i = 0; i < maliyetListesi.length; i++) {
      geciciKilo = geciciKilo + maliyetListesi[i].kgBrut;
    }
    for (int i = 0; i < maliyetListesi.length; i++) {
      maliyetListesi[i].kgToplam = geciciKilo;
    }

    //netKg bulucu
    for (int i = 0; i < maliyetListesi.length; i++) {
      geciciNetKg = geciciNetKg + maliyetListesi[i].kgNet;
    }
    for (int i = 0; i < maliyetListesi.length; i++) {
      maliyetListesi[i].netMamul = geciciNetKg;
    }

    //ort fire bulucu
    for (int i = 0; i < maliyetListesi.length; i++) {
      maliyetListesi[i].ortFire = geciciNetKg / maliyetListesi.last.kgToplam;
    }

    //işçilik hariç tutar toplamı bulucu
    for (int i = 0; i < maliyetListesi.length; i++) {
      geciciTutar = geciciTutar + maliyetListesi[i].toplamTutar;
    }

    // işçilik ile tutar toplamı bulucu
    for (int i = 0; i < maliyetListesi.length; i++) {
      maliyetListesi[i].tutarToplami = geciciTutar +
          maliyetListesi.last.kgNet * maliyetListesi.last.iscilikMaliyeti;
    }
  }
}
