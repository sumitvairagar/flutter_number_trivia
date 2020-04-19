import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_game/core/error/failures.dart';
import 'package:number_game/core/usecases/usecase.dart';
import 'package:number_game/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_game/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreateNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;
  Params({@required this.number});

  @override
  List<Object> get props => [number];
  
  }