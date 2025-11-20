import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/features/feed/cubit/posts_cubit.dart';
import 'package:flutter_firebase_itp_app/features/feed/data/models/post.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key, required this.post});

  final Post post;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostsCubit>().getComments(widget.post.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    context.read<PostsCubit>().addComment(widget.post.id, text);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PostsCubit>().state;

    List<String> comments = [];
    if (state is PostsCommentsLoaded) {
      comments = state.comments;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.post.userName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,

                  child: Text(
                    widget.post.content,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.start,
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: comments.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  leading: const Icon(Icons.comment),
                  title: Text(comment),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
