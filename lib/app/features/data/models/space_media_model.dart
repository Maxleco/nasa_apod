import 'dart:convert';

import 'package:nasa_clean_arch/app/features/domain/entities/space_media_entity.dart';

class SpaceMediaModel extends SpaceMediaEntity {
  static const FIELD_NAME_DESCRIPTION = 'explanation';
  static const FIELD_NAME_MEDIATYPE = 'media_type';
  static const FIELD_NAME_TITLE = 'title';
  static const FIELD_NAME_MEDIAURL = 'url';

  SpaceMediaModel({
    required String description,
    required String mediaType,
    required String title,
    required String mediaUrl,
  }) : super(
          description: description,
          title: title,
          mediaType: mediaType,
          mediaUrl: mediaUrl,
        );

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME_TITLE: this.title,
      FIELD_NAME_DESCRIPTION: this.description,
      FIELD_NAME_MEDIATYPE: this.mediaType,
      FIELD_NAME_MEDIAURL: this.mediaUrl,
    };
  }

  static SpaceMediaModel fromMap({required Map<String, dynamic> map}) {
    return SpaceMediaModel(
      title: map[FIELD_NAME_TITLE],
      description: map[FIELD_NAME_DESCRIPTION],
      mediaType: map[FIELD_NAME_MEDIATYPE],
      mediaUrl: map[FIELD_NAME_MEDIAURL],
    );
  }

  String toJson() => json.encode(this.toMap());

  static SpaceMediaModel fromJson(String source) {
    return fromMap(map: json.decode(source));
  }

  static SpaceMediaModel fromEntity({required SpaceMediaEntity entity}) {
    return SpaceMediaModel(
      title: entity.title,
      description: entity.description,
      mediaType: entity.mediaType,
      mediaUrl: entity.mediaUrl,
    );
  }
}
