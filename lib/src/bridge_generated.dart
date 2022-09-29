// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`.

// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'dart:ffi' as ffi;

abstract class Rust {
  Future<String> ping({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kPingConstMeta;

  Future<Metadata> readMetadata({required String file, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kReadMetadataConstMeta;

  Future<void> writeMetadata(
      {required String file, required Metadata metadata, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kWriteMetadataConstMeta;
}

class Image {
  /// The picture's MIME type.
  final String mimeType;

  /// The image data.
  final Uint8List data;

  Image({
    required this.mimeType,
    required this.data,
  });
}

class Metadata {
  final String? title;
  final double? durationMs;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final int? trackNumber;
  final int? trackTotal;
  final int? discNumber;
  final int? discTotal;
  final int? year;
  final String? genre;
  final Image? picture;
  final int? fileSize;

  Metadata({
    this.title,
    this.durationMs,
    this.artist,
    this.album,
    this.albumArtist,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.year,
    this.genre,
    this.picture,
    this.fileSize,
  });
}

class RustImpl extends FlutterRustBridgeBase<RustWire> implements Rust {
  factory RustImpl(ffi.DynamicLibrary dylib) => RustImpl.raw(RustWire(dylib));

  RustImpl.raw(RustWire inner) : super(inner);

  Future<String> ping({dynamic hint}) => executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => inner.wire_ping(port_),
        parseSuccessData: _wire2api_String,
        constMeta: kPingConstMeta,
        argValues: [],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kPingConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ping",
        argNames: [],
      );

  Future<Metadata> readMetadata({required String file, dynamic hint}) =>
      executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) =>
            inner.wire_read_metadata(port_, _api2wire_String(file)),
        parseSuccessData: _wire2api_metadata,
        constMeta: kReadMetadataConstMeta,
        argValues: [file],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kReadMetadataConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "read_metadata",
        argNames: ["file"],
      );

  Future<void> writeMetadata(
          {required String file, required Metadata metadata, dynamic hint}) =>
      executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => inner.wire_write_metadata(port_,
            _api2wire_String(file), _api2wire_box_autoadd_metadata(metadata)),
        parseSuccessData: _wire2api_unit,
        constMeta: kWriteMetadataConstMeta,
        argValues: [file, metadata],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kWriteMetadataConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "write_metadata",
        argNames: ["file", "metadata"],
      );

  // Section: api2wire
  ffi.Pointer<wire_uint_8_list> _api2wire_String(String raw) {
    return _api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  ffi.Pointer<ffi.Double> _api2wire_box_autoadd_f64(double raw) {
    return inner.new_box_autoadd_f64_0(_api2wire_f64(raw));
  }

  ffi.Pointer<ffi.Int32> _api2wire_box_autoadd_i32(int raw) {
    return inner.new_box_autoadd_i32_0(_api2wire_i32(raw));
  }

  ffi.Pointer<wire_Image> _api2wire_box_autoadd_image(Image raw) {
    final ptr = inner.new_box_autoadd_image_0();
    _api_fill_to_wire_image(raw, ptr.ref);
    return ptr;
  }

  ffi.Pointer<wire_Metadata> _api2wire_box_autoadd_metadata(Metadata raw) {
    final ptr = inner.new_box_autoadd_metadata_0();
    _api_fill_to_wire_metadata(raw, ptr.ref);
    return ptr;
  }

  ffi.Pointer<ffi.Uint16> _api2wire_box_autoadd_u16(int raw) {
    return inner.new_box_autoadd_u16_0(_api2wire_u16(raw));
  }

  ffi.Pointer<ffi.Uint64> _api2wire_box_autoadd_u64(int raw) {
    return inner.new_box_autoadd_u64_0(_api2wire_u64(raw));
  }

  double _api2wire_f64(double raw) {
    return raw;
  }

  int _api2wire_i32(int raw) {
    return raw;
  }

  ffi.Pointer<wire_uint_8_list> _api2wire_opt_String(String? raw) {
    return raw == null ? ffi.nullptr : _api2wire_String(raw);
  }

  ffi.Pointer<ffi.Double> _api2wire_opt_box_autoadd_f64(double? raw) {
    return raw == null ? ffi.nullptr : _api2wire_box_autoadd_f64(raw);
  }

  ffi.Pointer<ffi.Int32> _api2wire_opt_box_autoadd_i32(int? raw) {
    return raw == null ? ffi.nullptr : _api2wire_box_autoadd_i32(raw);
  }

  ffi.Pointer<wire_Image> _api2wire_opt_box_autoadd_image(Image? raw) {
    return raw == null ? ffi.nullptr : _api2wire_box_autoadd_image(raw);
  }

  ffi.Pointer<ffi.Uint16> _api2wire_opt_box_autoadd_u16(int? raw) {
    return raw == null ? ffi.nullptr : _api2wire_box_autoadd_u16(raw);
  }

  ffi.Pointer<ffi.Uint64> _api2wire_opt_box_autoadd_u64(int? raw) {
    return raw == null ? ffi.nullptr : _api2wire_box_autoadd_u64(raw);
  }

  int _api2wire_u16(int raw) {
    return raw;
  }

  int _api2wire_u64(int raw) {
    return raw;
  }

  int _api2wire_u8(int raw) {
    return raw;
  }

  ffi.Pointer<wire_uint_8_list> _api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }

  // Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_image(
      Image apiObj, ffi.Pointer<wire_Image> wireObj) {
    _api_fill_to_wire_image(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_box_autoadd_metadata(
      Metadata apiObj, ffi.Pointer<wire_Metadata> wireObj) {
    _api_fill_to_wire_metadata(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_image(Image apiObj, wire_Image wireObj) {
    wireObj.mime_type = _api2wire_String(apiObj.mimeType);
    wireObj.data = _api2wire_uint_8_list(apiObj.data);
  }

  void _api_fill_to_wire_metadata(Metadata apiObj, wire_Metadata wireObj) {
    wireObj.title = _api2wire_opt_String(apiObj.title);
    wireObj.duration_ms = _api2wire_opt_box_autoadd_f64(apiObj.durationMs);
    wireObj.artist = _api2wire_opt_String(apiObj.artist);
    wireObj.album = _api2wire_opt_String(apiObj.album);
    wireObj.album_artist = _api2wire_opt_String(apiObj.albumArtist);
    wireObj.track_number = _api2wire_opt_box_autoadd_u16(apiObj.trackNumber);
    wireObj.track_total = _api2wire_opt_box_autoadd_u16(apiObj.trackTotal);
    wireObj.disc_number = _api2wire_opt_box_autoadd_u16(apiObj.discNumber);
    wireObj.disc_total = _api2wire_opt_box_autoadd_u16(apiObj.discTotal);
    wireObj.year = _api2wire_opt_box_autoadd_i32(apiObj.year);
    wireObj.genre = _api2wire_opt_String(apiObj.genre);
    wireObj.picture = _api2wire_opt_box_autoadd_image(apiObj.picture);
    wireObj.file_size = _api2wire_opt_box_autoadd_u64(apiObj.fileSize);
  }

  void _api_fill_to_wire_opt_box_autoadd_image(
      Image? apiObj, ffi.Pointer<wire_Image> wireObj) {
    if (apiObj != null) _api_fill_to_wire_box_autoadd_image(apiObj, wireObj);
  }
}

// Section: wire2api
String _wire2api_String(dynamic raw) {
  return raw as String;
}

double _wire2api_box_autoadd_f64(dynamic raw) {
  return raw as double;
}

int _wire2api_box_autoadd_i32(dynamic raw) {
  return raw as int;
}

Image _wire2api_box_autoadd_image(dynamic raw) {
  return _wire2api_image(raw);
}

int _wire2api_box_autoadd_u16(dynamic raw) {
  return raw as int;
}

int _wire2api_box_autoadd_u64(dynamic raw) {
  return raw as int;
}

double _wire2api_f64(dynamic raw) {
  return raw as double;
}

int _wire2api_i32(dynamic raw) {
  return raw as int;
}

Image _wire2api_image(dynamic raw) {
  final arr = raw as List<dynamic>;
  if (arr.length != 2)
    throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
  return Image(
    mimeType: _wire2api_String(arr[0]),
    data: _wire2api_uint_8_list(arr[1]),
  );
}

Metadata _wire2api_metadata(dynamic raw) {
  final arr = raw as List<dynamic>;
  if (arr.length != 13)
    throw Exception('unexpected arr length: expect 13 but see ${arr.length}');
  return Metadata(
    title: _wire2api_opt_String(arr[0]),
    durationMs: _wire2api_opt_box_autoadd_f64(arr[1]),
    artist: _wire2api_opt_String(arr[2]),
    album: _wire2api_opt_String(arr[3]),
    albumArtist: _wire2api_opt_String(arr[4]),
    trackNumber: _wire2api_opt_box_autoadd_u16(arr[5]),
    trackTotal: _wire2api_opt_box_autoadd_u16(arr[6]),
    discNumber: _wire2api_opt_box_autoadd_u16(arr[7]),
    discTotal: _wire2api_opt_box_autoadd_u16(arr[8]),
    year: _wire2api_opt_box_autoadd_i32(arr[9]),
    genre: _wire2api_opt_String(arr[10]),
    picture: _wire2api_opt_box_autoadd_image(arr[11]),
    fileSize: _wire2api_opt_box_autoadd_u64(arr[12]),
  );
}

String? _wire2api_opt_String(dynamic raw) {
  return raw == null ? null : _wire2api_String(raw);
}

double? _wire2api_opt_box_autoadd_f64(dynamic raw) {
  return raw == null ? null : _wire2api_box_autoadd_f64(raw);
}

int? _wire2api_opt_box_autoadd_i32(dynamic raw) {
  return raw == null ? null : _wire2api_box_autoadd_i32(raw);
}

Image? _wire2api_opt_box_autoadd_image(dynamic raw) {
  return raw == null ? null : _wire2api_box_autoadd_image(raw);
}

int? _wire2api_opt_box_autoadd_u16(dynamic raw) {
  return raw == null ? null : _wire2api_box_autoadd_u16(raw);
}

int? _wire2api_opt_box_autoadd_u64(dynamic raw) {
  return raw == null ? null : _wire2api_box_autoadd_u64(raw);
}

int _wire2api_u16(dynamic raw) {
  return raw as int;
}

int _wire2api_u64(dynamic raw) {
  return raw as int;
}

int _wire2api_u8(dynamic raw) {
  return raw as int;
}

Uint8List _wire2api_uint_8_list(dynamic raw) {
  return raw as Uint8List;
}

void _wire2api_unit(dynamic raw) {
  return;
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.

/// generated by flutter_rust_bridge
class RustWire implements FlutterRustBridgeWireBase {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustWire(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  RustWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void wire_ping(
    int port_,
  ) {
    return _wire_ping(
      port_,
    );
  }

  late final _wire_pingPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>('wire_ping');
  late final _wire_ping = _wire_pingPtr.asFunction<void Function(int)>();

  void wire_read_metadata(
    int port_,
    ffi.Pointer<wire_uint_8_list> file,
  ) {
    return _wire_read_metadata(
      port_,
      file,
    );
  }

  late final _wire_read_metadataPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_read_metadata');
  late final _wire_read_metadata = _wire_read_metadataPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_write_metadata(
    int port_,
    ffi.Pointer<wire_uint_8_list> file,
    ffi.Pointer<wire_Metadata> metadata,
  ) {
    return _wire_write_metadata(
      port_,
      file,
      metadata,
    );
  }

  late final _wire_write_metadataPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_Metadata>)>>('wire_write_metadata');
  late final _wire_write_metadata = _wire_write_metadataPtr.asFunction<
      void Function(
          int, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_Metadata>)>();

  ffi.Pointer<ffi.Double> new_box_autoadd_f64_0(
    double value,
  ) {
    return _new_box_autoadd_f64_0(
      value,
    );
  }

  late final _new_box_autoadd_f64_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Double> Function(ffi.Double)>>(
          'new_box_autoadd_f64_0');
  late final _new_box_autoadd_f64_0 = _new_box_autoadd_f64_0Ptr
      .asFunction<ffi.Pointer<ffi.Double> Function(double)>();

  ffi.Pointer<ffi.Int32> new_box_autoadd_i32_0(
    int value,
  ) {
    return _new_box_autoadd_i32_0(
      value,
    );
  }

  late final _new_box_autoadd_i32_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Int32> Function(ffi.Int32)>>(
          'new_box_autoadd_i32_0');
  late final _new_box_autoadd_i32_0 = _new_box_autoadd_i32_0Ptr
      .asFunction<ffi.Pointer<ffi.Int32> Function(int)>();

  ffi.Pointer<wire_Image> new_box_autoadd_image_0() {
    return _new_box_autoadd_image_0();
  }

  late final _new_box_autoadd_image_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_Image> Function()>>(
          'new_box_autoadd_image_0');
  late final _new_box_autoadd_image_0 = _new_box_autoadd_image_0Ptr
      .asFunction<ffi.Pointer<wire_Image> Function()>();

  ffi.Pointer<wire_Metadata> new_box_autoadd_metadata_0() {
    return _new_box_autoadd_metadata_0();
  }

  late final _new_box_autoadd_metadata_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_Metadata> Function()>>(
          'new_box_autoadd_metadata_0');
  late final _new_box_autoadd_metadata_0 = _new_box_autoadd_metadata_0Ptr
      .asFunction<ffi.Pointer<wire_Metadata> Function()>();

  ffi.Pointer<ffi.Uint16> new_box_autoadd_u16_0(
    int value,
  ) {
    return _new_box_autoadd_u16_0(
      value,
    );
  }

  late final _new_box_autoadd_u16_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Uint16> Function(ffi.Uint16)>>(
          'new_box_autoadd_u16_0');
  late final _new_box_autoadd_u16_0 = _new_box_autoadd_u16_0Ptr
      .asFunction<ffi.Pointer<ffi.Uint16> Function(int)>();

  ffi.Pointer<ffi.Uint64> new_box_autoadd_u64_0(
    int value,
  ) {
    return _new_box_autoadd_u64_0(
      value,
    );
  }

  late final _new_box_autoadd_u64_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Uint64> Function(ffi.Uint64)>>(
          'new_box_autoadd_u64_0');
  late final _new_box_autoadd_u64_0 = _new_box_autoadd_u64_0Ptr
      .asFunction<ffi.Pointer<ffi.Uint64> Function(int)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturnStruct(
    WireSyncReturnStruct val,
  ) {
    return _free_WireSyncReturnStruct(
      val,
    );
  }

  late final _free_WireSyncReturnStructPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturnStruct)>>(
          'free_WireSyncReturnStruct');
  late final _free_WireSyncReturnStruct = _free_WireSyncReturnStructPtr
      .asFunction<void Function(WireSyncReturnStruct)>();

  void store_dart_post_cobject(
    covariant ptr,
  ) {
    return _store_dart_post_cobject(
      ptr.address,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject =
      _store_dart_post_cobjectPtr.asFunction<void Function(int)>();
}

class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

class wire_Image extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> mime_type;

  external ffi.Pointer<wire_uint_8_list> data;
}

class wire_Metadata extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> title;

  external ffi.Pointer<ffi.Double> duration_ms;

  external ffi.Pointer<wire_uint_8_list> artist;

  external ffi.Pointer<wire_uint_8_list> album;

  external ffi.Pointer<wire_uint_8_list> album_artist;

  external ffi.Pointer<ffi.Uint16> track_number;

  external ffi.Pointer<ffi.Uint16> track_total;

  external ffi.Pointer<ffi.Uint16> disc_number;

  external ffi.Pointer<ffi.Uint16> disc_total;

  external ffi.Pointer<ffi.Int32> year;

  external ffi.Pointer<wire_uint_8_list> genre;

  external ffi.Pointer<wire_Image> picture;

  external ffi.Pointer<ffi.Uint64> file_size;
}
