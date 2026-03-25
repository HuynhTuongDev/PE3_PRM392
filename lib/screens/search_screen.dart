import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/post_provider.dart';
import '../core/constants/app_colors.dart';
import '../widgets/news_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Explore News',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) =>
                    context.read<PostProvider>().search(value),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Type to search...',
                  hintStyle: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant.withOpacity(0.6)),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, provider, child) {
                final posts = provider.searchQuery.isEmpty
                    ? []
                    : provider.posts
                        .where((p) => p.title
                            .toLowerCase()
                            .contains(provider.searchQuery.toLowerCase()))
                        .toList();

                if (provider.searchQuery.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search,
                            size: 100, color: AppColors.surfaceContainer),
                        const SizedBox(height: 16),
                        Text('Looking for something?',
                            style: GoogleFonts.plusJakartaSans(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sentiment_dissatisfied,
                            size: 100, color: AppColors.surfaceContainer),
                        const SizedBox(height: 16),
                        Text('No results found for "${provider.searchQuery}"',
                            style: GoogleFonts.plusJakartaSans(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return NewsCard(
                      post: post,
                      onToggleFavorite: () => provider.toggleFavorite(post),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(post: post),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
