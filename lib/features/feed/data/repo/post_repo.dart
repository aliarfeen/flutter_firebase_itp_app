import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_itp_app/core/data/model/app_user.dart';
import 'package:flutter_firebase_itp_app/features/feed/data/models/post.dart';

class PostRepo {
  PostRepo._();

  static final PostRepo instance = PostRepo._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Post?>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').get();
      return querySnapshot.docs.map((doc) {
        if (doc.exists) {
          print(doc.data().runtimeType); // Map<String, dynamic>
          Map<String, dynamic> postJson = Map.from(
            doc.data() as Map<String, dynamic>,
          );
          return Post.fromJson(postJson);
        }
        return null;
      }).toList();
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<bool> addPost(Post post) async {
    try {
      await _firestore.collection('posts').add(post.toJson());
      return true;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getComments(String id) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .doc(id)
          .collection('comments')
          .get();

      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['text'] as String? ?? '';
          })
          .where((comment) => comment.isNotEmpty)
          .toList();
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<bool> addComment(String id, String comment) async {
    try {
      await _firestore
          .collection('posts')
          .doc(id)
          .collection('comments')
          .add({'text': comment});
      return true;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
  
  Stream<List<Post?>> watchPosts() {
    return _firestore.collection('posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (!doc.exists) return null;
        final data = doc.data() as Map<String, dynamic>;
        return Post.fromJson(data);
      }).toList();
    });
  }
}
