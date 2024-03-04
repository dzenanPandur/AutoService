import '../../providers/baseProvider.dart'; // Import the BaseProvider
import '../../models/Employee/categoryModel.dart';

class CategoryProvider extends BaseProvider<CategoryModel> {
  CategoryProvider() : super('Category');

  @override
  CategoryModel fromJson(data) {
    return CategoryModel.fromJson(data);
  }
}
