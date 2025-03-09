part of 'add_news_bottom_sheet_bloc.dart';

sealed class AddNewsBottomSheetState extends Equatable {
  const AddNewsBottomSheetState();
}

class AddNewsBottomSheetInitial extends AddNewsBottomSheetState {
  const AddNewsBottomSheetInitial();

  @override
  List<Object?> get props => [];
}

class AddNewsBottomSheetLoading extends AddNewsBottomSheetState {
  const AddNewsBottomSheetLoading();

  @override
  List<Object?> get props => [];
}

class AddNewsBottomSheetSuccess extends AddNewsBottomSheetState {
  const AddNewsBottomSheetSuccess();

  @override
  List<Object?> get props => [];
}

class AddNewsBottomSheetError extends AddNewsBottomSheetState {
  const AddNewsBottomSheetError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
