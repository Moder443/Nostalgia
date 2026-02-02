import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';

class TimeTravelLoader extends ConsumerStatefulWidget {
  const TimeTravelLoader({super.key});

  @override
  ConsumerState<TimeTravelLoader> createState() => _TimeTravelLoaderState();
}

class _TimeTravelLoaderState extends ConsumerState<TimeTravelLoader>
    with TickerProviderStateMixin {
  int _currentStage = 0;
  late Timer _stageTimer;
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  List<_LoadingStage> _getStages(AppStrings strings) => [
    _LoadingStage(
      text: strings.launchingTimeMachine,
      icon: Icons.rocket_launch_rounded,
    ),
    _LoadingStage(
      text: strings.goingToPast,
      icon: Icons.access_time_filled_rounded,
    ),
    _LoadingStage(
      text: strings.searchingMemories,
      icon: Icons.search_rounded,
    ),
    _LoadingStage(
      text: strings.foundSomethingWarm,
      icon: Icons.favorite_rounded,
    ),
    _LoadingStage(
      text: strings.pickingMusic,
      icon: Icons.music_note_rounded,
    ),
    _LoadingStage(
      text: strings.creatingAtmosphere,
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _startStageAnimation();
  }

  void _startStageAnimation() {
    _stageTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted) {
        setState(() {
          _currentStage = (_currentStage + 1) % 6;
        });
      }
    });
  }

  @override
  void dispose() {
    _stageTimer.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final stages = _getStages(strings);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated portal/time machine effect
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * pi,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      gradient: SweepGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.0),
                          AppColors.primary.withValues(alpha: 0.5),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Middle pulsing ring
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.9 + (_pulseController.value * 0.15),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(
                              alpha: 0.2 + (_pulseController.value * 0.3),
                            ),
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Inner glow
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: 0.2 + (_pulseController.value * 0.2),
                            ),
                            blurRadius: 30 + (_pulseController.value * 20),
                            spreadRadius: 5,
                          ),
                        ],
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.3),
                            AppColors.primary.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Center icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    stages[_currentStage].icon,
                    key: ValueKey(_currentStage),
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Stage text with animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              stages[_currentStage].text,
              key: ValueKey('${_currentStage}_${strings.locale}'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Animated dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: _AnimatedDot(delay: index * 200),
              );
            }),
          ),

        ],
      ),
    );
  }
}

class _LoadingStage {
  final String text;
  final IconData icon;

  _LoadingStage({
    required this.text,
    required this.icon,
  });
}

class _AnimatedDot extends StatefulWidget {
  final int delay;

  const _AnimatedDot({required this.delay});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -6 * _controller.value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.5 + (_controller.value * 0.5),
              ),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
