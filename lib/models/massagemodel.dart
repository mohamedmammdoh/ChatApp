class MassageModel {
  final String massage_text;
  final String id;
  MassageModel(this.massage_text, this.id);

  factory MassageModel.fromjson(jsondata) {
    return MassageModel(jsondata['massages'], jsondata['id']);
  }
}
