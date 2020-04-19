import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_game/core/util/input_converter.dart';

void main(){
  InputConverter inputConverter;
  setUp((){
    inputConverter = InputConverter();
  });

  group('unsigned int', (){
       test('should return integer when a string represents unsigned integer', 
       () async {
          // arrange
          final String str = "123";
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, Right(123));
          },
      );



       test('should return failure when a string is not an integer', 
       () async {
          // arrange
          final String str = "abc";
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, Left(InvalidInputFailure()));
          },
      );

       test('should return failure when a string is a negative integer', 
       () async {
          // arrange
          final String str = "-123";
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, Left(InvalidInputFailure()));
          },
      );
  });
}