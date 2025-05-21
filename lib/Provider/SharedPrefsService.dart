import 'dart:convert';
import 'package:ibyteinfomatics_test/Api_Response/Product_Response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _productKey = 'cached_products';

  Future<void> saveProducts(ProductResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedList = response.products
        .map((product) => jsonEncode(product.toJson()))
        .toList();

    await prefs.setStringList(_productKey, encodedList);
  }

  Future<List<Product>> getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedList = prefs.getStringList(_productKey);
    if (encodedList == null) return [];
    return encodedList
        .map((productString) => Product.fromJson(jsonDecode(productString)))
        .toList();
  }

}
