import 'package:get/get.dart';
import '../pages/pages.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      bindings: [
        BindingsBuilder.put(() => SplashController()),
      ],
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => MainPage(),
      bindings: [
        BindingsBuilder.put(() => MainController()),
        BindingsBuilder.put(() => StoryBoardController(dbService: Get.find())),
        BindingsBuilder.put(() => ClassifyController()),
        BindingsBuilder.put(() => HistoryReadingController(dbService: Get.find())),
      ],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      bindings: [
        BindingsBuilder.put(() => HomeController(repository: Get.find(), dbService: Get.find())),
      ],
    ),
    GetPage(
      name: Routes.CLASSIFY,
      page: () => ClassifyPage(),
      bindings: [
        BindingsBuilder.put(() => ClassifyController()),
      ],
    ),
    GetPage(
      name: Routes.LIST_STORY,
      page: () => ListStoryPage(),
      bindings: [
        BindingsBuilder.put(() => ListStoryController(homeRepository: Get.find())),
      ],
    ),
    GetPage(
      name: Routes.STORY_BOARD,
      page: () => StoryBoardPage(),
      bindings: [
        BindingsBuilder.put(() => StoryBoardController(dbService: Get.find())),
      ],
    ),
    GetPage(
      name: Routes.HISTORY_READING,
      page: () => HistoryReadingPage(),
      bindings: [
        BindingsBuilder.put(() => HistoryReadingController(dbService: Get.find())),
      ],
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchPage(),
      bindings: [
        BindingsBuilder.put(() => SearchController(searchRepository: Get.find(), homeRepository: Get.find())),
      ],
    ),
    GetPage(
      name: Routes.DETAIL_STORY,
      page: () => DetailStoryPage(),
      bindings: [
        BindingsBuilder.put(() => DetailStoryController(storyRepository: Get.find(), chapterRepository: Get.find(), dbService: Get.find())),
      ],
    ),
    GetPage(
      name: Routes.READING_STORY,
      page: () => ReadStoryPage(),
      bindings: [
        BindingsBuilder.put(() => ReadStoryController(chapterRepository: Get.find(), storyRepository: Get.find(), dbService: Get.find())),
      ],
    ),
  ];
}
