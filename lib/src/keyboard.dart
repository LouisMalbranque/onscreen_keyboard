import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onscreen_keyboard/bloc/keyboard_shift/keyboard_shift_bloc.dart';
import 'package:onscreen_keyboard/data/loading.dart';
import 'package:onscreen_keyboard/src/button.dart';
import 'package:onscreen_keyboard/src/utils.dart';

///
///
class OnscreenKeyboard extends StatelessWidget {
  final ValueChanged<String?>? onChanged;
  final String? value;
  final InitialCase initialCase;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? focusColor;

  final Color? textColor;
  final double? fontSize;
  
  OnscreenKeyboard({
    this.onChanged,
    this.backgroundColor,
    this.focusColor,
    this.borderColor,
    this.buttonColor,
    this.value,
    required this.initialCase,

    this.textColor,
    this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KeyboardShiftBloc>(
            create: (context) => KeyboardShiftBloc()),
      ],
      child: OnscreenKeyboardWidget(
        onChanged: onChanged,
        initialCase: initialCase,
        value: value,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        buttonColor: buttonColor,
        focusColor: focusColor,
        textColor: textColor,
        fontSize: fontSize,
      ),
    );
  }
}

class OnscreenKeyboardWidget extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  final InitialCase? initialCase;
  final String? value;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? focusColor;
  final Color? textColor;
  final double? fontSize;
  OnscreenKeyboardWidget({
    this.onChanged,
    this.backgroundColor,
    this.focusColor,
    this.borderColor,
    this.buttonColor,
    this.value,
    this.initialCase,
    this.textColor,
    this.fontSize,
  });
  @override
  _OnscreenKeyboardWidgetState createState() => _OnscreenKeyboardWidgetState();
}

class _OnscreenKeyboardWidgetState extends State<OnscreenKeyboardWidget> {
  String? text = '';
  @override
  void initState() {
    //
    super.initState();
    if (widget.value != null) {
      text = widget.value;
    }
  }

  void specialCharacters() {
    //
    KeyboardShiftState state = BlocProvider.of<KeyboardShiftBloc>(context).state;
    if (state is KeyboardShiftSymbols1 || state is KeyboardShiftSymbols2) {
      BlocProvider.of<KeyboardShiftBloc>(context)
          .add(KeyboardShiftLowerCaseEvent());
    } else {
      BlocProvider.of<KeyboardShiftBloc>(context)
          .add(KeyboardShiftSymbols1Event());
    }
  }

  void shift() {
    KeyboardShiftState state = BlocProvider.of<KeyboardShiftBloc>(context).state;
    if (state is KeyboardShiftUpperCase) {
      BlocProvider.of<KeyboardShiftBloc>(context)
          .add(KeyboardShiftLowerCaseEvent());
    } else if (state is KeyboardShiftLowerCase) {
      BlocProvider.of<KeyboardShiftBloc>(context)
          .add(KeyboardShiftUpperCaseEvent());
    } else if (state is KeyboardShiftSymbols1) {
      BlocProvider.of<KeyboardShiftBloc>(context)
          .add(KeyboardShiftSymbols2Event());
    } else if (state is KeyboardShiftSymbols2) {
      BlocProvider.of<KeyboardShiftBloc>(context)
          .add(KeyboardShiftSymbols1Event());
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    switch (widget.initialCase) {
      case InitialCase.UPER_CASE:
        BlocProvider.of<KeyboardShiftBloc>(context)
            .add(KeyboardShiftUpperCaseEvent());

        break;
      case InitialCase.LOWER_CASE:
        BlocProvider.of<KeyboardShiftBloc>(context)
            .add(KeyboardShiftLowerCaseEvent());
        break;
      case InitialCase.SENTENSE_CASE:
        BlocProvider.of<KeyboardShiftBloc>(context)
            .add(KeyboardShiftUpperCaseEvent());
        break;
      case InitialCase.SYMBOL1:
        BlocProvider.of<KeyboardShiftBloc>(context)
            .add(KeyboardShiftSymbols1Event());
        break;
      case InitialCase.SYMBOL2:
        BlocProvider.of<KeyboardShiftBloc>(context)
            .add(KeyboardShiftSymbols2Event());
        break;
      default:
        BlocProvider.of<KeyboardShiftBloc>(context)
            .add(KeyboardShiftUpperCaseEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [

                  Flexible(
                    child: new Button(
                      autofocus: false,
                      focusColor: widget.focusColor ?? widget.focusColor,
                      borderColor: widget.borderColor ?? widget.borderColor,
                      buttonColor: widget.buttonColor ?? widget.buttonColor,
                      textColor: widget.textColor,
                      onPressed: () {
                        text = '';
                        setState(() {});
                        widget.onChanged!(text);
                      },
                      label: new Text(
                        'CLEAR',
                        style: new TextStyle(
                            fontSize: widget.fontSize ?? 17, fontWeight: FontWeight.bold, color: widget.textColor),
                      ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: new Button(
                      autofocus: false,
                      focusColor: widget.focusColor ?? widget.focusColor,
                      borderColor: widget.borderColor ?? widget.borderColor,
                      buttonColor: widget.buttonColor ?? widget.buttonColor,
                      textColor: widget.textColor,
                      onPressed: () {
                        if (text!.length > 0) {
                          text = text!.substring(0, text!.length - 1);
                        }
                        setState(() {});
                        widget.onChanged!(text);
                      },
                      label: new Icon(
                        Icons.backspace,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  color: widget.backgroundColor != null
                      ? widget.backgroundColor
                      : Colors.transparent,
                  child: BlocBuilder<KeyboardShiftBloc, KeyboardShiftState>(
                      builder: (context, state) {
                    //
                    if (state is KeyboardShiftLowerCase) {
                      return _buildBody(state.lowerCase);
                    } else if (state is KeyboardShiftUpperCase) {
                      return _buildBody(state.upperCase);
                    } else if (state is KeyboardShiftLoading) {
                      return _buildBody(state.loading);
                    } else if (state is KeyboardShiftSymbols1) {
                      return _buildBody(state.symbols);
                    } else if (state is KeyboardShiftSymbols2) {
                      return _buildBody(state.symbols);
                    } else {
                      return _buildBody(loading);
                    }
                  }),
                ),
              ),
              Container(
                color: widget.backgroundColor != null
                    ? widget.backgroundColor
                    : Colors.transparent,
                child: new Row(
                  children: <Widget>[
                    Flexible(
                      child: new Button(
                        autofocus: false,
                        focusColor: widget.focusColor ?? widget.focusColor,
                        borderColor: widget.borderColor ?? widget.borderColor,
                        buttonColor: widget.buttonColor ?? widget.buttonColor,
                        textColor: widget.textColor,
                        onPressed: () {
                          shift();
                        },
                        label: new BlocBuilder<KeyboardShiftBloc, KeyboardShiftState>(
                          builder: (context, state) {
                            if (state is KeyboardShiftSymbols1) {
                              return Text(
                                '1/2',
                                style: new TextStyle(
                                    fontSize: widget.fontSize ?? 17, fontWeight: FontWeight.bold, color: widget.textColor),
                              );
                            } else if (state is KeyboardShiftSymbols2) {
                              return Text(
                                '2/2',
                                style: new TextStyle(
                                    fontSize: widget.fontSize ?? 17, fontWeight: FontWeight.bold, color: widget.textColor),
                              );
                            } else {
                              return Icon(
                                Icons.arrow_upward,
                                size: 20,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: new Button(
                        autofocus: false,
                        focusColor: widget.focusColor ?? widget.focusColor,
                        borderColor: widget.borderColor ?? widget.borderColor,
                        buttonColor: widget.buttonColor ?? widget.buttonColor,
                        textColor: widget.textColor,
                        onPressed: () {
                          specialCharacters();
                        },
                        label: new BlocBuilder<KeyboardShiftBloc, KeyboardShiftState>(
                          builder: (context, state) {
                            if (state is KeyboardShiftSymbols1 ||
                                state is KeyboardShiftSymbols2) {
                              return Text(
                                'ABC',
                                style: new TextStyle(
                                    fontSize: widget.fontSize ?? 17, fontWeight: FontWeight.bold, color: widget.textColor),
                              );
                            } else {
                              return Text(
                                '!#1',
                                style: new TextStyle(
                                    fontSize: widget.fontSize ?? 17, fontWeight: FontWeight.bold, color: widget.textColor),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Flexible( flex: 6,
                      child: new Button(
                        autofocus: true,
                        focusColor: widget.focusColor ?? widget.focusColor,
                        borderColor: widget.borderColor ?? widget.borderColor,
                        buttonColor: widget.buttonColor ?? widget.buttonColor,
                        textColor: widget.textColor,
                        onPressed: () {
                          text = text! + ' ';
                          setState(() {});
                          widget.onChanged!(text);
                        },
                        label: new Icon(
                          Icons.space_bar,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(List<String> labels) {
    //
    return GridView.builder(
        shrinkWrap: true,
        itemCount: labels.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
        ),
        itemBuilder: (context, index) {
          return new Button(
            autofocus: false,
            focusColor: widget.focusColor ?? widget.focusColor,
            borderColor: widget.borderColor ?? widget.borderColor,
            buttonColor: widget.buttonColor ?? widget.buttonColor,
            textColor: widget.textColor,
            label: new Text(
              labels[index],
              style: new TextStyle(fontSize: widget.fontSize ?? 17, ),
            ),
            onPressed: () {
              text = text! + labels[index];
              setState(() {});
              widget.onChanged!(text);
            },
          );
        });
  }
}
