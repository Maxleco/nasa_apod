import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';
import 'package:nasa_clean_arch/app/features/domain/entities/space_media_entity.dart';

import '../../mocks/space_media_mock.dart';

main() {

  final tSpaceMediaModel = SpaceMediaModel(
    title: 'A Colorful Quadrantid Meteor',
    description: "Meteors can be colorful. While the human eye usually cannot discern many colors, cameras often can. Pictured is a Quadrantids meteor captured by camera over Missouri, USA, early this month that was not only impressively bright, but colorful. The radiant grit, likely cast off by asteroid 2003 EH1, blazed a path across Earth's atmosphere...",
    mediaType: 'image',
    mediaUrl: 'https://apod.nasa.gov/apod/image/2102/MeteorStreak_Kuszaj_1080.jpg',
  );

  test('Should be a subclass of SpaceMediaEntity', (){
    expect(tSpaceMediaModel, isA<SpaceMediaEntity>());
  });

  test('Should return a valid model', (){
    // Arrange
    final Map<String, dynamic> jsonMap = json.decode(spaceMediaMock);
    // Act
    final result = SpaceMediaModel.fromMap(map: jsonMap);
    // Assert
    expect(result, tSpaceMediaModel);
  });

  test('Should return a Json Map containing the proper data', (){
    // Arrange
    final expectedMap = {
      'title': 'A Colorful Quadrantid Meteor',
      'explanation': "Meteors can be colorful. While the human eye usually cannot discern many colors, cameras often can. Pictured is a Quadrantids meteor captured by camera over Missouri, USA, early this month that was not only impressively bright, but colorful. The radiant grit, likely cast off by asteroid 2003 EH1, blazed a path across Earth's atmosphere...",
      'media_type': 'image',
      'url': 'https://apod.nasa.gov/apod/image/2102/MeteorStreak_Kuszaj_1080.jpg',
    };
    // Act
    final result = tSpaceMediaModel.toMap();
    // Assert
    expect(result, expectedMap);
  });
  
}
