import 'package:fluttertoast/fluttertoast.dart';
import 'package:manga/colors/app_color.dart';

enum Status { error, success }

void toastInfo({required String msg, required Status status}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: status == Status.error
        ? AppColors.error
        : AppColors.background,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
  );
}
