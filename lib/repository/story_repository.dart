import 'package:get/get.dart';
import 'package:truyen_chu/biz/biz.dart';
import '../models/models.dart';
import '../services/services.dart';

import '../constants.dart';

abstract class StoryRepository {
  Future<List<StoryModel>> fetchStoryHotByTagId({required int tagId});

  Future<List<StoryModel>> fetchStoryUpdatedByTagId({required int tagId});

  Future<List<StoryModel>> fetchStoryFullByTagId({required int tagId});

  Future<List<StoryModel>> fetchStoryNewByTagId({required int tagId});

  Future<StoryModel?> getStoryById({required int id});

  Future<bool> reviewStory({required int storyId, required int star});

  Future<bool> feedbackStoryListen();

  Future<bool> feedbackStorySearch({required String key});

  Future<List<StoryModel>> fetchStoryByURL({required String url, int page = 0, limit = RESULT_LIMIT});

  Future<List<TagModel>> fetchAllTags();
}

class StoryRepositoryImpl implements StoryRepository {
  final APIService apiService;

  StoryRepositoryImpl({required this.apiService});

  final _appController = Get.find<AppController>();

  @override
  Future<List<StoryModel>> fetchStoryHotByTagId({required int tagId, int limit = 24}) async {
    try {
      final _response = await apiService.dio!.get('/stories/hot/?tag_id=$tagId&page=1&limit=$limit');
      if (apiService.responseSuccess(_response)) {
        return List<StoryModel>.from(_response.data['data']['items'].map((x) => StoryModel.fromJson(x)));
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<StoryModel>> fetchStoryFullByTagId({required int tagId}) async {
    try {
      final _response = await apiService.dio!.get('/stories/full/?tag_id=$tagId&page=1&limit=24');
      if (apiService.responseSuccess(_response)) {
        return List<StoryModel>.from(_response.data['data']['items'].map((x) => StoryModel.fromJson(x)));
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<StoryModel>> fetchStoryNewByTagId({required int tagId}) async {
    try {
      final _response = await apiService.dio!.get('/stories/new/?tag_id=$tagId&page=1&limit=24');
      if (apiService.responseSuccess(_response)) {
        return List<StoryModel>.from(_response.data['data']['items'].map((x) => StoryModel.fromJson(x)));
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<StoryModel>> fetchStoryUpdatedByTagId({required int tagId}) async {
    try {
      final _response = await apiService.dio!.get('/stories/updated/?tag_id=$tagId&page=1&limit=24');
      if (apiService.responseSuccess(_response)) {
        return List<StoryModel>.from(_response.data['data']['items'].map((x) => StoryModel.fromJson(x)));
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<TagModel>> fetchAllTags() async {
    try {
      final _response = await apiService.dio!.get('/tags?page=1&limit=100&sort=Id asc');
      if (apiService.responseSuccess(_response)) {
        return List<TagModel>.from(_response.data['data']['items'].map((x) => TagModel.fromJson(x)));
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<StoryModel>> fetchStoryByURL({required String url, int page = 1, limit = RESULT_LIMIT}) async {
    try {
      final _response = await apiService.dio!.get('$url', queryParameters: {
        'page': page,
        'limit': limit,
      });
      if (apiService.responseSuccess(_response)) {
        return List<StoryModel>.from((_response.data['data']['items'] ?? []).map((x) => StoryModel.fromJson(x)));
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<StoryModel?> getStoryById({required int id}) async {
    try {
      final _response = await apiService.dio!.get('/stories/$id?user_id=${_appController.deviceId ?? ''}');
      if (apiService.responseSuccess(_response)) {
        return StoryModel.fromJson(_response.data['data']);
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<bool> reviewStory({required int storyId, required int star}) async {
    try {
      final _response = await apiService.dio!.put(
        '/stories/$storyId/rate',
        data: {"user_id": _appController.deviceId ?? '', "star": star},
      );
      return apiService.responseSuccess(_response);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<bool> feedbackStoryListen() async {
    try {
      final _response = await apiService.dio!.post(
        '/feedbacks/story_listen/',
        queryParameters: {"user_id": _appController.deviceId ?? ''},
      );
      return apiService.responseSuccess(_response);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<bool> feedbackStorySearch({required String key}) async {
    try {
      final _response = await apiService.dio!.post(
        '/feedbacks/story_search/',
        queryParameters: {"user_id": _appController.deviceId ?? '', 'story_name': key},
      );
      return apiService.responseSuccess(_response);
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
