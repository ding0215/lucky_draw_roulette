part of 'lucky_draw_cubit.dart';

@immutable
sealed class LuckyDrawState {}

final class LuckyDrawInitial extends LuckyDrawState {}

final class LuckyDrawSuccess extends LuckyDrawState {
  final List<dynamic> drawRecord;
  final int drawCount;
  LuckyDrawSuccess({required this.drawRecord, required this.drawCount});
}

final class LuckyDrawFail extends LuckyDrawState {
  final String errorMsg;
  LuckyDrawFail({required this.errorMsg});
}
