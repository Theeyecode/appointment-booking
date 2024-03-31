enum UserType { merchant, customer, unKnown }

extension FeaturesExtension on UserType {
  String get title {
    switch (this) {
      case UserType.merchant:
        return 'Merchant';
      case UserType.customer:
        return 'customer';
      case UserType.unKnown:
        return 'unknown';
    }
  }
}
