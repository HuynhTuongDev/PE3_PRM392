import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pe3/providers/post_provider.dart';
import 'package:pe3/models/post.dart';
import 'package:pe3/screens/home_screen.dart';
import 'package:pe3/screens/detail_screen.dart';

class MockPostProvider extends Mock implements PostProvider {
  @override
  List<Post> get posts => super.noSuchMethod(
        Invocation.getter(#posts),
        returnValue: <Post>[],
        returnValueForMissingStub: <Post>[],
      );
  
  @override
  bool get isLoading => super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: false,
        returnValueForMissingStub: false,
      );

  @override
  bool get hasNextPage => super.noSuchMethod(
        Invocation.getter(#hasNextPage),
        returnValue: false,
        returnValueForMissingStub: false,
      );

  @override
  List<Post> get favorites => super.noSuchMethod(
        Invocation.getter(#favorites),
        returnValue: <Post>[],
        returnValueForMissingStub: <Post>[],
      );

  @override
  String get searchQuery => super.noSuchMethod(
        Invocation.getter(#searchQuery),
        returnValue: '',
        returnValueForMissingStub: '',
      );

  @override
  Future<void> fetchPosts({bool isRefresh = false}) => super.noSuchMethod(
        Invocation.method(#fetchPosts, [], {#isRefresh: isRefresh}),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );

  @override
  void addListener(VoidCallback listener) {}
  
  @override
  void removeListener(VoidCallback listener) {}
}

void main() {
  late MockPostProvider mockPostProvider;

  setUp(() {
    mockPostProvider = MockPostProvider();
  });

  group('Navigation Tests', () {
    final tPosts = [
      Post(id: 1, userId: 1, title: 'Test Post Title', body: 'Test Post Body'),
    ];

    testWidgets('should navigate to DetailScreen when a NewsCard is tapped', (tester) async {
      // Set surface size
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      when(mockPostProvider.posts).thenReturn(tPosts);
      when(mockPostProvider.isLoading).thenReturn(false);
      when(mockPostProvider.hasNextPage).thenReturn(false);
      when(mockPostProvider.favorites).thenReturn([]);
      when(mockPostProvider.searchQuery).thenReturn('');

      await tester.pumpWidget(
        ChangeNotifierProvider<PostProvider>.value(
          value: mockPostProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Tap title instead of button to avoid scroll issues
      await tester.tap(find.text('Test Post Title'));
      await tester.pumpAndSettle();

      expect(find.byType(DetailScreen), findsOneWidget);
    });
  });
}
