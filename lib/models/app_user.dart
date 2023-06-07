import 'package:etrick/models/purchase.dart';

class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? photoUrl;
  final List<Purchase>? purchases;

  AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.photoUrl,
    this.purchases,
  });

  @override
  String toString() {
    return 'AppUser{id: $id, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, photoUrl: $photoUrl, purchases: $purchases}';
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? photoUrl,
    List<Purchase>? purchases,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      purchases: purchases ?? this.purchases,
    );
  }

  factory AppUser.empty() {
    return AppUser(
      id: '',
      email: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
      photoUrl: '',
      purchases: [],
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      purchases: List<Purchase>.from(
          map['purchases']?.map((x) => Purchase.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'purchases': purchases?.map((x) => x.toMap()).toList(),
    };
  } 
}
