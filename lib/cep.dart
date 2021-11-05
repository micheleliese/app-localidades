import 'dart:convert';


class Cep {
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  String? uf;
  String? ibge;
  String? gia;
  String? ddd;
  String? siafi;
  
  Cep({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
  });

  Cep copyWith({
    String? cep,
    String? logradouro,
    String? complemento,
    String? bairro,
    String? localidade,
    String? uf,
    String? ibge,
    String? gia,
    String? ddd,
    String? siafi,
  }) {
    return Cep(
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      localidade: localidade ?? this.localidade,
      uf: uf ?? this.uf,
      ibge: ibge ?? this.ibge,
      gia: gia ?? this.gia,
      ddd: ddd ?? this.ddd,
      siafi: siafi ?? this.siafi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }

  factory Cep.fromMap(Map<String, dynamic> map) {
    return Cep(
      cep: map['cep'],
      logradouro: map['logradouro'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      localidade: map['localidade'],
      uf: map['uf'],
      ibge: map['ibge'],
      gia: map['gia'],
      ddd: map['ddd'],
      siafi: map['siafi'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cep.fromJson(String source) => Cep.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cep(cep: $cep, logradouro: $logradouro, complemento: $complemento, bairro: $bairro, localidade: $localidade, uf: $uf, ibge: $ibge, gia: $gia, ddd: $ddd, siafi: $siafi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Cep &&
      other.cep == cep &&
      other.logradouro == logradouro &&
      other.complemento == complemento &&
      other.bairro == bairro &&
      other.localidade == localidade &&
      other.uf == uf &&
      other.ibge == ibge &&
      other.gia == gia &&
      other.ddd == ddd &&
      other.siafi == siafi;
  }

  @override
  int get hashCode {
    return cep.hashCode ^
      logradouro.hashCode ^
      complemento.hashCode ^
      bairro.hashCode ^
      localidade.hashCode ^
      uf.hashCode ^
      ibge.hashCode ^
      gia.hashCode ^
      ddd.hashCode ^
      siafi.hashCode;
  }
}
