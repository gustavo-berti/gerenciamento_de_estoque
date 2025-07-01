import 'package:gerenciamento_de_estoque/data/dao/category_dao.dart';
import 'package:gerenciamento_de_estoque/domain/entities/category.dart';

class CategoryService {
  final CategoryDao _categoryDao = CategoryDao();

  Future<List<Category>> getAllCategories() async {
    try {
      return await _categoryDao.getAllCategories();
    } catch (e) {
      print('Erro ao buscar categorias: $e');
      rethrow;
    }
  }

  Future<Category?> getCategoryById(int id) async {
    try {
      return await _categoryDao.getCategoryById(id);
    } catch (e) {
      print('Erro ao buscar categoria por ID: $e');
      rethrow;
    }
  }

  Future<Category?> getCategoryByName(String name) async {
    try {
      return await _categoryDao.getCategoryByName(name);
    } catch (e) {
      print('Erro ao buscar categoria por nome: $e');
      rethrow;
    }
  }

  Future<Category> addCategory(Category category) async {
    try {
      // Validações
      final validationResult = _validateCategory(category);
      if (validationResult != null) {
        throw Exception(validationResult);
      }

      // Verifica se já existe categoria com o mesmo nome
      final existingByName = await _categoryDao.getCategoryByName(category.name);
      if (existingByName != null) {
        throw Exception('Já existe uma categoria com este nome');
      }

      final id = await _categoryDao.insertCategory(category);
      return category.copyWith(id: id);
    } catch (e) {
      print('Erro ao adicionar categoria: $e');
      rethrow;
    }
  }

  Future<Category> updateCategory(int id, Category category) async {
    try {
      // Validações
      final validationResult = _validateCategory(category);
      if (validationResult != null) {
        throw Exception(validationResult);
      }

      // Verifica se existe
      final existing = await _categoryDao.getCategoryById(id);
      if (existing == null) {
        throw Exception('Categoria não encontrada');
      }

      // Verifica se não existe outra categoria com o mesmo nome
      final existingByName = await _categoryDao.getCategoryByName(category.name);
      if (existingByName != null && existingByName.id != id) {
        throw Exception('Já existe uma categoria com este nome');
      }

      await _categoryDao.updateCategory(id, category);
      return category.copyWith(id: id);
    } catch (e) {
      print('Erro ao atualizar categoria: $e');
      rethrow;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      final existing = await _categoryDao.getCategoryById(id);
      if (existing == null) {
        throw Exception('Categoria não encontrada');
      }

      final result = await _categoryDao.deleteCategory(id);
      return result > 0;
    } catch (e) {
      print('Erro ao deletar categoria: $e');
      rethrow;
    }
  }

  Future<List<String>> getCategoryNames() async {
    try {
      return await _categoryDao.getCategoryNames();
    } catch (e) {
      print('Erro ao buscar nomes das categorias: $e');
      rethrow;
    }
  }

  String? _validateCategory(Category category) {
    if (category.name.trim().isEmpty) {
      return 'Nome da categoria é obrigatório';
    }

    if (category.name.trim().length < 2) {
      return 'Nome da categoria deve ter pelo menos 2 caracteres';
    }

    if (category.description.trim().isEmpty) {
      return 'Descrição da categoria é obrigatória';
    }

    if (category.description.trim().length < 5) {
      return 'Descrição da categoria deve ter pelo menos 5 caracteres';
    }

    if (category.acronym.trim().isEmpty) {
      return 'Sigla da categoria é obrigatória';
    }

    if (category.acronym.trim().length < 2 || category.acronym.trim().length > 5) {
      return 'Sigla da categoria deve ter entre 2 e 5 caracteres';
    }

    // Verifica se a sigla contém apenas letras
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(category.acronym.trim())) {
      return 'Sigla deve conter apenas letras';
    }

    return null;
  }

  Future<bool> categoryNameExists(String name, {int? excludeId}) async {
    try {
      final existing = await _categoryDao.getCategoryByName(name);
      if (existing == null) return false;
      
      if (excludeId != null && existing.id == excludeId) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('Erro ao verificar se nome da categoria existe: $e');
      return false;
    }
  }
}
