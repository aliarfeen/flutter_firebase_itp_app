import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_button_style.dart';
import 'package:flutter_firebase_itp_app/features/feed/cubit/posts_cubit.dart';
import 'package:flutter_firebase_itp_app/features/feed/data/models/post.dart';
import 'package:flutter_firebase_itp_app/features/feed/post_details_page.dart';
import 'package:flutter_firebase_itp_app/features/profile/cubit/profile_cubit.dart';

class FeedPage extends StatelessWidget {
  final TextEditingController _postController = TextEditingController();
  FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is PostsLoading) {
          context.read<ProfileCubit>().getCurrentUser();
          context.read<ProfileCubit>().getUserName();

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
                              //userName: context.read<ProfileCubit>().userName,
                              userName: 'Ali Hesham',
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
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
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
