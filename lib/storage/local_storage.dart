import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class LocalStorage {
  static const String favoritesKey = 'favorite_posts';
  static const String postsCacheKey = 'posts_cache';

  Future<void> saveFavorites(List<Post> favorites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds = favorites.map((p) => p.id.toString()).toList();
    await prefs.setStringList(favoritesKey, favoriteIds);
  }

  Future<List<int>> getFavoriteIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList(favoritesKey);
    return ids?.map(int.parse).toList() ?? [];
  }

  Future<void> cachePosts(List<Post> posts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String postsJson = json.encode(posts.map((p) => p.toJson()).toList());
    await prefs.setString(postsCacheKey, postsJson);
  }

  Future<List<Post>> getCachedPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? postsJson = prefs.getString(postsCacheKey);
    if (postsJson == null) return [];
    final List<dynamic> data = json.decode(postsJson);
    return data.map((json) => Post.fromJson(json)).toList();
  }
}
