import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:clay_rigging_bridle/widgets/primary_button.dart';
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
    'Imperial Steels': [
      "1' Steel",
      "1'6\" Steel",
      "2' Steel",
      "2'6\" Steel",
      "3' Steel",
      "4' Steel",
      "5' Steel",
      "10' Steel",
      "15' Steel",
      "20' Steel",
      "30' Steel",
      "50' Steel",
      "60' Steel",
      "100' Steel",
    ],
    'Metric Steels': [
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
    'Imperial Baskets': [
      "2' Basket",
      "2'6\" Basket",
      "3' Basket",
      "5' Basket",
      "10' Basket",
      "15' Basket",
      "2' – 5' Split Basket",
      "5' – 10' Split Basket",
      "10' – 20' Split Basket",
    ],
    'Metric Baskets': [
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
    'Decks & Clutches': [
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

  // Keep track of On/Off for each item
  final Map<String, bool> _selected = {};

  @override
  void initState() {
    super.initState();
    // init all to false
    for (final items in _sections.values) {
      for (final item in items) {
        _selected[item] = false;
      }
    }
    // some example defaults
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primaryColor,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 40,
                      child: PrimaryButton(
                        borderColor: Colors.white,
                        backgroundColor: AppColors.white,
                        textStyle: AppTextStyle.titleSmall
                            .copyWith(
                              color: AppColors.primaryColor,
                            ),
                        title: "Done",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),

                    Text(
                      'Rigging Bridle Measurement',
                      style: AppTextStyle.titleSmall
                          .copyWith(color: AppColors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    _sections.keys.length +
                    _totalItemCount(),
                itemBuilder: _itemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _totalItemCount() => _sections.values.fold(
    0,
    (sum, list) => sum + list.length,
  );

  Widget _itemBuilder(BuildContext context, int index) {
    var running = 0;
    for (final entry in _sections.entries) {
      // header
      if (index == running) {
        return _buildSectionHeader(entry.key);
      }
      running++;
      // items
      if (index < running + entry.value.length) {
        final label = entry.value[index - running];
        return _buildListItem(label);
      }
      running += entry.value.length;
    }
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildListItem(String label) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyle.bodyMedium,
                ),
              ),
              // two separate pills
              _buildToggleButton(label, true), // On
              const SizedBox(width: 12),
              _buildToggleButton(label, false), // Off
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool turnOn) {
    final selected = (_selected[label] == turnOn);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected[label] = turnOn;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppColors.primaryColor
                  : AppColors.white,
          border: Border.all(
            color:
                selected ? AppColors.white : Colors.black,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          turnOn ? 'On' : 'Off',
          style: AppTextStyle.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color:
                selected
                    ? AppColors.white
                    : AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
