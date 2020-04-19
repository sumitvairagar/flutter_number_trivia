import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_game/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            inputString = value;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number.",
          ),
          onSubmitted: (_){
            addConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text("Search"),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: addConcrete,
              )
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text("Get Random"),
                onPressed: addRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void addConcrete(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
    .add(GetTriviaForConcreteNumber(inputString));
  }

   void addRandom(){
     controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
    .add(GetTriviaForRandomNumber());
  }
}
