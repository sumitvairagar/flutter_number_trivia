import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_game/core/error/exceptions.dart';
import 'package:number_game/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_game/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDatasourceImpl datasource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixtureReader('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the endpoint 
     and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        datasource.getConcreateNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get('http://numbersapi.come/$tNumber',
            headers: {'Content-Type': 'application/json'}));
      },
    );
    
     test('should return number trivia when response is 200', 
     () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await datasource.getConcreateNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );


     test('should throw ServerException when response is  not 200', 
     () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call =  datasource.getConcreateNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });//getConcreteNumberTrivia

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the endpoint 
     and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        datasource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get('http://numbersapi.come/random',
            headers: {'Content-Type': 'application/json'}));
      },
    );
    
     test('should return number trivia when response is 200', 
     () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await datasource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );


     test('should throw ServerException when response is  not 200', 
     () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call =  datasource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });//getConcreteNumberTrivia
}
