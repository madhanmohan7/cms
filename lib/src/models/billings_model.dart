class Billings {
  int? transactionId;
  int? userId;
  int? pointId;
  String? startTime;
  String? endTime;
  int? energyConsumed;
  int? cost;
  String? status;
  int? otp;
  int? organizationId;
  String? stationId;

  Billings(
      {this.transactionId,
        this.userId,
        this.pointId,
        this.startTime,
        this.endTime,
        this.energyConsumed,
        this.cost,
        this.status,
        this.otp,
        this.organizationId,
        this.stationId,
      });

  factory Billings.fromJson(Map<String, dynamic> json) {
    return Billings(
    transactionId: json['transaction_id'],
    userId: json['user_id'],
    pointId: json['point_id'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    energyConsumed: json['energy_consumed'],
    cost: json['cost'],
    status: json['status'],
    otp: json['otp'],
    organizationId: json['organization_id'],
    stationId: json['station_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] =transactionId;
    data['user_id'] = userId;
    data['point_id'] = pointId;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['energy_consumed'] = energyConsumed;
    data['cost'] = cost;
    data['status'] = status;
    data['otp'] = otp;
    data['organization_id'] = organizationId;
    data['station_id'] = stationId;
    return data;
  }
}
