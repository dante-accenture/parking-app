class TargaModel {
  int? id;
  String targa;
  String dataEntrata;
  String? dataUscita;

  TargaModel(
      {required this.targa,
      required this.dataEntrata,
      this.dataUscita,
      this.id});
}
