import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../utils/constants.dart';
import '../../utils/toast.dart';
import '../model/user_model.dart';

class HomePageController extends GetxController {
  final dioClient = DioClient(BASE_URL, Dio());
  
  RxBool isLoading = false.obs;
  RxList<UserModel> userList = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    isLoading(true);
    try {
      final res = await dioClient.get("posts");
      
      // Assuming the response is a list of users
      userList.value = (res as List).map((item) => UserModel.fromJson(item)).toList();
    } catch (e) {
      Toast.errorToast("Failed", "$e");
    } finally {
      isLoading(false);
    }
  }
}
