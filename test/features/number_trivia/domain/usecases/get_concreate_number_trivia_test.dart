import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:number_game/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_game/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_game/features/number_trivia/domain/usercases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get number trivia from the repository', 
  () async {
      //arrange
      when(mockNumberTriviaRepository.getConcreateNumberTrivia(any))
      .thenAnswer((_) async =>  Right(tNumberTrivia));
      //act
      final result = await usecase(Params(number: tNumber));
      //assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreateNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
  },
  );


}