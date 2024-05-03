enum SubscriptionType { basic, silver, gold }

extension SubscriptTypeString on String {
  SubscriptionType get subscriptionType {
    switch (this) {
      case 'basic':
        return SubscriptionType.basic;
      case 'silver':
        return SubscriptionType.silver;
      case 'gold':
        return SubscriptionType.gold;
      default:
        return SubscriptionType.basic;
    }
  }
}
