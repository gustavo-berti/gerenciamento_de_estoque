import 'package:gerenciamento_de_estoque/data/dao/user_dao.dart';
import 'package:gerenciamento_de_estoque/domain/entities/user.dart';

class UserService {
  final UserDao _userDao = UserDao();

  // Obter todos os usuários
  Future<List<User>> getAllUsers() async {
    try {
      final List<Map<String, dynamic>> usersData = await _userDao.getAllUsers();
      return usersData.map((data) => User.fromMap(data)).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Obter usuário por ID
  Future<User?> getUserById(int id) async {
    try {
      final userData = await _userDao.getUserById(id);
      if (userData != null) {
        return User.fromMap(userData);
      }
      return null;
    } catch (e) {
      print('Error getting user by id: $e');
      return null;
    }
  }

  // Obter usuário por email
  Future<User?> getUserByEmail(String email) async {
    try {
      final userData = await _userDao.getUserByEmail(email);
      if (userData != null) {
        return User.fromMap(userData);
      }
      return null;
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }

  // Adicionar novo usuário
  Future<User?> addUser({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    try {
      // Verificar se email já existe
      final existingUser = await getUserByEmail(email);
      if (existingUser != null) {
        return null; // Email já existe
      }

      final user = User(
        name: name,
        email: email,
        password: password, // Em produção, fazer hash da senha
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final userId = await _userDao.insertUser(user.toMap());
      
      if (userId > 0) {
        return user.copyWith(id: userId);
      }
      return null;
    } catch (e) {
      print('Error adding user: $e');
      return null;
    }
  }

  // Atualizar usuário
  Future<bool> updateUser({
    required int userId,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      // Verificar se email já existe em outro usuário
      final existingUser = await getUserByEmail(email);
      if (existingUser != null && existingUser.id != userId) {
        return false; // Email já existe em outro usuário
      }

      final rowsAffected = await _userDao.updateUser(userId, {
        'name': name,
        'email': email,
        'role': role,
      });

      return rowsAffected > 0;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Atualizar senha do usuário
  Future<bool> updateUserPassword({
    required int userId,
    required String newPassword,
  }) async {
    try {
      final rowsAffected = await _userDao.updateUserPassword(
        userId, 
        newPassword, // Em produção, fazer hash da senha
      );
      return rowsAffected > 0;
    } catch (e) {
      print('Error updating user password: $e');
      return false;
    }
  }

  // Deletar usuário
  Future<bool> deleteUser(int userId) async {
    try {
      final rowsAffected = await _userDao.deleteUser(userId);
      return rowsAffected > 0;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Validar login de usuário
  Future<User?> validateUser(String email, String password) async {
    try {
      final isValid = await _userDao.validateUser(email, password);
      if (isValid) {
        return await getUserByEmail(email);
      }
      return null;
    } catch (e) {
      print('Error validating user: $e');
      return null;
    }
  }

  // Verificar se email existe
  Future<bool> emailExists(String email) async {
    try {
      return await _userDao.emailExists(email);
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }
}
