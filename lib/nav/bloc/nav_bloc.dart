import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/enums/nav_item.dart';

part 'nav_event.dart';

class NavBloc extends Bloc<NavEvent, NavItem> {
  NavBloc() : super(NavItem.dashboard) {
    on<NavEvent>((event, emit) {
      if (event is UpdateNavItem) {
        emit(event.item);
      }
    });
  }
}
