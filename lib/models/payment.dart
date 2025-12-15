class Payment {
  final String payNo;
  final double payAmount;
  final DateTime payDate;
  final int custId;

  Payment({
    required this.payNo,
    required this.payAmount,
    required this.payDate,
    required this.custId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      payNo: json['pay_no'] as String,
      payAmount: (json['pay_amount'] as num).toDouble(),
      payDate: DateTime.parse(json['pay_date']),
      custId: json['cust_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pay_no': payNo,
      'pay_amount': payAmount,
      'pay_date': payDate.toIso8601String(),
      'cust_id': custId,
    };
  }
}
