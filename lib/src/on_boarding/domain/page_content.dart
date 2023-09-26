// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  const PageContent.first() : this(
    image: MediaRes.illustrationOnboarding_1,
    title: 'Find your Comfort\nFood here',
    description: 'Here You Can find a chef or dish for every '
    'taste and color. Enjoy!',
  );

  const PageContent.second() : this(
    image: MediaRes.illustrationOnboarding_2,
    title: 'Food Ninja is Where Your ' 
    'Comfort Food Lives',
    description: 'Enjoy a fast and good food delivery at '
    'your doorstep', 
  );

  @override
  List<Object?> get props => [image, title, description];
}
