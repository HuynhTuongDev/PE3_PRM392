import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pe3/models/post.dart';
import 'package:pe3/repositories/post_repository.dart';
import 'package:pe3/services/api_service.dart';
import 'package:pe3/storage/local_storage_service.dart';
import 'package:pe3/core/errors/exceptions.dart';

class MockApiService extends Mock implements ApiService {
  @override
  Future<List<Post>> fetchPosts(int page, {int limit = 10}) =>
      super.noSuchMethod(
        Invocation.method(#fetchPosts, [page], {#limit: limit}),
        returnValue: Future.value(<Post>[]),
        returnValueForMissingStub: Future.value(<Post>[]),
      );
}

class MockLocalStorageService extends Mock implements LocalStorageService {
  @override
  List<int> getFavorites() => super.noSuchMethod(
        Invocation.method(#getFavorites, []),
        returnValue: <int>[],
        returnValueForMissingStub: <int>[],
      );

  @override
  Future<void> cachePosts(List<Post> posts) => super.noSuchMethod(
        Invocation.method(#cachePosts, [posts]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );

  @override
  List<Post> getCachedPosts() => super.noSuchMethod(
        Invocation.method(#getCachedPosts, []),
        returnValue: <Post>[],
        returnValueForMissingStub: <Post>[],
      );
}

void main() {
  late PostRepository repository;
  late MockApiService mockApiService;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() {
    mockApiService = MockApiService();
    mockLocalStorageService = MockLocalStorageService();
    repository = PostRepository(
      apiService: mockApiService,
      localStorageService: mockLocalStorageService,
    );
  });

  group('PostRepository fetchPosts', () {
    final tPosts = [
      Post(id: 1, userId: 1, title: 'Title', body: 'Body'),
    ];

    test('should return remote posts when API succeeds', () async {
      when(mockApiService.fetchPosts(1)).thenAnswer((_) async => tPosts);
      when(mockLocalStorageService.getFavorites()).thenReturn([]);
      when(mockLocalStorageService.cachePosts(tPosts)).thenAnswer((_) async => {});

      final result = await repository.fetchPosts(1);

      expect(result, isA<List<Post>>());
      expect(result.length, 1);
    });

    test('should return cached posts when API fails on page 1', () async {
      when(mockApiService.fetchPosts(1))
          .thenThrow(ServerException('Server failed'));
      when(mockLocalStorageService.getCachedPosts()).thenReturn(tPosts);
      when(mockLocalStorageService.getFavorites()).thenReturn([]);

      final result = await repository.fetchPosts(1);

      expect(result, tPosts);
    });
  });
}
