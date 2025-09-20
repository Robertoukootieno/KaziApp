import 'package:flutter/material.dart';

/// Custom graphics and illustrations for farmer-focused UI
class FarmerGraphics {
  
  /// Creates a farmer avatar icon with customizable colors
  static Widget farmerAvatar({
    double size = 60,
    Color backgroundColor = const Color(0xFFFFB74D),
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.person,
        color: iconColor,
        size: size * 0.5,
      ),
    );
  }

  /// Creates a veterinary/expert icon
  static Widget veterinaryIcon({
    double size = 60,
    Color backgroundColor = const Color(0xFF42A5F5),
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.medical_services,
        color: iconColor,
        size: size * 0.5,
      ),
    );
  }

  /// Creates a tractor/machinery icon
  static Widget machineryIcon({
    double size = 40,
    Color backgroundColor = const Color(0xFFFF7043),
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(
        Icons.agriculture,
        color: iconColor,
        size: size * 0.5,
      ),
    );
  }

  /// Creates a crop/plant icon
  static Widget cropIcon({
    double size = 40,
    Color backgroundColor = const Color(0xFF66BB6A),
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(
        Icons.eco,
        color: iconColor,
        size: size * 0.5,
      ),
    );
  }

  /// Creates an animated connection line between two points
  static Widget connectionLine({
    double width = 40,
    double height = 2,
    Color color = Colors.white,
    double opacity = 0.6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  /// Creates a farm scene illustration
  static Widget farmScene({
    double width = 200,
    double height = 150,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB), // Sky blue
            Color(0xFF98FB98), // Pale green
          ],
        ),
      ),
      child: Stack(
        children: [
          // Sun
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Mountains/Hills
          Positioned(
            bottom: height * 0.3,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.2,
              decoration: const BoxDecoration(
                color: Color(0xFF8FBC8F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          
          // Ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.3,
              decoration: const BoxDecoration(
                color: Color(0xFF8B4513),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          
          // Crops
          Positioned(
            bottom: height * 0.25,
            left: width * 0.2,
            child: Container(
              width: 8,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF228B22),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: height * 0.25,
            left: width * 0.4,
            child: Container(
              width: 8,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFF228B22),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: height * 0.25,
            left: width * 0.6,
            child: Container(
              width: 8,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF228B22),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a consultation illustration
  static Widget consultationScene({
    double width = 180,
    double height = 120,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFBBDEFB),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Farmer figure
          Positioned(
            left: width * 0.15,
            bottom: height * 0.2,
            child: Column(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB74D),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 20,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8BC34A),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          
          // Expert figure
          Positioned(
            right: width * 0.15,
            bottom: height * 0.2,
            child: Column(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Color(0xFF42A5F5),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 20,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          
          // Speech bubbles
          Positioned(
            top: height * 0.15,
            left: width * 0.05,
            child: Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          
          Positioned(
            top: height * 0.25,
            right: width * 0.05,
            child: Container(
              width: 35,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
