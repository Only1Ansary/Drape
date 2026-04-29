import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText(this.text, {this.maxLines = 2, super.key});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(color: Colors.black38),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Text(
            isExpanded ? 'Read less' : 'Read more',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
