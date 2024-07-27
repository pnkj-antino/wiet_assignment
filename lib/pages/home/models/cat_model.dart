import 'dart:convert';

CatModel catModelFromJson(String str) => CatModel.fromJson(json.decode(str));

String catModelToJson(CatModel data) => json.encode(data.toJson());

class CatModel {
  String version;
  bool isSuccess;
  Result result;
  String message;
  int statusCode;

  CatModel({
    required this.version,
    required this.isSuccess,
    required this.result,
    required this.message,
    required this.statusCode,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) => CatModel(
        version: json["Version"],
        isSuccess: json["IsSuccess"],
        result: Result.fromJson(json["Result"]),
        message: json["Message"],
        statusCode: json["StatusCode"],
      );

  Map<String, dynamic> toJson() => {
        "Version": version,
        "IsSuccess": isSuccess,
        "Result": result.toJson(),
        "Message": message,
        "StatusCode": statusCode,
      };
}

class Result {
  List<Cat> cats;
  List<Tier> tiers;
  String currentTier;
  int tierPoints;

  Result({
    required this.cats,
    required this.tiers,
    required this.currentTier,
    required this.tierPoints,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        cats: List<Cat>.from(json["cats"].map((x) => Cat.fromJson(x))),
        tiers: List<Tier>.from(json["tiers"].map((x) => Tier.fromJson(x))),
        currentTier: json["currentTier"],
        tierPoints: json["tierPoints"],
      );

  Map<String, dynamic> toJson() => {
        "cats": List<dynamic>.from(cats.map((x) => x.toJson())),
        "tiers": List<dynamic>.from(tiers.map((x) => x.toJson())),
        "currentTier": currentTier,
        "tierPoints": tierPoints,
      };
}

class Cat {
  String id;
  String url;
  int width;
  int height;

  Cat({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        id: json["id"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "width": width,
        "height": height,
      };
}

class Tier {
  String tierName;
  int minPoint;
  int maxPoint;
  int seqNo;
  String fontColor;
  String bgColor;
  dynamic widgets;

  Tier({
    required this.tierName,
    required this.minPoint,
    required this.maxPoint,
    required this.seqNo,
    required this.fontColor,
    required this.bgColor,
    required this.widgets,
  });

  factory Tier.fromJson(Map<String, dynamic> json) => Tier(
        tierName: json["tierName"],
        minPoint: json["minPoint"],
        maxPoint: json["maxPoint"],
        seqNo: json["seqNo"],
        fontColor: json["fontColor"],
        bgColor: json["bgColor"],
        widgets: json["widgets"],
      );

  Map<String, dynamic> toJson() => {
        "tierName": tierName,
        "minPoint": minPoint,
        "maxPoint": maxPoint,
        "seqNo": seqNo,
        "fontColor": fontColor,
        "bgColor": bgColor,
        "widgets": widgets,
      };
}
