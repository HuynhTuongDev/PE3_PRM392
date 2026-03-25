import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class LocalStorageService {
  final SharedPreferences prefs;
  static const String favoritesKey = 'favorite_post_ids';
  static const String postsCacheKey = 'posts_cache';

  LocalStorageService({required this.prefs});

  // Save/Get Favorites (Stored as IDs)
  Future<void> saveFavorite(int postId) async {
    final favorites = getFavorites();
    if (!favorites.contains(postId)) {
      favorites.add(postId);
      await prefs.setStringList(
          favoritesKey, favorites.map((e) => e.toString()).toList());
    }
  }

  Future<void> removeFavorite(int postId) async {
    final favorites = getFavorites();
    if (favorites.contains(postId)) {
      favorites.remove(postId);
      await prefs.setStringList(
          favoritesKey, favorites.map((e) => e.toString()).toList());
    }
  }

  List<int> getFavorites() {
    final strings = prefs.getStringList(favoritesKey) ?? [];
    return strings.map((e) => int.parse(e)).toList();
  }

  // Cache Posts
  Future<void> cachePosts(List<Post> posts) async {
    final jsonList = posts.map((post) => post.toJson()).toList();
    await prefs.setString(postsCacheKey, jsonEncode(jsonList));
  }

  List<Post> getCachedPosts() {
    final jsonString = prefs.getString(postsCacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    }
    return [];
  }
}
