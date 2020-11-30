// To read payments from Json Data
// To parse this JSON data, do
//
//     final paymentApi = paymentApiFromJson(jsonString);

import 'dart:convert';

PaymentApi paymentApiFromJson(String str) =>
    PaymentApi.fromJson(json.decode(str));

String paymentApiToJson(PaymentApi data) => json.encode(data.toJson());

class PaymentApi {
  PaymentApi({
    this.success,
    this.payments,
  });

  bool success;
  List<Payment> payments;

  factory PaymentApi.fromJson(Map<String, dynamic> json) => PaymentApi(
        success: json["success"],
        payments: List<Payment>.from(
            json["payments"].map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
      };
}

class Payment {
  Payment({
    this.id,
    this.userId,
    this.amount,
    this.refCode,
    this.paymentType,
    this.startDate,
    this.expiryDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String userId;
  String amount;
  String refCode;
  String paymentType;
  DateTime startDate;
  DateTime expiryDate;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        userId: json["user_id"].toString(),
        amount: json["amount"].toString(),
        refCode: json["ref_code"],
        paymentType: json["payment_type"],
        startDate: DateTime.parse(json["start_date"]),
        expiryDate: DateTime.parse(json["expiry_date"]),
        status: json["status"].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "amount": amount,
        "ref_code": refCode,
        "payment_type": paymentType,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "expiry_date":
            "${expiryDate.year.toString().padLeft(4, '0')}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
