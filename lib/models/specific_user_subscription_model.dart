// To parse this JSON data, do
//
//     final specificUserSubscriptionModel = specificUserSubscriptionModelFromJson(jsonString);

import 'dart:convert';

SpecificUserSubscriptionModel specificUserSubscriptionModelFromJson(
        String str) =>
    SpecificUserSubscriptionModel.fromJson(json.decode(str));

String specificUserSubscriptionModelToJson(
        SpecificUserSubscriptionModel data) =>
    json.encode(data.toJson());

class SpecificUserSubscriptionModel {
  SpecificUserSubscriptionModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<SpecificUserSubscriptionModelDatum> data;
  String message;

  factory SpecificUserSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SpecificUserSubscriptionModel(
        success: json["success"],
        data: List<SpecificUserSubscriptionModelDatum>.from(json["data"]
            .map((x) => SpecificUserSubscriptionModelDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class SpecificUserSubscriptionModelDatum {
  SpecificUserSubscriptionModelDatum({
    this.id,
    this.object,
    this.applicationFeePercent,
    this.automaticTax,
    this.billingCycleAnchor,
    this.billingThresholds,
    this.cancelAt,
    this.cancelAtPeriodEnd,
    this.canceledAt,
    this.collectionMethod,
    this.created,
    this.currentPeriodEnd,
    this.currentPeriodStart,
    this.customer,
    this.daysUntilDue,
    this.defaultPaymentMethod,
    this.defaultSource,
    this.defaultTaxRates,
    this.discount,
    this.endedAt,
    this.items,
    this.latestInvoice,
    this.livemode,
    this.metadata,
    this.nextPendingInvoiceItemInvoice,
    this.pauseCollection,
    this.paymentSettings,
    this.pendingInvoiceItemInterval,
    this.pendingSetupIntent,
    this.pendingUpdate,
    this.plan,
    this.quantity,
    this.schedule,
    this.startDate,
    this.status,
    this.transferData,
    this.trialEnd,
    this.trialStart,
  });

  String id;
  String object;
  dynamic applicationFeePercent;
  AutomaticTax automaticTax;
  int billingCycleAnchor;
  dynamic billingThresholds;
  dynamic cancelAt;
  bool cancelAtPeriodEnd;
  dynamic canceledAt;
  String collectionMethod;
  int created;
  int currentPeriodEnd;
  int currentPeriodStart;
  String customer;
  dynamic daysUntilDue;
  String defaultPaymentMethod;
  dynamic defaultSource;
  List<dynamic> defaultTaxRates;
  dynamic discount;
  dynamic endedAt;
  Items items;
  String latestInvoice;
  bool livemode;
  List<dynamic> metadata;
  dynamic nextPendingInvoiceItemInvoice;
  dynamic pauseCollection;
  PaymentSettings paymentSettings;
  dynamic pendingInvoiceItemInterval;
  dynamic pendingSetupIntent;
  dynamic pendingUpdate;
  Plan plan;
  int quantity;
  dynamic schedule;
  int startDate;
  String status;
  dynamic transferData;
  dynamic trialEnd;
  dynamic trialStart;

  factory SpecificUserSubscriptionModelDatum.fromJson(
          Map<String, dynamic> json) =>
      SpecificUserSubscriptionModelDatum(
        id: json['sub']["id"],
        object: json['sub']["object"],
        applicationFeePercent: json['sub']["application_fee_percent"],
        automaticTax: AutomaticTax.fromJson(json['sub']["automatic_tax"]),
        billingCycleAnchor: json['sub']["billing_cycle_anchor"],
        billingThresholds: json['sub']["billing_thresholds"],
        cancelAt: json['sub']["cancel_at"],
        cancelAtPeriodEnd: json['sub']["cancel_at_period_end"],
        canceledAt: json['sub']["canceled_at"],
        collectionMethod: json['sub']["collection_method"],
        created: json['sub']["created"],
        currentPeriodEnd: json['sub']["current_period_end"],
        currentPeriodStart: json['sub']["current_period_start"],
        customer: json['sub']["customer"],
        daysUntilDue: json['sub']["days_until_due"],
        defaultPaymentMethod: json['sub']["default_payment_method"],
        defaultSource: json['sub']["default_source"],
        defaultTaxRates:
            List<dynamic>.from(json['sub']["default_tax_rates"].map((x) => x)),
        discount: json['sub']["discount"],
        endedAt: json['sub']["ended_at"],
        items: Items.fromJson(json['sub']["items"]),
        latestInvoice: json['sub']["latest_invoice"],
        livemode: json['sub']["livemode"],
        metadata: List<dynamic>.from(json['sub']["metadata"].map((x) => x)),
        nextPendingInvoiceItemInvoice:
            json['sub']["next_pending_invoice_item_invoice"],
        pauseCollection: json['sub']["pause_collection"],
        paymentSettings: PaymentSettings.fromJson(json['sub']["payment_settings"]),
        pendingInvoiceItemInterval: json['sub']["pending_invoice_item_interval"],
        pendingSetupIntent: json['sub']["pending_setup_intent"],
        pendingUpdate: json['sub']["pending_update"],
        plan: Plan.fromJson(json['sub']["plan"]),
        quantity: json['sub']["quantity"],
        schedule: json['sub']["schedule"],
        startDate: json['sub']["start_date"],
        status: json['sub']["status"],
        transferData: json['sub']["transfer_data"],
        trialEnd: json['sub']["trial_end"],
        trialStart: json['sub']["trial_start"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "application_fee_percent": applicationFeePercent,
        "automatic_tax": automaticTax.toJson(),
        "billing_cycle_anchor": billingCycleAnchor,
        "billing_thresholds": billingThresholds,
        "cancel_at": cancelAt,
        "cancel_at_period_end": cancelAtPeriodEnd,
        "canceled_at": canceledAt,
        "collection_method": collectionMethod,
        "created": created,
        "current_period_end": currentPeriodEnd,
        "current_period_start": currentPeriodStart,
        "customer": customer,
        "days_until_due": daysUntilDue,
        "default_payment_method": defaultPaymentMethod,
        "default_source": defaultSource,
        "default_tax_rates": List<dynamic>.from(defaultTaxRates.map((x) => x)),
        "discount": discount,
        "ended_at": endedAt,
        "items": items.toJson(),
        "latest_invoice": latestInvoice,
        "livemode": livemode,
        "metadata": List<dynamic>.from(metadata.map((x) => x)),
        "next_pending_invoice_item_invoice": nextPendingInvoiceItemInvoice,
        "pause_collection": pauseCollection,
        "payment_settings": paymentSettings.toJson(),
        "pending_invoice_item_interval": pendingInvoiceItemInterval,
        "pending_setup_intent": pendingSetupIntent,
        "pending_update": pendingUpdate,
        "plan": plan.toJson(),
        "quantity": quantity,
        "schedule": schedule,
        "start_date": startDate,
        "status": status,
        "transfer_data": transferData,
        "trial_end": trialEnd,
        "trial_start": trialStart,
      };
}

class AutomaticTax {
  AutomaticTax({
    this.enabled,
  });

  bool enabled;

  factory AutomaticTax.fromJson(Map<String, dynamic> json) => AutomaticTax(
        enabled: json["enabled"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
      };
}

class Items {
  Items({
    this.object,
    this.data,
    this.hasMore,
    this.totalCount,
    this.url,
  });

  String object;
  List<ItemsDatum> data;
  bool hasMore;
  int totalCount;
  String url;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        object: json["object"],
        data: List<ItemsDatum>.from(
            json["data"].map((x) => ItemsDatum.fromJson(x))),
        hasMore: json["has_more"],
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class ItemsDatum {
  ItemsDatum({
    this.id,
    this.object,
    this.billingThresholds,
    this.created,
    this.metadata,
    this.plan,
    this.price,
    this.quantity,
    this.subscription,
    this.taxRates,
  });

  String id;
  String object;
  dynamic billingThresholds;
  int created;
  List<dynamic> metadata;
  Plan plan;
  Price price;
  int quantity;
  String subscription;
  List<dynamic> taxRates;

  factory ItemsDatum.fromJson(Map<String, dynamic> json) => ItemsDatum(
        id: json["id"],
        object: json["object"],
        billingThresholds: json["billing_thresholds"],
        created: json["created"],
        metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
        plan: Plan.fromJson(json["plan"]),
        price: Price.fromJson(json["price"]),
        quantity: json["quantity"],
        subscription: json["subscription"],
        taxRates: List<dynamic>.from(json["tax_rates"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "billing_thresholds": billingThresholds,
        "created": created,
        "metadata": List<dynamic>.from(metadata.map((x) => x)),
        "plan": plan.toJson(),
        "price": price.toJson(),
        "quantity": quantity,
        "subscription": subscription,
        "tax_rates": List<dynamic>.from(taxRates.map((x) => x)),
      };
}

class Plan {
  Plan({
    this.id,
    this.object,
    this.active,
    this.aggregateUsage,
    this.amount,
    this.amountDecimal,
    this.billingScheme,
    this.created,
    this.currency,
    this.interval,
    this.intervalCount,
    this.livemode,
    this.metadata,
    this.nickname,
    this.product,
    this.tiersMode,
    this.transformUsage,
    this.trialPeriodDays,
    this.usageType,
  });

  String id;
  String object;
  bool active;
  dynamic aggregateUsage;
  int amount;
  String amountDecimal;
  String billingScheme;
  int created;
  String currency;
  String interval;
  int intervalCount;
  bool livemode;
  List<dynamic> metadata;
  dynamic nickname;
  String product;
  dynamic tiersMode;
  dynamic transformUsage;
  dynamic trialPeriodDays;
  String usageType;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        object: json["object"],
        active: json["active"],
        aggregateUsage: json["aggregate_usage"],
        amount: json["amount"],
        amountDecimal: json["amount_decimal"],
        billingScheme: json["billing_scheme"],
        created: json["created"],
        currency: json["currency"],
        interval: json["interval"],
        intervalCount: json["interval_count"],
        livemode: json["livemode"],
        metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
        nickname: json["nickname"],
        product: json["product"],
        tiersMode: json["tiers_mode"],
        transformUsage: json["transform_usage"],
        trialPeriodDays: json["trial_period_days"],
        usageType: json["usage_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "active": active,
        "aggregate_usage": aggregateUsage,
        "amount": amount,
        "amount_decimal": amountDecimal,
        "billing_scheme": billingScheme,
        "created": created,
        "currency": currency,
        "interval": interval,
        "interval_count": intervalCount,
        "livemode": livemode,
        "metadata": List<dynamic>.from(metadata.map((x) => x)),
        "nickname": nickname,
        "product": product,
        "tiers_mode": tiersMode,
        "transform_usage": transformUsage,
        "trial_period_days": trialPeriodDays,
        "usage_type": usageType,
      };
}

class Price {
  Price({
    this.id,
    this.object,
    this.active,
    this.billingScheme,
    this.created,
    this.currency,
    this.livemode,
    this.lookupKey,
    this.metadata,
    this.nickname,
    this.product,
    this.recurring,
    this.tiersMode,
    this.transformQuantity,
    this.type,
    this.unitAmount,
    this.unitAmountDecimal,
  });

  String id;
  String object;
  bool active;
  String billingScheme;
  int created;
  String currency;
  bool livemode;
  dynamic lookupKey;
  List<dynamic> metadata;
  dynamic nickname;
  String product;
  Recurring recurring;
  dynamic tiersMode;
  dynamic transformQuantity;
  String type;
  int unitAmount;
  String unitAmountDecimal;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        id: json["id"],
        object: json["object"],
        active: json["active"],
        billingScheme: json["billing_scheme"],
        created: json["created"],
        currency: json["currency"],
        livemode: json["livemode"],
        lookupKey: json["lookup_key"],
        metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
        nickname: json["nickname"],
        product: json["product"],
        recurring: Recurring.fromJson(json["recurring"]),
        tiersMode: json["tiers_mode"],
        transformQuantity: json["transform_quantity"],
        type: json["type"],
        unitAmount: json["unit_amount"],
        unitAmountDecimal: json["unit_amount_decimal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "active": active,
        "billing_scheme": billingScheme,
        "created": created,
        "currency": currency,
        "livemode": livemode,
        "lookup_key": lookupKey,
        "metadata": List<dynamic>.from(metadata.map((x) => x)),
        "nickname": nickname,
        "product": product,
        "recurring": recurring.toJson(),
        "tiers_mode": tiersMode,
        "transform_quantity": transformQuantity,
        "type": type,
        "unit_amount": unitAmount,
        "unit_amount_decimal": unitAmountDecimal,
      };
}

class Recurring {
  Recurring({
    this.aggregateUsage,
    this.interval,
    this.intervalCount,
    this.trialPeriodDays,
    this.usageType,
  });

  dynamic aggregateUsage;
  String interval;
  int intervalCount;
  dynamic trialPeriodDays;
  String usageType;

  factory Recurring.fromJson(Map<String, dynamic> json) => Recurring(
        aggregateUsage: json["aggregate_usage"],
        interval: json["interval"],
        intervalCount: json["interval_count"],
        trialPeriodDays: json["trial_period_days"],
        usageType: json["usage_type"],
      );

  Map<String, dynamic> toJson() => {
        "aggregate_usage": aggregateUsage,
        "interval": interval,
        "interval_count": intervalCount,
        "trial_period_days": trialPeriodDays,
        "usage_type": usageType,
      };
}

class PaymentSettings {
  PaymentSettings({
    this.paymentMethodOptions,
    this.paymentMethodTypes,
  });

  dynamic paymentMethodOptions;
  dynamic paymentMethodTypes;

  factory PaymentSettings.fromJson(Map<String, dynamic> json) =>
      PaymentSettings(
        paymentMethodOptions: json["payment_method_options"],
        paymentMethodTypes: json["payment_method_types"],
      );

  Map<String, dynamic> toJson() => {
        "payment_method_options": paymentMethodOptions,
        "payment_method_types": paymentMethodTypes,
      };
}
