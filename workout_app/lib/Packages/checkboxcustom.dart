//Code found on https://kotlincodes.com/flutter-dart/custom-checkbox-flutter/

import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final Function onChange;
  final bool isChecked;
  final double width;
  final double height;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color borderColor;

  CustomCheckbox(
      {required this.isChecked,
        required this.onChange,
        required this.width,
        required this.height,
        required this.iconSize,
        required this.selectedColor,
        required this.selectedIconColor,
        required this.borderColor,
        });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            widget.onChange(_isSelected);
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
              color: _isSelected
                  ? widget.selectedColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: widget.borderColor,
                width: 1,
              )),
          width: widget.width,
          height: widget.height,
          child: _isSelected
              ? Icon(
            Icons.check,
            color: widget.selectedIconColor,
            size: widget.iconSize,
          )
              : null,
        ),
      ),
    );
  }
}