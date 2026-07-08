extension MacroFormatter on double {
  /// Format a macro value to 1 decimal place, or omit the decimal if it's .0
  String formatMacro() {
    if (isNaN || isInfinite) {
      return '0';
    }
    if (this == toInt().toDouble()) {
      return toInt().toString();
    }
    return toStringAsFixed(1);
  }
}
