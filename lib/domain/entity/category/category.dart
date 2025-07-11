import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String label;

  const Category({
    required this.id,
    required this.name,
    required this.label,
  });

  @override
  List<Object?> get props => [id, name, label];
}
