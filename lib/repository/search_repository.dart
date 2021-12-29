import '../services/services.dart';
import '../models/models.dart';
import '../constants.dart';

abstract class SearchRepository {
  Future<List<StoryModel>> searchStoryByTitle({required String title, int page = 1, limit = RESULT_LIMIT});
}

class SearchRepositoryImpl implements SearchRepository {
  final APIService apiService;

  SearchRepositoryImpl({required this.apiService});

  @override
  Future<List<StoryModel>> searchStoryByTitle({required String title, int page = 1, limit = RESULT_LIMIT}) async {
    try {
      final _response = await apiService.dio!.get('/stories/', queryParameters: {
        'title': title,
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
}
