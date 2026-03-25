import 'package:flutter/material.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository repository;

  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  List<Post> _favorites = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _currentPage = 1;
  bool _hasNextPage = true;
  String _searchQuery = '';

  PostProvider({required this.repository});

  List<Post> get posts => _searchQuery.isEmpty ? _posts : _filteredPosts;
  List<Post> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  String get searchQuery => _searchQuery;

  // Initial fetch or Refresh
  Future<void> fetchPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _posts = [];
      _hasNextPage = true;
    }

    if (!_hasNextPage) return;

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final newPosts = await repository.fetchPosts(_currentPage);
      if (newPosts.isEmpty) {
        _hasNextPage = false;
      } else {
        _posts.addAll(newPosts);
        _currentPage++;
        if (newPosts.length < 10) {
          _hasNextPage = false;
        }
      }
      _updateFavoritesList();
      _filterPosts(); // Local Search Filter Update
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateFavoritesList() {
    _favorites = _posts.where((post) => post.isFavorite).toList();
  }

  Future<void> toggleFavorite(Post post) async {
    await repository.toggleFavorite(post);
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      _posts[index].isFavorite = !_posts[index].isFavorite;
    }
    _updateFavoritesList();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _filterPosts();
    notifyListeners();
  }

  void _filterPosts() {
    if (_searchQuery.isEmpty) {
      _filteredPosts = [];
    } else {
      _filteredPosts = _posts
          .where((post) =>
              post.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }
}
