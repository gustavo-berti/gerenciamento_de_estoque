import 'package:gerenciamento_de_estoque/data/dao/city_dao.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';

class CityService {
  final CityDao _cityDao = CityDao();

  Future<List<City>> getAllCities() async {
    try {
      return await _cityDao.getAllCities();
    } catch (e) {
      print('Error getting cities: $e');
      return [];
    }
  }

  Future<List<City>> getCitiesByState(int stateId) async {
    try {
      return await _cityDao.getCitiesByState(stateId);
    } catch (e) {
      print('Error getting cities by state: $e');
      return [];
    }
  }

  Future<City?> getCityById(int id) async {
    try {
      return await _cityDao.getCityById(id);
    } catch (e) {
      print('Error getting city by id: $e');
      return null;
    }
  }

  Future<City?> getCityByNameAndState(String name, int stateId) async {
    try {
      return await _cityDao.getCityByNameAndState(name, stateId);
    } catch (e) {
      print('Error getting city by name and state: $e');
      return null;
    }
  }

  Future<City?> addCity({
    required String name,
    required int stateId,
  }) async {
    try {
      final city = City(
        name: name,
        stateId: stateId,
      );
      final id = await _cityDao.insertCity(city);
      return city.copyWith(id: id);
    } catch (e) {
      print('Error adding city: $e');
      return null;
    }
  }

  Future<bool> updateCity(City city) async {
    try {
      await _cityDao.updateCity(city);
      return true;
    } catch (e) {
      print('Error updating city: $e');
      return false;
    }
  }

  Future<bool> deleteCity(int id) async {
    try {
      await _cityDao.deleteCity(id);
      return true;
    } catch (e) {
      print('Error deleting city: $e');
      return false;
    }
  }

  Future<bool> canDeleteCity(int id) async {
    try {
      return !(await _cityDao.hasCities(id));
    } catch (e) {
      print('Error checking if city can be deleted: $e');
      return false;
    }
  }
}
