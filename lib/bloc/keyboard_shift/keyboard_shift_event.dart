part of 'keyboard_shift_bloc.dart';

abstract class KeyboardShiftEvent extends Equatable {
  const KeyboardShiftEvent();

  @override
  List<Object> get props => [];
}

class KeyboardShiftUpperCaseEvent extends KeyboardShiftEvent {
  const KeyboardShiftUpperCaseEvent();
}

class KeyboardShiftLowerCaseEvent extends KeyboardShiftEvent {
  const KeyboardShiftLowerCaseEvent();
}

class KeyboardShiftSymbols1Event extends KeyboardShiftEvent {
  const KeyboardShiftSymbols1Event();
}

class KeyboardShiftSymbols2Event extends KeyboardShiftEvent {
  const KeyboardShiftSymbols2Event();
}
