import 'package:flutter/material.dart';

class Base_View_Model extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _noInternet = false;

  bool _isDisposed = false;

  bool get isLoading => _isLoading;
  bool get noInternet => _noInternet;
  String get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    if (_isDisposed) return;
    _noInternet = errorMessage.toLowerCase().contains('no internet');
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    if (_isDisposed) return;
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    if (_isDisposed) return;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}