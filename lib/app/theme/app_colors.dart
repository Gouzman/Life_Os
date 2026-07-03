import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Fond très sombre (Bleu nuit profond / Noir)
  static const Color background = Color(0xFF0B0F19); 
  static const Color surface = Color(0xFF151B2B); // Cartes sombres
  static const Color surfaceHigh = Color(0xFF1E293B);
  static const Color card = Color(0xFF151B2B);
  static const Color border = Color(0xFF2A344A);

  // Bleu dominant
  static const Color primary = Color(0xFF2563EB); 
  static const Color primaryLight = Color(0xFF3B82F6); 
  
  // Violet secondaire
  static const Color accent = Color(0xFF7C3AED); 
  static const Color accentLight = Color(0xFF8B5CF6);
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Textes clairs pour contraster avec le fond sombre
  static const Color textPrimary = Color(0xFFF8FAFC); 
  static const Color textSecondary = Color(0xFF94A3B8); 
  static const Color textMuted = Color(0xFF64748B); 
}
