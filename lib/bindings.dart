import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'package:cpp/cpp_bindings_generated.dart' as cpp_bindings;
import 'package:rust/rust_bindings_generated.dart' as rust_bindings;

List<int> extractPalette(
  Language language,
  String imagePath,
  int k,
  int maxIterations,
) {
  final colorsPtr = switch (language) {
    Language.rust => rust_bindings.extract_palette(
        imagePath.toNativeUtf8().cast<ffi.Char>(),
        imagePath.length,
        k,
        maxIterations,
      ),
    Language.cpp => cpp_bindings.extract_palette(
        imagePath.toNativeUtf8().cast<ffi.Char>(),
        imagePath.length,
        k,
        maxIterations,
      ),
  };

  return List.generate(k * 4, (i) => (colorsPtr + i).value);
}

enum Language {
  rust,
  cpp;
}
