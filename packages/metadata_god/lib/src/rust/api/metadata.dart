// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.3.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `get_or_create_tag`, `get_tag_for_file`, `open_or_create_tag_for_file`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `fmt`, `fmt`

Future<Metadata> readMetadata({required String file}) =>
    RustLib.instance.api.crateApiMetadataReadMetadata(file: file);

Future<void> writeMetadata(
        {required String file, required Metadata metadata}) =>
    RustLib.instance.api
        .crateApiMetadataWriteMetadata(file: file, metadata: metadata);

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
  final Picture? picture;
  final BigInt? fileSize;

  const Metadata({
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

  @override
  int get hashCode =>
      title.hashCode ^
      durationMs.hashCode ^
      artist.hashCode ^
      album.hashCode ^
      albumArtist.hashCode ^
      trackNumber.hashCode ^
      trackTotal.hashCode ^
      discNumber.hashCode ^
      discTotal.hashCode ^
      year.hashCode ^
      genre.hashCode ^
      picture.hashCode ^
      fileSize.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Metadata &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          durationMs == other.durationMs &&
          artist == other.artist &&
          album == other.album &&
          albumArtist == other.albumArtist &&
          trackNumber == other.trackNumber &&
          trackTotal == other.trackTotal &&
          discNumber == other.discNumber &&
          discTotal == other.discTotal &&
          year == other.year &&
          genre == other.genre &&
          picture == other.picture &&
          fileSize == other.fileSize;
}

class Picture {
  /// The picture's MIME type.
  final String mimeType;

  /// The image data.
  final Uint8List data;

  const Picture({
    required this.mimeType,
    required this.data,
  });

  @override
  int get hashCode => mimeType.hashCode ^ data.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Picture &&
          runtimeType == other.runtimeType &&
          mimeType == other.mimeType &&
          data == other.data;
}
