class ConfigResponse {
  ConfigResponse({
    required this.war,
  });
  late final bool? war;

  ConfigResponse.fromJson(Map<String, dynamic> json) {
    war = json['war'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['war'] = war;
    return _data;
  }
}
