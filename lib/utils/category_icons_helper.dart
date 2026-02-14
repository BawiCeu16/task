import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class CategoryIconsHelper {
  static IconData getIconForCategory(String categoryName) {
    final name = categoryName.trim().toLowerCase();

    if (name.contains('work') ||
        name.contains('office') ||
        name.contains('job')) {
      return FlutterRemix.briefcase_line;
    }
    if (name.contains('personal') || name.contains('me')) {
      return FlutterRemix.user_line;
    }
    if (name.contains('home') || name.contains('house')) {
      return FlutterRemix.home_line;
    }
    if (name.contains('study') ||
        name.contains('school') ||
        name.contains('learn')) {
      return FlutterRemix.book_line;
    }
    if (name.contains('shop') ||
        name.contains('buy') ||
        name.contains('grocer')) {
      return FlutterRemix.shopping_cart_line;
    }
    if (name.contains('travel') ||
        name.contains('trip') ||
        name.contains('flight')) {
      return FlutterRemix.plane_line;
    }
    if (name.contains('music') || name.contains('song')) {
      return FlutterRemix.music_line;
    }
    if (name.contains('movie') ||
        name.contains('film') ||
        name.contains('cinema')) {
      return FlutterRemix.movie_line;
    }
    if (name.contains('gym') ||
        name.contains('fitness') ||
        name.contains('workout')) {
      return FlutterRemix.run_line; // Or dumbbell if available and preferred
    }
    if (name.contains('finance') ||
        name.contains('money') ||
        name.contains('bank')) {
      return FlutterRemix.money_dollar_circle_line;
    }
    if (name.contains('code') ||
        name.contains('dev') ||
        name.contains('program')) {
      return FlutterRemix.code_line;
    }
    if (name.contains('idea') || name.contains('project')) {
      return FlutterRemix.lightbulb_line;
    }

    // Default fallback
    return FlutterRemix.price_tag_line;
  }
}
