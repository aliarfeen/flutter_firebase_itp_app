import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_button_style.dart';
import 'package:flutter_firebase_itp_app/features/feed/cubit/posts_cubit.dart';
import 'package:flutter_firebase_itp_app/features/feed/data/models/post.dart';
import 'package:flutter_firebase_itp_app/features/feed/post_details_page.dart';

class FeedPage extends StatelessWidget {
  final TextEditingController _postController = TextEditingController();
  FeedPage({super.key});

  // final List<Post> _posts = [
  //   Post(
  //     id: '1',
  //     content: 'This is a mock post to show how the feed works.',
  //     userName: 'Admin',
  //     comments: [],
  //   ),
  //   Post(
  //     id: '2',
  //     content: 'Here is another example post with some content.',
  //     userName: 'User 123',
  //     comments: [],
  //   ),
  //   Post(
  //     id: '3',
  //     content: 'Building apps with Flutter and Firebase is fun!',
  //     userName: 'Flutter Dev',
  //     comments: [],
  //   ),
  // ];

  // @override
  // void dispose() {
  //   _postController.dispose();
  //   super.dispose();
  // }

  // void _addPost() {
  //   final text = _postController.text.trim();
  //   if (text.isEmpty) return;
  //   setState(() {
  //     _posts.insert(
  //       0,
  //       Post(
  //         id: DateTime.now().millisecondsSinceEpoch.toString(),
  //         content: text,
  //         userName: 'You',
  //         comments: [],
  //       ),
  //     );
  //     _postController.clear();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is PostsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostsFailure) {
          return Center(child: Text(state.errorMessage));
        }
        List<Post?> posts = [];

        if (state is PostsLoaded) {
          posts = state.posts;
        } else if (state is PostsInitial) {
          posts = state.posts;
        }
        List<Post> _posts = posts.whereType<Post>().toList();
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _postController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Write a new post...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => context.read<PostsCubit>().addPost(
                            Post(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              content: _postController.text.trim(),
                              userName: 'You',
                              comments: [],
                            ),
                          ),
                          style: AppButtonStyle.primaryButtonStyle,
                          child: const Text('Post'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Card(
                        child: ListTile(
                          title: Text(post.userName),
                          subtitle: Text(
                            post.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => PostsCubit(),
                                  child: PostDetailsPage(post: post),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
