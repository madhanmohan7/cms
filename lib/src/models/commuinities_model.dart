// class Communities {
//   int? organizationId;
//   String? organizationName;
//   String? organizationCode;
//   int? totalChargers;
//
//   Communities({
//         this.organizationId,
//         this.organizationName,
//         this.organizationCode,
//         this.totalChargers
//   });
//
//   factory Communities.fromJson(Map<String, dynamic> json) {
//     return Communities(
//         organizationId: json['organization_id'],
//         organizationName: json['organization_name'],
//         organizationCode: json['organization_code'],
//         totalChargers: json['total_chargers'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['organization_id'] = organizationId;
//     data['organization_name'] = organizationName;
//     data['organization_code'] = organizationCode;
//     data['total_chargers'] = totalChargers;
//     return data;
//   }
// }

class Communities {
  int? organizationId;
  String? organizationName;
  String? organizationCode;
  int? totalChargers;
  String? license;

  Communities(
      {this.organizationId,
        this.organizationName,
        this.organizationCode,
        this.totalChargers,
        this.license});

  factory Communities.fromJson(Map<String, dynamic> json) {
    return Communities(
        organizationId: json['organization_id'],
        organizationName: json['organization_name'],
        organizationCode: json['organization_code'],
        totalChargers: json['total_chargers'],
        license: json['license'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['organization_id'] = organizationId;
    data['organization_name'] = organizationName;
    data['organization_code'] = organizationCode;
    data['total_chargers'] = totalChargers;
    data['license'] = license;
    return data;
  }

}
