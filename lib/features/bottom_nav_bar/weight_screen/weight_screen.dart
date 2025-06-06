import 'package:flutter/widgets.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);
  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Weight Screen"));
  }
}
