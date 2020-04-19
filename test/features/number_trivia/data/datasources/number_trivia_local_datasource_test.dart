import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_game/core/error/exceptions.dart';
import 'package:number_game/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_game/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../core/fixtures/fixture_reader.dart';


class MockSharedPreferences extends Mock implements SharedPreferences{}

void main(){
  NumberTriviaLocalDatasourceImpl datasource;
  MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDatasourceImpl( sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia_cache.json')));
     test('should return number trivia from shared preferences when there is one in the cache', 
     () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(fixtureReader("trivia_cache.json"));
        // act
        final result = await datasource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, tNumberTriviaModel);
      },
    );

     test('should return a cache failure from there is nothing in the cache', 
     () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = datasource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Trivia');
       test('call Sharedprefernces to cache the data', 
       () async {
          // act
          datasource.cacheNumberTrivia(tNumberTriviaModel);
          // assert
          final expectedJson = jsonEncode(tNumberTriviaModel.toJson());
          verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJson));
        },
      );
  });

}