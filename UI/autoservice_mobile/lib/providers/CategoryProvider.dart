import '../../providers/baseProvider.dart';
import '../models/categoryModel.dart';

class CategoryProvider extends BaseProvider<CategoryModel> {
  CategoryProvider() : super('Category');

  @override
  CategoryModel fromJson(data) {
    return CategoryModel.fromJson(data);
  }
}
