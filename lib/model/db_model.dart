class TargaModel {
  int id;
  String targa;
  String dataEntrata;
  String ticket;
  String? dataUscita;

  TargaModel({
    required this.targa,
    required this.dataEntrata,
    this.dataUscita,
    required this.ticket,
    required this.id,
  });

  @override
  String toString() {
    return 'TargaModel{id: $id, targa: $targa, dataEntrata: $dataEntrata, dataUscita: $dataUscita}';
  }
}
