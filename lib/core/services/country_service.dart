import 'package:gerenciamento_de_estoque/data/dao/country_dao.dart';
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';

class CountryService {
  final CountryDao _countryDao = CountryDao();

  Future<List<Country>> getAllCountries() async {
    try {
      return await _countryDao.getAllCountries();
    } catch (e) {
      print('Error getting countries: $e');
      return [];
    }
  }

  Future<Country?> getCountryById(int id) async {
    try {
      return await _countryDao.getCountryById(id);
    } catch (e) {
      print('Error getting country by id: $e');
      return null;
    }
  }

  Future<Country?> getCountryByName(String name) async {
    try {
      return await _countryDao.getCountryByName(name);
    } catch (e) {
      print('Error getting country by name: $e');
      return null;
    }
  }

  Future<Country?> addCountry(String name) async {
    try {
      final country = Country(name: name);
      final id = await _countryDao.insertCountry(country);
      return country.copyWith(id: id);
    } catch (e) {
      print('Error adding country: $e');
      return null;
    }
  }

  Future<bool> updateCountry(Country country) async {
    try {
      await _countryDao.updateCountry(country.id!, country);
      return true;
    } catch (e) {
      print('Error updating country: $e');
      return false;
    }
  }

  Future<bool> deleteCountry(int id) async {
    try {
      await _countryDao.deleteCountry(id);
      return true;
    } catch (e) {
      print('Error deleting country: $e');
      return false;
    }
  }

  Future<bool> canDeleteCountry(int id) async {
    try {
      return !(await _countryDao.hasStates(id));
    } catch (e) {
      print('Error checking if country can be deleted: $e');
      return false;
    }
  }
}
