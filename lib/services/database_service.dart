import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import '../main.dart';
import '../models/models.dart';
import 'package:collection/collection.dart';

const STORY_HISTORY = "story_history";
const STORY_BOARD = "story_board";

class DBService {
  init() async {
    final document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);

    Hive.registerAdapter(StoryHistoryLocalModelAdapter());
    Hive.registerAdapter(StoryBoardLocalModelAdapter());
  }

  Future<bool> addStoryHistory({required StoryHistoryLocalModel model}) async {
    final box = await Hive.openBox<StoryHistoryLocalModel>(STORY_HISTORY);
    box.add(model);
    return true;
  }

  Future<bool> addStoryBoard({required StoryBoardLocalModel model}) async {
    await analytics.setUserProperty(name: ADD_STORY_BOARD, value: '${model.id}');
    await analytics.logEvent(name: EVENT_ADD_BOARD, parameters: {'id': model.id});
    final box = await Hive.openBox<StoryBoardLocalModel>(STORY_BOARD);
    box.add(model);
    return true;
  }

  Future<void> updateStoryHistory({required StoryHistoryLocalModel model}) async {
    final box = await Hive.openBox<StoryHistoryLocalModel>(STORY_HISTORY);
    final index = box.values.toList().indexWhere((element) => element.id == model.id);
    if (index >= 0) box.putAt(index, model);
  }

  Future<void> updateStoryBoard({required StoryBoardLocalModel model}) async {
    final box = await Hive.openBox<StoryBoardLocalModel>(STORY_BOARD);
    final index = box.values.toList().indexWhere((element) => element.id == model.id);
    if (index >= 0) box.putAt(index, model);
  }

  Future<List<StoryBoardLocalModel>> getListStoryBoard({int limit = 10}) async {
    final box = await Hive.openBox<StoryBoardLocalModel>(STORY_BOARD);
    final data = box.values.take(limit).toList();
    return data;
  }

  Future<List<StoryHistoryLocalModel>> getListStoryHistory({int limit = 10}) async {
    final box = await Hive.openBox<StoryHistoryLocalModel>(STORY_HISTORY);
    final data = box.values.take(limit).toList();
    return data;
  }

  Future<bool> deleteStoryHistoryById({required int storyId}) async {
    final box = await Hive.openBox<StoryHistoryLocalModel>(STORY_HISTORY);
    final index = box.values.toList().indexWhere((element) => element.id == storyId);
    if (index >= 0) box.deleteAt(index);
    return true;
  }

  Future<bool> deleteStoryBoardById({required int storyId}) async {
    final box = await Hive.openBox<StoryBoardLocalModel>(STORY_BOARD);
    final index = box.values.toList().indexWhere((element) => element.id == storyId);
    if (index >= 0) box.deleteAt(index);
    return true;
  }

  Future<StoryBoardLocalModel?> getStoryBoardById({required int storyId}) async {
    final box = await Hive.openBox<StoryBoardLocalModel>(STORY_BOARD);
    return box.values.toList().firstWhereOrNull((element) => element.id == storyId);
  }

  Future<StoryHistoryLocalModel?> getStoryHistoryById({required int storyId}) async {
    final box = await Hive.openBox<StoryHistoryLocalModel>(STORY_HISTORY);
    return box.values.toList().firstWhereOrNull((element) => element.id == storyId);
  }
}
