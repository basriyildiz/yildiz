class Analiz {
  int? _id;
  String? _malzemeAdlari;
  double? _kgler;
  double? _alasimlar;
  double? _kgToplam;
  double? _analizOrani;

  get kgToplam => this._kgToplam;

  set kgToplam(value) => this._kgToplam = value;

  get analizOrani => this._analizOrani;

  set analizOrani(value) => this._analizOrani = value;

  get malzemeAdlari => this._malzemeAdlari;

  set malzemeAdlari(value) => this._malzemeAdlari = value;

  get kgler => this._kgler;

  set kgler(value) => this._kgler = value;

  get alasimlar => this._alasimlar;

  set alasimlar(value) => this._alasimlar = value;

  get id => this._id;

  set id(value) => this._id = value;

  Analiz(this._malzemeAdlari, this._kgler, this._alasimlar, this._kgToplam,
      this._analizOrani);
  Analiz.withID(this._id, this._malzemeAdlari, this._kgler, this._alasimlar,
      this._kgToplam, this._analizOrani);

  Map<String, dynamic> dbyeYazmakIcinMapeDonustur() {
    var map = Map<String, dynamic>();

    map["id"] = _id;
    map["malzeme_adi"] = _malzemeAdlari;
    map["kgler"] = _kgler;
    map["alasimlar"] = _alasimlar;
    map["kg_toplam"] = _kgToplam;
    map["analiz_orani"] = _analizOrani;
    return map;
  }

  Analiz.dbdenOkudugunMapiObjeyeDonustur(Map<String, dynamic> map) {
    _id = map["id"];
    _malzemeAdlari = map["malzeme_adi"];
    _kgler = map["kgler"];
    _alasimlar = map["alasimlar"];
    _kgToplam = map["kg_toplam"];
    _analizOrani = map["analiz_orani"];
  }

  @override
  String toString() {
    return "Analiz{_id: $_id, _malzeme_adi: $_malzemeAdlari, _kgler: $_kgler, _alasimlar: $_alasimlar, _kg_toplam: $_kgToplam, _analiz_orani: $_analizOrani}";
  }
}
