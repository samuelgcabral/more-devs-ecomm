import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/currency_format.dart';

class AnimatedPriceText extends StatefulWidget {
  const AnimatedPriceText({
    super.key,
    required this.value,
    this.style,
    this.maxLines,
    this.overflow,
    this.duration = const Duration(milliseconds: 400),
  });

  final double value;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final Duration duration;

  @override
  State<AnimatedPriceText> createState() => _AnimatedPriceTextState();
}

class _AnimatedPriceTextState extends State<AnimatedPriceText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _pulse;

  Color _pulseColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _pulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(AnimatedPriceText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _pulseColor = widget.value > oldWidget.value ? Colors.green : Colors.red;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? DefaultTextStyle.of(context).style;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final t = _pulse.value;
        return Transform.scale(
          scale: 1 + 0.3 * t,
          child: Text(
            widget.value.toBRL(),
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            style: baseStyle.copyWith(
              color: Color.lerp(
                baseStyle.color ?? Colors.black,
                _pulseColor,
                t,
              ),
            ),
          ),
        );
      },
    );
  }
}
