import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_game/core/error/exceptions.dart';
import 'package:number_game/core/error/failures.dart';
import 'package:number_game/core/network/network_info.dart';
import 'package:number_game/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_game/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_game/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_game/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_game/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_game/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockRemoteDatasource extends Mock 
  implements NumberTriviaRemoteDatasource {}

class MockLocalDatasource extends Mock 
  implements NumberTriviaLocalDatasource {}  

class MockNetworkInfo extends Mock 
  implements NetworkInfo {}  


void main(){
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDatasource mockRemoteDatasource;
  MockLocalDatasource mockLocalDatasource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo
    );
  });

  void runTestOnline(Function body){
    group('device is online', (){
      setUp((){ when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);});
      body();
    });
  }

  void runTestOffline(Function body){
    group('device is offline', (){
      setUp((){ when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);});
      body();
    });
  }


  group('getConcreateNumberTrivia', (){

    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

     test('if the device is online', 
     () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getConcreateNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    },
    );

    runTestOnline(() {

        test('should return Remote data when the call remote data is succes', 
        () async {
          // arrange
          when(mockRemoteDatasource.getConcreateNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl.getConcreateNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDatasource.getConcreateNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
          },
        );


       test('should cache Remote data locally when the call remote data is succes', 
       () async {
        // arrange
        when(mockRemoteDatasource.getConcreateNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repositoryImpl.getConcreateNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDatasource.getConcreateNumberTrivia(tNumber));
        verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );


        test('should return server failure when the call remote data is  unsuccesful', 
        () async {
          // arrange
          when(mockRemoteDatasource.getConcreateNumberTrivia(any))
            .thenThrow(ServerException());
          // act
          final result = await repositoryImpl.getConcreateNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDatasource.getConcreateNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
          },
        );


    });

    runTestOffline((){
      
       test('should return last locally cached data when the cached data is present', 
          () async {
            // arrange
            when(mockLocalDatasource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
            // act
              final result = await repositoryImpl.getConcreateNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDatasource);
              verify(mockLocalDatasource.getLastNumberTrivia());
              expect(result, equals(Right(tNumberTrivia)));

          },
        );

          test('should return cache failure when no cache data is present', 
            () async {
              // arrange
              when(mockLocalDatasource.getLastNumberTrivia())
                .thenThrow(CacheException());
              // act
              final result = await repositoryImpl.getConcreateNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDatasource);
              verify(mockLocalDatasource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
        );
    }); // Device is offline
  }); // getConcreteNumberTrivia



   group('getRandomNumberTrivia', (){

  
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

     test('if the device is online', 
     () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    },
    );

    runTestOnline(() {

        test('should return Remote data when the call remote data is succes', 
        () async {
          // arrange
          when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
          },
        );


       test('should cache Remote data locally when the call remote data is succes', 
       () async {
        // arrange
        when(mockRemoteDatasource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repositoryImpl.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );


        test('should return server failure when the call remote data is  unsuccesful', 
        () async {
          // arrange
          when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());
          // act
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
          },
        );


    });

    runTestOffline((){
      
       test('should return last locally cached data when the cached data is present', 
          () async {
            // arrange
            when(mockLocalDatasource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
            // act
              final result = await repositoryImpl.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockRemoteDatasource);
              verify(mockLocalDatasource.getLastNumberTrivia());
              expect(result, equals(Right(tNumberTrivia)));

          },
        );

          test('should return cache failure when no cache data is present', 
            () async {
              // arrange
              when(mockLocalDatasource.getLastNumberTrivia())
                .thenThrow(CacheException());
              // act
              final result = await repositoryImpl.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockRemoteDatasource);
              verify(mockLocalDatasource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
        );
    }); // Device is offline
  });



}