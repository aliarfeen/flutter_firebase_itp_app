import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_itp_app/features/feed/data/models/post.dart';
import 'package:flutter_firebase_itp_app/features/feed/data/repo/post_repo.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  Future<void> getPosts() async {
    emit(PostsLoading());
    try {
      List<Post?> posts = await PostRepo.instance.getPosts();
      emit(PostsLoaded(posts));
    } on FirebaseException catch (e) {
      emit(PostsFailure(e.message ?? 'Failed to load posts'));
    }
  }

  Future<void> addPost(Post post) async {
    emit(PostsLoading());
    try {
      bool postAdded = await PostRepo.instance.addPost(post);
      if (postAdded) {
        getPosts();
      }
    } catch (e) {
      emit(PostsFailure(e.toString()));
    }
  }

  Future<void> getComments(String id) async {
    emit(PostsLoading());
    try {
      List<String> comments = await PostRepo.instance.getComments(id);
      emit(PostsCommentsLoaded(comments));
    } on FirebaseException catch (e) {
      emit(PostsCommentsFailure(e.message ?? 'Failed to load comments'));
    }
  }

  Future<void> addComment(String id, String comment) async {
    emit(PostsLoading());
    try {
      bool commentAdded = await PostRepo.instance.addComment(id, comment);
      if (commentAdded) {
        getComments(id);
      }
    } catch (e) {
      emit(PostsCommentsFailure(e.toString()));
    }
  }

  StreamSubscription<List<Post?>>? _postsSub;

  void subscribeToPosts() {
    _postsSub?.cancel(); // avoid double subscription

    _postsSub = PostRepo.instance.watchPosts().listen(
      (posts) {
        emit(PostsLoaded(posts));
      },
      onError: (error) {
        emit(PostsFailure(error.toString()));
      },
    );
  }

  //override close method to cancel subscription
  @override 
  Future<void> close() {
    _postsSub?.cancel();
    return super.close();
  }
}
