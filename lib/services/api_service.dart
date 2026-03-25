import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../core/errors/exceptions.dart';

class ApiService {
  final http.Client client;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  ApiService({required this.client});

  Future<List<Post>> fetchPosts(int page, {int limit = 10}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/posts?_page=$page&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load posts (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred: $e');
    }
  }
}
