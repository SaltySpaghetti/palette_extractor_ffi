// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

@ffi.Native<
    ffi.Pointer<ffi.UnsignedChar> Function(ffi.Pointer<ffi.Char>,
        ffi.UnsignedInt, ffi.UnsignedInt, ffi.UnsignedInt)>()
external ffi.Pointer<ffi.UnsignedChar> extract_palette(
  ffi.Pointer<ffi.Char> img_path_ptr,
  int img_path_len,
  int k,
  int max_iterations,
);
