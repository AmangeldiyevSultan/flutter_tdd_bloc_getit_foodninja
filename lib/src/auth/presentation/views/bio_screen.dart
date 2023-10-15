import 'package:flutter/material.dart';
import 'package:flutter_foodninja_bloc_tdd_clean_arc/src/auth/presentation/widgets/body_template.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  static const String routeName = '/bio-screen';

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: 'Fill in your bio to get\n started',
      subtitle:
          'This data will be displayed in your accound profile for security',
      onPressed: () {},
      childs: const [],
      child: Container(),
    );
  }
}
