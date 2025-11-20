import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String displayName;
  final String email;
  final String uid;
  final String? phone;
  final String? address;

  const AppUser({
    required this.displayName,
    required this.email,
    required this.uid,
    this.phone,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'uid': uid,
      'phone': phone,
      'address': address,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      displayName: json['displayName'],
      email: json['email'],
      uid: json['uid'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  @override
  List<Object?> get props => [uid, email];
}

/*
1- override operator == and hashCode
2- create copyWith method
3- use freezed package
4- use equatable package
 */
/*
Student s1 = Student();
Student s2 = Student();
if(s1 == s2) {}
 */