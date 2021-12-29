import 'package:get/get.dart';
import 'package:truyen_chu/constants.dart';
import 'package:truyen_chu/repository/repository.dart';
import '../../biz/biz.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../routes/routes.dart';

class ClassifyController extends GetxController {
  StoryRepository get _repository => Get.find();

  final appController = Get.find<AppController>();

  final mainCategory = <TagModel>[].obs;

  final subCategory = <TagModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    mainCategory.value = appController.mainCategory;
    subCategory.value = appController.subCategory;
  }

  void onTapItemCategory(TagModel model) async {
    await analytics.setUserProperty(name: TAG_STORY, value: '${model.id}');
    await analytics.logEvent(name: EVENT_LIST_BY_TAG, parameters: {'id': model.id});
    Get.toNamed(Routes.LIST_STORY, arguments: {'title': model.name ?? '', 'url': '/stories/?tag_id=${model.id}'});
  }

  void onTapItemTag(TagModel model) async {
    await analytics.setUserProperty(name: SUGGEST_TAG_STORY, value: '${model.id}');
    await analytics.logEvent(name: EVENT_LIST_BY_SUGGEST_TAG, parameters: {'id': model.id});
    Get.toNamed(Routes.LIST_STORY, arguments: {'title': model.name ?? '', 'url': '/stories/suggest/?tag_id=${model.id}'});
  }

  void feedBackStoryListen() {
    try {
      _repository.feedbackStoryListen();
    } catch (e) {
      print(e);
    }
  }

  final suggestTags = [
    TagModel(id: 1, name: 'Truyện mới cập nhật'),
    TagModel(id: 2, name: 'Truyện Hot'),
    TagModel(id: 3, name: 'Truyện Full'),
    TagModel(id: 4, name: 'Tiên Hiệp Hay'),
    TagModel(id: 5, name: 'Kiếm Hiệp Hay'),
    TagModel(id: 6, name: 'Truyện Teen Hay'),
    TagModel(id: 7, name: 'Ngôn Tình Hay'),
    TagModel(id: 8, name: 'Ngôn Tình Sắc'),
    TagModel(id: 9, name: 'Ngôn Tình Ngược'),
    TagModel(id: 10, name: 'Ngôn Tình Sủng'),
    TagModel(id: 11, name: 'Ngôn Tình Hài'),
    TagModel(id: 12, name: 'Đam Mỹ Hài'),
    TagModel(id: 13, name: 'Đam Mỹ Hay'),
    TagModel(id: 14, name: 'Đam Mỹ H Văn'),
    TagModel(id: 15, name: 'Đam Mỹ Sắc'),
  ];
}
