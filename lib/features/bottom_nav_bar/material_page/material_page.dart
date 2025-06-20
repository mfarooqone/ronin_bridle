import 'package:flutter/widgets.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);
  @override
  State<MaterialScreen> createState() =>
      _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            "assets/images/material_page.png",
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
