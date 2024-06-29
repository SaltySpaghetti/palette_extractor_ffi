import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart' as ffi;

import 'rust_plugin_bindings_generated.dart';

const String _libName = 'libpalette_extractor';

/// The dynamic library in which the symbols for [RustPluginBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.dylib');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final RustPluginBindings _bindings = RustPluginBindings(_dylib);

List<int> extractPalette(String imagePath, int k, int maxIterations) {
  final colorsPtr = _bindings.extract_palette(
    imagePath.toNativeUtf8().cast<Char>(),
    imagePath.length,
    k,
    maxIterations,
  );

  final aaaa = Pointer<Char>.fromAddress(colorsPtr.address);

  return List.generate(k * 4, (i) => (aaaa + i).value);
}
