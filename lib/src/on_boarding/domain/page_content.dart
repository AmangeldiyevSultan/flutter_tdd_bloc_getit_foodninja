// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/core/res/media_res.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonState,
  });

  final String image;
  final String title;
  final String description;
  final String buttonState;

  const PageContent.first()
      : this(
          image: MediaRes.svgVectorIllustartionFirst,
          title: 'Find your Comfort\nFood here',
          description: 'Here You Can find a chef or dish for every\n'
              'taste and color. Enjoy!',
          buttonState: 'Next',
        );

  const PageContent.second()
      : this(
          image: MediaRes.svgVectorIllustartionSecond,
          title: 'Food Ninja is Where Your\n'
              'Comfort Food Lives',
          description: 'Enjoy a fast and good food delivery at\n'
              'your doorstep',
          buttonState: 'Get Started',
        );
  @override
  List<Object?> get props => [image, title, description];
}
