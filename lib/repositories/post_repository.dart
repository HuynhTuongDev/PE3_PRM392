import '../models/post.dart';
import '../services/api_service.dart';
import '../storage/local_storage_service.dart';
import '../core/errors/exceptions.dart';

class PostRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  PostRepository({
    required this.apiService,
    required this.localStorageService,
  });

  Future<List<Post>> fetchPosts(int page, {int limit = 10}) async {
    try {
      final remotePosts = await apiService.fetchPosts(page, limit: limit);
      
      // Update favorites from local storage
      final favoriteIds = localStorageService.getFavorites();
      for (var post in remotePosts) {
        if (favoriteIds.contains(post.id)) {
          post.isFavorite = true;
        }
      }

      // If page 1, cache the posts for offline use
      if (page == 1) {
        await localStorageService.cachePosts(remotePosts);
      }

      return remotePosts;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        // Fallback to cache if first page and error occurs
        if (page == 1) {
          final cachedPosts = localStorageService.getCachedPosts();
          if (cachedPosts.isNotEmpty) {
            final favoriteIds = localStorageService.getFavorites();
            for (var post in cachedPosts) {
              if (favoriteIds.contains(post.id)) {
                post.isFavorite = true;
              }
            }
            return cachedPosts;
          }
        }
      }
      rethrow;
    }
  }

  Future<void> toggleFavorite(Post post) async {
    if (post.isFavorite) {
      await localStorageService.removeFavorite(post.id);
    } else {
      await localStorageService.saveFavorite(post.id);
    }
  }

  List<int> getFavoriteIds() {
    return localStorageService.getFavorites();
  }
}
