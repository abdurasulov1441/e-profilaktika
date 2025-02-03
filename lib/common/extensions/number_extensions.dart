import 'package:flutter/material.dart';

extension NumberExtensionsX on num {
  SizedBox get horizontal => SizedBox(width: toDouble());

  SizedBox get vertical => SizedBox(height: toDouble());
}
