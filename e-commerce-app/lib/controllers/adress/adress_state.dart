part of 'adress_cubit.dart';

@immutable
sealed class AdressState {}

final class AdressInitial extends AdressState {}

final class AdressLoading extends AdressState {}

final class AdressLoaded extends AdressState {
  final dynamic address;
  
  AdressLoaded(this.address);
}

final class AdressError extends AdressState {
  final String message;
  
  AdressError(this.message);
}
