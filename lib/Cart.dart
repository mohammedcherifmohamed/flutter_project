
class CartItem {
  final int pid;
  final String title;
  final double price;
  final String img;
  int quantity;

  CartItem({
    required this.pid, 
    required this.title, 
    required this.price, 
    required this.img,
    this.quantity = 1
  });
}

class Cart {
  static final Cart _instance = Cart._internal();

  factory Cart() {
    return _instance;
  }

  Cart._internal();

  List<CartItem> items = [];

  void add(int pid, String title, double price, String img, int quantity) {
    // Check if item exists
    try {
        var existingItem = items.firstWhere((item) => item.pid == pid);
        existingItem.quantity += quantity;
    } catch (e) {
        // Item does not exist
        items.add(CartItem(
            pid: pid, 
            title: title, 
            price: price, 
            img: img, 
            quantity: quantity
        ));
    }
  }

  void remove(int pid) {
    items.removeWhere((item) => item.pid == pid);
  }

  void clear() {
    items.clear();
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
