import 'package:flutter/material.dart';

class UsageRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final double? gap;

  const UsageRow({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.gap = 10,
  });

  @override
  Widget build(BuildContext context) {
    const defaultLabelStyle = TextStyle(
      fontSize: 13.0,
      color: Color(0xff6C6C6C),
      fontWeight: FontWeight.normal,
    );

    const defaultValueStyle = TextStyle(
      fontSize: 13.0,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: labelStyle ?? defaultLabelStyle,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: valueStyle ?? defaultValueStyle,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            height: gap,
          )
        ],
      ),
    );
  }
}
