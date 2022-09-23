class ConfigResponse {
  late final bool? war;
  late final DateTime? startWarDate;

  ConfigResponse({
    required this.war,
  });

  ConfigResponse.fromJson(Map<String, dynamic> json) {
    war = json['war'];
    startWarDate = DateTime.parse(json["startWarDate"]);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['war'] = war;
    return data;
  }
}
