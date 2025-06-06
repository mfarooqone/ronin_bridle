import 'package:flutter/widgets.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);
  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Material Page"));
  }
}
