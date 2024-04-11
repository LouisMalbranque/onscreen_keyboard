import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onscreen_keyboard/data/loading.dart';
import 'package:onscreen_keyboard/data/lower_case.dart';
import 'package:onscreen_keyboard/data/symbols_1.dart';
import 'package:onscreen_keyboard/data/symbols_2.dart';
import 'package:onscreen_keyboard/data/upper_case.dart';

part 'keyboard_shift_event.dart';
part 'keyboard_shift_state.dart';

class KeyboardShiftBloc extends Bloc<KeyboardShiftEvent, KeyboardShiftState> {
  KeyboardShiftBloc() : super(KeyboardShiftInitial()) {
    on((event, emit) => (emit(KeyboardShiftLoading(loading))));

    on<KeyboardShiftUpperCaseEvent>((event, emit) {
      //
      emit(KeyboardShiftUpperCase(upperCase));
    });
    on<KeyboardShiftSymbols1Event>((event, emit) {
      //
      emit(KeyboardShiftSymbols1(symbols_1));
    });
    on<KeyboardShiftSymbols2Event>((event, emit) {
      //
      emit(KeyboardShiftSymbols2(symbols_2));
    });
    on<KeyboardShiftLowerCaseEvent>((event, emit) {
      //
      emit(KeyboardShiftLowerCase(lowerCase));
    });
  }
}
