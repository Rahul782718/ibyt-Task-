import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../Api_Response/Base_View_Model.dart';
import '../Api_Response/Product_Response.dart';
import '../Api_Service/Api_Service.dart';
import 'SharedPrefsService.dart';

class ServiceProvider extends Base_View_Model {

  ///App BaseUrl
  static const baseUrl = 'https://dummyjson.com';

  /// get Instance SharedPrefsService
  final SharedPrefsService _prefs = SharedPrefsService();
  ProductResponse? _productResponse;
  ProductResponse? get productResponse => _productResponse;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ServiceProvider() {
    _init();
  }

  void _init() async {
    await _checkAndLoadData();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await _fetchFromApi();
      }
    });
  }

  Future<void> _checkAndLoadData() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _fetchFromApi();
    } else {
      await _loadFromCache();
    }
  }

  Future<void> _fetchFromApi() async {
    setLoading(true);
    clearErrorMessage();
    try {
      final response = await ApiService.getRequest('$baseUrl/products');
      _productResponse = ProductResponse.fromJson(response);
      await _prefs.saveProducts(_productResponse!);
    } catch (e) {
      setErrorMessage("API Error: $e");
      await _loadFromCache();
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> _loadFromCache() async {
    final cached = await _prefs.getCachedProducts();
    if (cached.isNotEmpty) {
      _productResponse = ProductResponse(products: cached);
    } else {
      _productResponse = null;
      setErrorMessage("No Internet & No Cached Data");
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
