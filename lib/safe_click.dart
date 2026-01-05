library safe_click;

import 'dart:async';
import 'package:flutter/material.dart';

/// A widget that prevents rapid multiple taps on its child widget.
///
/// Wrap any widget with [SafeClick] to ensure that taps are only
/// registered once per [cooldown] period.
///
/// Example usage:
/// ```dart
/// SafeClick(
///   cooldown: Duration(seconds: 2),
///   onTap: () {
///     print("Clicked safely!");
///   },
///   child: ElevatedButton(
///     onPressed: () {},
///     child: Text("Click Me"),
///   ),
/// )
/// ```
class SafeClick extends StatefulWidget {
  /// The widget you want to make safe-clickable.
  ///
  /// Example: Container, ElevatedButton, IconButton, etc.
  final Widget child;

  /// Callback function executed when the widget is tapped.
  ///
  /// Will only be called if the cooldown period has passed.
  final VoidCallback onTap;

  /// Duration to block repeated taps. Defaults to 1 second.
  final Duration cooldown;

  /// Creates a SafeClick widget.
  ///
  /// [child] and [onTap] are required.
  /// Optionally, specify a [cooldown] duration.
  const SafeClick({
    Key? key,
    required this.child,
    required this.onTap,
    this.cooldown = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  _SafeClickState createState() => _SafeClickState();
}

class _SafeClickState extends State<SafeClick> {
  /// Internal flag to track if the widget is currently in cooldown.
  bool _isCooldown = false;

  /// Timer used for the cooldown.
  ///
  /// This is stored so it can be canceled when the widget is disposed,
  /// preventing memory leaks and test errors.
  Timer? _cooldownTimer;

  /// Handles tap events on the child widget.
  ///
  /// If [_isCooldown] is true, the tap is ignored.
  /// Otherwise, executes [widget.onTap] and starts the cooldown timer.
  void _handleTap() {
    if (_isCooldown) return;

    // Trigger the tap callback
    widget.onTap();

    // Start cooldown
    setState(() => _isCooldown = true);

    _cooldownTimer = Timer(widget.cooldown, () {
      if (mounted) {
        setState(() => _isCooldown = false);
      }
    });
  }

  @override
  void dispose() {
    // Cancel any active timer to prevent memory leaks or test issues
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}
