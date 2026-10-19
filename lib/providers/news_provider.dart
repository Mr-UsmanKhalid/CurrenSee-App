import 'package:flutter/foundation.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _service = NewsService();

  List<NewsModel> _articles = [];
  bool _isLoading = false;

  List<NewsModel> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> loadNews() async {
    _isLoading = true;
    notifyListeners();
    _articles = await _service.fetchNews();
    _isLoading = false;
    notifyListeners();
  }
}
