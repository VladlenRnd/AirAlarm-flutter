import 'package:equatable/equatable.dart';

class WatNewModel extends Equatable {
  const WatNewModel({
    required this.newVersion,
    required this.url,
    required this.discription,
  });

  final String? newVersion;
  final String? url;
  final List<String> discription;

  factory WatNewModel.fromJson(Map<String, dynamic> json) {
    return WatNewModel(
      newVersion: json["newVersion"],
      url: json["url"],
      discription: json["discription"] == null ? [] : List<String>.from(json["discription"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "newVersion": newVersion,
        "url": url,
        "discription": discription.map((x) => x).toList(),
      };

  @override
  List<Object?> get props => [
        newVersion,
        url,
        discription,
      ];
}
