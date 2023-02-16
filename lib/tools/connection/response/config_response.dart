class ConfigResponse {
  late final bool? war;
  late final DateTime? startWarDate;
  late final DateTime? endWarDate;

  late final String urlAlarm;
  late final String urlHistory;
  late final String urlUpdate;

  ConfigResponse({
    required this.war,
    required this.urlAlarm,
    required this.urlUpdate,
    required this.urlHistory,
    required this.startWarDate,
    required this.endWarDate,
  });

  ConfigResponse.fromJson(Map<String, dynamic> json) {
    war = json['war'];
    startWarDate = json["startWarDate"] != null ? DateTime.parse(json["startWarDate"]) : null;
    endWarDate = json["endWarDate"] != null ? DateTime.parse(json["endWarDate"]) : null;

    urlAlarm = json["url_alarm"] ?? "";
    urlHistory = json["url_history"] ?? "";
    urlUpdate = json["url_update"] ?? "";
  }
}
