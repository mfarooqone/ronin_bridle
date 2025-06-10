import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  _MeasurementPageState createState() =>
      _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  // controllers for your 6 fields (you can expand to all fields you need)
  final _leftLegController = TextEditingController();
  final _beamDistController = TextEditingController();
  final _rightLegController = TextEditingController();

  // picker state
  int _leftLeg = 16, _beamDist = 2, _rightLeg = 2;

  Future<void> _showPicker(
    TextEditingController target,
  ) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildCupertinoColumn(
                      values: List.generate(
                        20,
                        (i) => (i + 10).toString(),
                      ),
                      current: _leftLeg.toString(),
                      onSelected:
                          (v) => setState(
                            () => _leftLeg = int.parse(v),
                          ),
                    ),
                    _buildCupertinoColumn(
                      values: List.generate(
                        10,
                        (i) => i.toString(),
                      ),
                      current: _beamDist.toString(),
                      onSelected:
                          (v) => setState(
                            () => _beamDist = int.parse(v),
                          ),
                    ),
                    _buildCupertinoColumn(
                      values: List.generate(
                        10,
                        (i) => i.toString(),
                      ),
                      current: _rightLeg.toString(),
                      onSelected:
                          (v) => setState(
                            () => _rightLeg = int.parse(v),
                          ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // assign to whichever field opened the picker
                      if (target == _leftLegController) {
                        target.text = '$_leftLeg';
                      } else if (target ==
                          _beamDistController) {
                        target.text = '$_beamDist';
                      } else if (target ==
                          _rightLegController) {
                        target.text = '$_rightLeg';
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCupertinoColumn({
    required List<String> values,
    required String current,
    required ValueChanged<String> onSelected,
  }) {
    final currentIndex = values
        .indexOf(current)
        .clamp(0, values.length - 1);
    return Expanded(
      child: CupertinoPicker.builder(
        scrollController: FixedExtentScrollController(
          initialItem: currentIndex,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (i) => onSelected(values[i]),
        childCount: values.length,
        itemBuilder:
            (_, i) => Center(child: Text(values[i])),
      ),
    );
  }

  @override
  void dispose() {
    _leftLegController.dispose();
    _beamDistController.dispose();
    _rightLegController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridle Apex'),
        leading: BackButton(color: Colors.black54),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // background diagram
          Positioned.fill(
            child: Image.asset(
              'assets/diagram.png',
              fit: BoxFit.contain,
            ),
          ),
          // overlay form fields
          ...[
            // left leg field
            Positioned(
              left: 40,
              top: 200,
              width: 80,
              child: _buildField(_leftLegController),
            ),
            // beam distance
            Positioned(
              left:
                  MediaQuery.of(context).size.width / 2 -
                  40,
              top: 150,
              width: 80,
              child: _buildField(_beamDistController),
            ),
            // right leg field
            Positioned(
              right: 40,
              top: 200,
              width: 80,
              child: _buildField(_rightLegController),
            ),
            // add more Positioned(...) for each measurement box...
          ].expand((w) => [w]).toList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Measurement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Weights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
        ],
        currentIndex: 0,
        onTap: (_) {},
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onTap: () => _showPicker(ctrl),
    );
  }
}
