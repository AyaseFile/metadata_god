import 'rust/frb_generated.dart' as frb;
import 'rust/api/metadata.dart' as api_metadata;

abstract class MetadataGod {
  MetadataGod._();

  /// Initialize the MetadataGod library
  ///
  /// Example:
  /// ```dart
  /// import 'package:metadata_god/metadata_god.dart';
  /// import 'package:flutter/material.dart';
  ///
  /// void main() async {
  ///  await WidgetsFlutterBinding.ensureInitialized();
  ///  MetadataGod.initialize();
  ///
  ///  runApp(MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    await frb.RustLib.init();
  }

  /// Read metadata from a mp3, m4a, ogg & flac file
  ///
  /// The path to file must exists otherwise will throw [Exception]
  static Future<api_metadata.Metadata> readMetadata({required String file}) {
    return api_metadata.readMetadata(file: file);
  }

  /// Write metadata to a mp3, m4a, ogg & flac file
  ///
  /// The path to file must exists otherwise will throw [Exception]
  ///
  /// Example:
  /// ```dart
  /// await MetadataGod.writeMetadata(
  ///   "/path/to/audio-file",
  ///   Metadata(
  ///     title: "Leave the Door Open",
  ///     artist: "Bruno Mars, Anderson .Paak, Silk Sonic",
  ///     album: "An Evening with Silk Sonic",
  ///     genre: "R&B, Soul",
  ///     year: 2021,
  ///     albumArtist: "Bruno Mars, Anderson .Paak",
  ///     trackNumber: 1,
  ///     trackTotal: 12,
  ///     discNumber: 1,
  ///     discTotal: 5,
  ///     durationMs: 248000,
  ///     fileSize: file.lengthSync(),
  ///     picture: Picture(
  ///       data: File("/path/to/cover-image").readAsBytesSync(),
  ///       mimeType: lookupMimeType("/path/to/cover-image"),
  ///     ),
  ///   ),
  /// );
  /// ```
  static Future<void> writeMetadata({
    required String file,
    required api_metadata.Metadata metadata,
  }) {
    return api_metadata.writeMetadata(file: file, metadata: metadata);
  }
}

extension MetadataDuration on api_metadata.Metadata {
  Duration? get duration =>
      durationMs == null ? null : Duration(milliseconds: durationMs!.floor());
}
