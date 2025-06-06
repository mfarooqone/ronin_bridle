import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvailableHardwareScreen extends StatefulWidget {
  const AvailableHardwareScreen({Key? key})
    : super(key: key);

  @override
  State<AvailableHardwareScreen> createState() =>
      _AvailableHardwareScreenState();
}

class _AvailableHardwareScreenState
    extends State<AvailableHardwareScreen> {
  // Sample data grouped by section
  final Map<String, List<String>> _sections = {
    '1 – IMPERIAL STEELS': [
      "1' Steel",
      "2' Steel",
      "2'6\" Steel",
      "3' Steel",
      "4' Steel",
      "5' Steel",
      "10' Steel",
      "15' Steel",
      "20' Steel",
      "30' Steel",
      "40' Steel",
      "50' Steel",
      "60' Steel",
      "100' Steel",
    ],
    '2 – METRIC STEELS': [
      "0,25 m Steel",
      "0,5 m Steel",
      "0,75 m Steel",
      "1 m Steel",
      "1,5 m Steel",
      "2 m Steel",
      "2,5 m Steel",
      "3 m Steel",
      "4 m Steel",
      "5 m Steel",
      "6 m Steel",
      "7 m Steel",
      "8 m Steel",
      "9 m Steel",
      "10 m Steel",
      "15 m Steel",
      "20 m Steel",
      "30 m Steel",
    ],
    '3 – IMPERIAL BASKETS': [
      "2' Basket",
      "2'6\" Basket",
      "3' Basket",
      "5' Basket",
      "10' Basket",
      "15' Basket",
      "20' Basket",
      "30' Basket",
      "50' Basket",
      "60' Basket",
      "100' Basket",
      "2' – 5' Split Basket",
      "5' – 10' Split Basket",
      "10' – 20' Split Basket",
    ],
    '4 – METRIC BASKETS': [
      "0,5 m Basket",
      "0,75 m Basket",
      "1 m Basket",
      "1,5 m Basket",
      "2 m Basket",
      "3 m Basket",
      "4 m Basket",
      "5 m Basket",
      "6 m Basket",
      "7 m Basket",
      "8 m Basket",
      "9 m Basket",
      "10 m Basket",
      "20 m Basket",
    ],
    '5 – DECKS & CLUTCHES': [
      "3' Deck 3\" links",
      "4' Deck 3\" links",
      "5' Deck 3\" links",
      "6' Deck 3\" links",
      "3' Deck 4\" links",
      "4' Deck 4\" links",
      "5' Deck 4\" links",
      "6' Deck 4\" links",
      "1 m Chain Clutch",
      "1,5 m Chain Clutch",
      "2 m Chain Clutch",
      "3 m Chain Clutch",
    ],
  };

  // Keep track of switch states:
  final Map<String, bool> _selected = {};

  @override
  void initState() {
    super.initState();
    // Initialize all switches to false
    for (final section in _sections.values) {
      for (final item in section) {
        _selected[item] = false;
      }
    }
    // Example pre-selected items to match screenshots:
    _selected["3 m Basket"] = true;
    _selected["1,5 m Basket"] = true;
    _selected["4' Deck 4\" links"] = true;
    _selected["1 m Steel"] = true;
    _selected["1,5 m Steel"] = true;
    _selected["2 m Steel"] = true;
    _selected["3 m Steel"] = true;
    _selected["6 m Steel"] = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Hardware'),
        centerTitle: true,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            'Done',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    _sections.keys.length +
                    _totalItemCount(),
                itemBuilder: (context, index) {
                  // Flattened index logic: find if this index is a section header or an item
                  var runningIndex = 0;
                  for (final sectionTitle
                      in _sections.keys) {
                    // Section header
                    if (index == runningIndex) {
                      return _buildSectionHeader(
                        sectionTitle,
                        width,
                      );
                    }
                    runningIndex++;

                    // Section items
                    final items = _sections[sectionTitle]!;
                    if (index <
                        runningIndex + items.length) {
                      final itemLabel =
                          items[index - runningIndex];
                      return _buildListItem(itemLabel);
                    }
                    runningIndex += items.length;
                  }
                  return const SizedBox.shrink();
                },
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Text(
                  "Only one selection is allowed, from Deck Chains and Clutches!",
                  style: AppTextStyle.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _totalItemCount() {
    // Total sections + total number of items
    var count = 0;
    for (final items in _sections.values) {
      count += items.length;
    }
    return _sections.keys.length + count;
  }

  Widget _buildSectionHeader(String title, double width) {
    return Container(
      width: width,
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListItem(String label) {
    return Column(
      children: [
        ListTile(
          title: Text(label),
          trailing: CupertinoSwitch(
            value: _selected[label]!,
            onChanged: (bool value) {
              setState(() {
                _selected[label] = value;
              });
            },
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
