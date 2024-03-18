import 'package:flutter/material.dart';

void main() {
  runApp(const CustomDropdown());
}

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _controller.text = 'Blue'; 
    _selectedOption = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dropdownItems = [
      'Blue',
      'Pink',
      'Green',
      'Orange',
      'Grey',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Community',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(10), 
          ),
          child: SingleChildScrollView(
            child: DropdownMenu<String>(
              width: 200,
              controller: _controller,
              onSelected: (String? option) {
                setState(() {
                  _selectedOption = option;
                });
              },
              dropdownMenuEntries: dropdownItems
                  .map<DropdownMenuEntry<String>>(
                    (item) => DropdownMenuEntry<String>(
                      value: item,
                      label: item,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
