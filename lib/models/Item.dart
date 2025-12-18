import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String title;
  final int timestamp;
  final String description;
  final String id;
  final String imageUrl;
  const Item({
    required this.title,
    required this.timestamp,
    required this.description,
    required this.id,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [title, timestamp, description, id];

  // Convert Item to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'timestamp': timestamp,
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  // Create Item from Map
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      title: map['title'],
      timestamp: map['timestamp'],
      description: map['description'],
      id: map['id'],
      imageUrl: map['imageUrl'],
    );
  }
}
