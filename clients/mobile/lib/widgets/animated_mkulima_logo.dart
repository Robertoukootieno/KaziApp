import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'mkulima_connect_logo.dart';

/// Animated version of the Mkulima Connect logo with professional animations
class AnimatedMkulimaLogo extends StatefulWidget {
  final double? width;
  final double? height;
  final bool showText;
  final Color? textColor;
  final double? fontSize;
  final bool isHorizontal;
  final bool showTagline;
  final String? tagline;
  final bool enablePulse;
  final bool enableRotation;
  final bool enableGlow;
  final Duration animationDuration;
  final bool autoStart;

  const AnimatedMkulimaLogo({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.textColor,
    this.fontSize,
    this.isHorizontal = false,
    this.showTagline = false,
    this.tagline,
    this.enablePulse = true,
    this.enableRotation = false,
    this.enableGlow = true,
    this.animationDuration = const Duration(seconds: 2),
    this.autoStart = true,
  });

  @override
  State<AnimatedMkulimaLogo> createState() => _AnimatedMkulimaLogoState();
}

class _AnimatedMkulimaLogoState extends State<AnimatedMkulimaLogo>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: (widget.animationDuration.inMilliseconds * 0.8).round()),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: (widget.animationDuration.inMilliseconds * 0.6).round()),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: Duration(milliseconds: (widget.animationDuration.inMilliseconds * 1.2).round()),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initialize animations
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _rotateAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeOutBack,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.autoStart) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    // Start animations in sequence for a professional effect
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _rotateController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _scaleController.forward();
    
    // Start subtle pulse animation after main animation completes (only if enabled)
    if (widget.enablePulse) {
      await Future.delayed(Duration(milliseconds: widget.animationDuration.inMilliseconds));
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _fadeAnimation,
        _slideAnimation,
        _rotateAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value * _pulseAnimation.value,
                child: MkulimaConnectLogo(
                  width: widget.width,
                  height: widget.height,
                  showText: widget.showText,
                  textColor: widget.textColor,
                  fontSize: widget.fontSize,
                  isHorizontal: widget.isHorizontal,
                  showTagline: widget.showTagline,
                  tagline: widget.tagline,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfessionalLoadingAnimation extends StatefulWidget {
  final String? loadingText;
  final Color? textColor;
  final Color? primaryColor;
  final double? logoSize;

  const ProfessionalLoadingAnimation({
    super.key,
    this.loadingText,
    this.textColor,
    this.primaryColor,
    this.logoSize,
  });

  @override
  State<ProfessionalLoadingAnimation> createState() => _ProfessionalLoadingAnimationState();
}

class _ProfessionalLoadingAnimationState extends State<ProfessionalLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _shimmerController;
  late Animation<double> _progressAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? const Color(0xFF2E7D32);
    final textColor = widget.textColor ?? Colors.white;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated logo
        AnimatedMkulimaLogo(
          width: widget.logoSize ?? 80,
          height: widget.logoSize ?? 80,
          showText: false,
          animationDuration: const Duration(milliseconds: 1500),
        ),
        
        const SizedBox(height: 32),
        
        // Loading text with shimmer effect
        if (widget.loadingText != null)
          AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      textColor.withValues(alpha: 0.5),
                      textColor,
                      textColor.withValues(alpha: 0.5),
                    ],
                    stops: [
                      (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                      _shimmerAnimation.value.clamp(0.0, 1.0),
                      (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  widget.loadingText!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              );
            },
          ),
        
        const SizedBox(height: 24),
        
        // Animated progress bar
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withValues(alpha: 0.7),
                        primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
