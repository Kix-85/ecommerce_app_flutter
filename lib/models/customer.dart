class Customer {
  final int custId;
  final String? fName;
  final String? lName;
  final String? phone;
  final String? email;
  final String? addressCity;
  final String? addressCountry;

  Customer({
    required this.custId,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.addressCity,
    this.addressCountry,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      custId: json['cust_id'] as int,
      fName: json['f_name'] as String?,
      lName: json['l_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      addressCity: json['address_city'] as String?,
      addressCountry: json['address_country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cust_id': custId,
      'f_name': fName,
      'l_name': lName,
      'phone': phone,
      'email': email,
      'address_city': addressCity,
      'address_country': addressCountry,
    };
  }
}
