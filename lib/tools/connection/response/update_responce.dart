class UpdateRespose {
  UpdateRespose({
    required this.newVersion,
    required this.url,
    required this.descroption,
  });
  late final String newVersion;
  late final String url;
  late final String descroption;

  UpdateRespose.fromJson(Map<String, dynamic> json) {
    newVersion = json['newVersion'];
    url = json['url'];
    descroption = json['descroption'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['newVersion'] = newVersion;
    _data['url'] = url;
    _data['descroption'] = descroption;
    return _data;
  }
}
