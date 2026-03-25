import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pe3/providers/post_provider.dart';
import 'package:pe3/repositories/post_repository.dart';
import 'package:pe3/models/post.dart';
import 'package:pe3/screens/home_screen.dart';
import 'package:pe3/widgets/news_card.dart';

class MockPostRepository extends Mock implements PostRepository {
  @override
  Future<List<Post>> fetchPosts(int page, {int limit = 10}) =>
      super.noSuchMethod(
        Invocation.method(#fetchPosts, [page], {#limit: limit}),
        returnValue: Future.value(<Post>[]),
        returnValueForMissingStub: Future.value(<Post>[]),
      );
  
  @override
  Future<void> toggleFavorite(Post post) => super.noSuchMethod(
        Invocation.method(#toggleFavorite, [post]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
}

void main() {
  late MockPostRepository mockPostRepository;
  late PostProvider postProvider;

  setUp(() {
    mockPostRepository = MockPostRepository();
    postProvider = PostProvider(repository: mockPostRepository);
  });

  group('HomeScreen Widget Tests', () {
    final tPosts = [
      Post(id: 1, userId: 1, title: 'Test Post Title', body: 'Test Post Body'),
    ];

    testWidgets('should display news posts when provider has data', (tester) async {
      when(mockPostRepository.fetchPosts(1)).thenAnswer((_) async => tPosts);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<PostProvider>(
            create: (_) => postProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Post Title'), findsWidgets);
      expect(find.byType(NewsCard), findsWidgets);
    });

    testWidgets('should display search results dynamically', (tester) async {
      when(mockPostRepository.fetchPosts(1)).thenAnswer((_) async => tPosts);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<PostProvider>(
            create: (_) => postProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pumpAndSettle();
      expect(find.text('Test Post Title'), findsWidgets);
    });
  });
}
