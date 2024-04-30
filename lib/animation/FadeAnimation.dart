// ignore: file_names
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeIn extends StatelessWidget {
  const FadeIn({super.key, required this.delay, required this.child});

  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween('opacity', Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500))
      ..tween('translateY', Tween<double>(begin: -30.0, end: 0.0),
          duration: const Duration(milliseconds: 500), 
          curve: Curves.easeOut
          );
          
    return PlayAnimationBuilder<Movie>(
      delay: Duration(milliseconds: (500 * delay).round()),
      tween: tween,
      duration: tween.duration, // use duration from MovieTween
      builder: (context, value, _) {
        return Opacity(
          opacity: value.get('opacity'),
          child: Transform.translate(
            offset: Offset(0, value.get('translateY')),
            child: child
            ),
        );
      },
    );
  }
}
