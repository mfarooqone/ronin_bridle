import 'package:flutter/widgets.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);
  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Measurement Page"));
  }
}
