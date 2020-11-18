// To parse this JSON data, do
//
//     final remitaPaymentResponse = remitaPaymentResponseFromJson(jsonString);

import 'dart:convert';

RemitaPaymentResponse remitaPaymentResponseFromJson(String str) =>
    RemitaPaymentResponse.fromJson(json.decode(str));

String remitaPaymentResponseToJson(RemitaPaymentResponse data) =>
    json.encode(data.toJson());

class RemitaPaymentResponse {
  RemitaPaymentResponse({
    this.paymentReference,
    this.processorId,
    this.transactionId,
    this.message,
    this.amount,
  });

  String paymentReference;
  String processorId;
  String transactionId;
  String message;
  dynamic amount;

  factory RemitaPaymentResponse.fromJson(Map<String, dynamic> json) =>
      RemitaPaymentResponse(
        paymentReference: json["paymentReference"],
        processorId: json["processorId"],
        transactionId: json["transactionId"],
        message: json["message"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "paymentReference": paymentReference,
        "processorId": processorId,
        "transactionId": transactionId,
        "message": message,
        "amount": amount,
      };
}
