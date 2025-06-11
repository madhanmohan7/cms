import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/colors.dart';

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final TextStyle? textStyle;

  CustomTooltip({
    required this.child,
    required this.message,
    this.textStyle,
  });

  @override
  _CustomTooltipState createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + size.width + 8, // Position to the right
        top: offset.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: oBlack,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              widget.message,
              style: widget.textStyle ??  GoogleFonts.poppins(color: oWhite),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.child is IconButton ? (widget.child as IconButton).onPressed : null,
        onLongPress: () => _showOverlay(context),
        onLongPressEnd: (_) => _hideOverlay(),
        child: widget.child,
      ),
    );
  }
}
