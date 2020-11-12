// To parse this JSON data, do
//
//     final paymentProcessingApi = paymentProcessingApiFromJson(jsonString);

import 'dart:convert';

PaymentProcessingApi paymentProcessingApiFromJson(String str) => PaymentProcessingApi.fromJson(json.decode(str));

String paymentProcessingApiToJson(PaymentProcessingApi data) => json.encode(data.toJson());

class PaymentProcessingApi {
    PaymentProcessingApi({
        this.success,
        this.processingFeeAmount,
        this.amount,
        this.total,
    });

    bool success;
    int processingFeeAmount;
    int amount;
    int total;

    factory PaymentProcessingApi.fromJson(Map<String, dynamic> json) => PaymentProcessingApi(
        success: json["success"],
        processingFeeAmount: json["processing_fee_amount"],
        amount: json["amount"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "processing_fee_amount": processingFeeAmount,
        "amount": amount,
        "total": total,
    };
}
