import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0); // أول Screen = Products

  void changeTab(int index) {
    emit(index);
  }
}
