
class Charger {
  int? pointId;
  String? stationId;
  String? pointType;
  String? status;
  int? organizationId;
  String? organizationName;
  bool isOperative;

  Charger({
    this.pointId,
    this.stationId,
    this.pointType,
    this.status,
    this.organizationId,
    this.organizationName,
    bool? isOperative,
  }) : isOperative = isOperative ?? (status == "Operative");

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(
      pointId: json['point_id'],
      stationId: json['station_id'],
      pointType: json['point_type'],
      status: json['status'],
      organizationId: json['organization_id'],
      organizationName: json['organization_name'],
      isOperative: json['is_operative'] ?? (json['status'] == "Operative"),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['point_id'] = pointId;
    data['station_id'] = stationId;
    data['point_type'] = pointType;
    data['status'] = status;
    data['organization_id'] = organizationId;
    data['organization_name'] = organizationName;
    data['is_operative'] = isOperative;
    return data;
  }
}



