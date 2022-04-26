import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Opportunity extends Equatable {
  final String? name;
  final String? photoUrl;
  final String description;
  final String? link;
  final String? opportunityId;

  const Opportunity({
    this.name,
    this.photoUrl,
    required this.description,
    this.link,
    this.opportunityId,
  });

  Opportunity copyWith({
    String? name,
    String? photoUrl,
    String? description,
    String? link,
    String? opportunityId,
  }) {
    return Opportunity(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      link: link ?? this.link,
      opportunityId: opportunityId ?? this.opportunityId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'description': description,
      'link': link,
      'opportunityId': opportunityId,
    };
  }

  factory Opportunity.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map?;
    return Opportunity(
      name: data?['name'],
      photoUrl: data?['photoUrl'],
      description: data?['description'] ?? '',
      link: data?['link'],
      opportunityId: doc.id,
    );
  }

  @override
  String toString() {
    return 'Opportunity(name: $name, photoUrl: $photoUrl, description: $description, link: $link)';
  }

  @override
  List<Object?> get props => [name, photoUrl, description, link];
}
