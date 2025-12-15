class TrackingDetail {
  final int trackingNo;
  final String? courierName;

  TrackingDetail({
    required this.trackingNo,
    this.courierName,
  });

  factory TrackingDetail.fromJson(Map<String, dynamic> json) {
    return TrackingDetail(
      trackingNo: json['tracking_no'] as int,
      courierName: json['courier_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tracking_no': trackingNo,
      'courier_name': courierName,
    };
  }
}
