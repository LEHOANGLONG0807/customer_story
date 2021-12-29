import '../services/services.dart';
import '../models/models.dart';
import '../constants.dart';

abstract class ChapterRepository {
  Future<ListChapterTitlesModel> fetchChapterTitleById({required int storyId, int page = 0, limit = RESULT_LIMIT_CHAPTER});

  Future<ChapterContentModel> fetchChapterContentById({required int chapterId, required int storyId});
}

class ChapterRepositoryImpl implements ChapterRepository {
  final APIService apiService;

  ChapterRepositoryImpl({required this.apiService});

  @override
  Future<ListChapterTitlesModel> fetchChapterTitleById({required int storyId, int page = 1, limit = RESULT_LIMIT_CHAPTER}) async {
    try {
      final _response = await apiService.dio!.get('/stories/$storyId/ChapTitles', queryParameters: {
        'page': page,
        'limit': limit,
      });
      if (apiService.responseSuccess(_response)) {
        return ListChapterTitlesModel.fromJson(_response.data['data']);
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      return ListChapterTitlesModel(totalPages: 0, totalItems: 0, items: []);
    }
  }

  @override
  Future<ChapterContentModel> fetchChapterContentById({required int chapterId, required int storyId}) async {
    try {
      final _response = await apiService.dio!.get('/stories/$storyId/ChapContent/$chapterId');
      if (apiService.responseSuccess(_response)) {
        return ChapterContentModel.fromJson(_response.data['data']);
      }
      throw Exception(apiService.getError(_response));
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
