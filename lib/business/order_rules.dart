class OrderRules {
  static bool canPlaceOrder(int itemCount, double total) {
    return itemCount > 0 && total >= 0;
  }
}
