import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'Item.g.dart';

@HiveType(typeId: 0) // Choose a unique typeId (0-223)
class Item extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String id;

  @HiveField(3)
  final String imageUrl;

  Item({
    required this.title,
    required this.description,
    required this.id,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [title, description, id, imageUrl];

  @override
  String toString() {
    return 'Item{title: $title, id: $id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
