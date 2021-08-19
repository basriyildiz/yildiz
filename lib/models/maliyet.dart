class Maliyet {
  int? _id;
  String? _malzemeAdlari;
  double? _kgBrut;
  double? _kgFiyatlar;
  double? _fireOranlari;
  double? _kgNet;
  double? _toplamTutar;
  double? _iscilikMaliyeti;
  double? _kgToplam;
  double? _ortFire;
  double? _tutarToplami;
  double? _netMamul;
  get id => this._id;

  set id(value) => this._id = value;

  get malzemeAdlari => this._malzemeAdlari;

  set malzemeAdlari(value) => this._malzemeAdlari = value;

  get kgBrut => this._kgBrut;

  set kgBrut(value) => this._kgBrut = value;

  get kgFiyatlar => this._kgFiyatlar;

  set kgFiyatlar(value) => this._kgFiyatlar = value;

  get fireOranlari => this._fireOranlari;

  set fireOranlari(value) => this._fireOranlari = value;

  get kgNet => this._kgNet;

  set kgNet(value) => this._kgNet = value;

  get toplamTutar => this._toplamTutar;

  set toplamTutar(value) => this._toplamTutar = value;

  get iscilikMaliyeti => this._iscilikMaliyeti;

  set iscilikMaliyeti(value) => this._iscilikMaliyeti = value;

  get kgToplam => this._kgToplam;

  set kgToplam(value) => this._kgToplam = value;

  get ortFire => this._ortFire;

  set ortFire(value) => this._ortFire = value;

  get tutarToplami => this._tutarToplami;

  set tutarToplami(value) => this._tutarToplami = value;

  get netMamul => this._netMamul;

  set netMamul(value) => this._netMamul = value;

  Maliyet(
    this._malzemeAdlari,
    this._fireOranlari,
    this._iscilikMaliyeti,
    this._kgBrut,
    this._kgFiyatlar,
    this._kgNet,
    this._kgToplam,
    this._netMamul,
    this._ortFire,
    this._toplamTutar,
    this._tutarToplami,
  );
  Maliyet.withID(
    this._malzemeAdlari,
    this._fireOranlari,
    this._iscilikMaliyeti,
    this._id,
    this._kgBrut,
    this._kgFiyatlar,
    this._kgNet,
    this._kgToplam,
    this._netMamul,
    this._ortFire,
    this._toplamTutar,
    this._tutarToplami,
  );

  Map<String, dynamic> dbyeYazmakIcinMapeDonustur() {
    var map = Map<String, dynamic>();

    map["id"] = _id;
    map["malzeme_adi"] = _malzemeAdlari;
    map["kg_brut"] = _kgBrut;
    map["kg_fiyat"] = _kgFiyatlar;
    map["fire_orani"] = _fireOranlari;
    map["kg_net"] = _kgNet;
    map["toplam_tutar"] = _toplamTutar;
    map["iscilik"] = _iscilikMaliyeti;
    map["kg_toplam"] = _kgToplam;
    map["ort_fire"] = _ortFire;
    map["tutar_toplami"] = _tutarToplami;
    map["net_mamul"] = _netMamul;
    return map;
  }

  Maliyet.dbdenOkudugunMapiObjeyeDonustur(Map<String, dynamic> map) {
    _id = map["id"];
    _malzemeAdlari = map["malzeme_adi"];
    _kgBrut = map["kg_brut"];
    _kgFiyatlar = map["kg_fiyat"];
    _fireOranlari = map["fire_orani"];
    _kgNet = map["kg_net"];
    _toplamTutar = map["toplam_tutar"];
    _iscilikMaliyeti = map["iscilik"];
    _kgToplam = map["kg_toplam"];
    _ortFire = map["ort_fire"];
    _tutarToplami = map["tutar_toplami"];
    _netMamul = map["net_mamul"];
  }

  @override
  String toString() {
    return "Maliyet{_id: $_id, _malzeme_adi: $_malzemeAdlari, _kg_brut: $_kgBrut, _kg_fiyat: $_kgFiyatlar, _fire_orani: $_fireOranlari, _kg_net: $_kgNet, _toplam_tutar: $_toplamTutar, _iscilik :$_iscilikMaliyeti,_kg_toplam: $_kgToplam,_ort_fire: $_ortFire,_tutar_toplami:$_tutarToplami,_net_mamul: $_netMamul}";
  }
}
