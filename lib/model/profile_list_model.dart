import 'dart:ui';

class SectionItem {
  final String title;
  final bool? opened;
  final List<CardItem> array;
  SectionItem({required this.title, this.opened, required this.array});
}

class CardItem {
  final String title;
  final String subtitle;
  final String image;
  final Color color;
  CardItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.color,
  });
}
