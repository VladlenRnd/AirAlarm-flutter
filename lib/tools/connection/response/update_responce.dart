class UpdateRespose {
  UpdateRespose({
    required this.newVersion,
    required this.url,
    required this.descroption,
  });
  late final String newVersion;
  late final String url;
  late final List<String> descroption;

  UpdateRespose.fromJson(Map<String, dynamic> json) {
    newVersion = json['newVersion'];
    url = json['url'];
    descroption = List.castFrom<dynamic, String>(json['descroption']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['newVersion'] = newVersion;
    data['url'] = url;
    data['descroption'] = descroption;
    return data;
  }
}
