import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:test/cubit/lucky_draw/lucky_draw_cubit.dart';
import 'package:test/data/user.dart';
import 'package:test/helper/storage_helper.dart';

part 'lucky_draw_state.dart';

class LuckyDrawCubit extends Cubit<LuckyDrawState> {
  LuckyDrawCubit() : super(LuckyDrawInitial());

  final StorageHelper _storageHelper = StorageHelper();

  Future<void> draw({required String item, required DateTime date}) async {
    final formattedDate = DateFormat('d MMMM yyyy h:mm a').format(date);

    User? userToken = await _storageHelper.getToken();

    if (userToken == null) {
      return emit(LuckyDrawFail(errorMsg: "用户还没登录"));
    }

    User? user = await _storageHelper.getUser(username: userToken.username);

    if (user == null) {
      return emit(LuckyDrawFail(errorMsg: "用户还没登录"));
    }

    List<dynamic> drawRecord = user.drawRecord;

    drawRecord.insert(0, {"name": item, "dateTime": formattedDate});

    int currentDrawCount = user.drawCount - 1;

    User updatedUser =
        user.copyWith(drawCount: currentDrawCount, drawRecord: drawRecord);

    await _storageHelper.updateUser(user: updatedUser);

    return emit(LuckyDrawSuccess(
        drawRecord: updatedUser.drawRecord, drawCount: updatedUser.drawCount));
  }

  Future<void> getDrawRecord() async {
    User? userToken = await _storageHelper.getToken();

    if (userToken == null) {
      return emit(LuckyDrawFail(errorMsg: "用户还没登录"));
    }

    User? user = await _storageHelper.getUser(username: userToken.username);

    if (user == null) {
      return emit(LuckyDrawFail(errorMsg: "用户还没登录"));
    }

    return emit(LuckyDrawSuccess(
        drawRecord: user.drawRecord, drawCount: user.drawCount));
  }
}
