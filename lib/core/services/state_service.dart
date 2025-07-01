import 'package:gerenciamento_de_estoque/data/dao/state_dao.dart';
import 'package:gerenciamento_de_estoque/domain/entities/state.dart';

class StateService {
  final StateDao _stateDao = StateDao();

  Future<List<State>> getAllStates() async {
    try {
      return await _stateDao.getAllStates();
    } catch (e) {
      print('Error getting states: $e');
      return [];
    }
  }

  Future<List<State>> getStatesByCountry(int countryId) async {
    try {
      return await _stateDao.getStatesByCountry(countryId);
    } catch (e) {
      print('Error getting states by country: $e');
      return [];
    }
  }

  Future<State?> getStateById(int id) async {
    try {
      return await _stateDao.getStateById(id);
    } catch (e) {
      print('Error getting state by id: $e');
      return null;
    }
  }

  Future<State?> getStateByNameAndCountry(String name, int countryId) async {
    try {
      return await _stateDao.getStateByNameAndCountry(name, countryId);
    } catch (e) {
      print('Error getting state by name and country: $e');
      return null;
    }
  }

  Future<State?> addState({
    required String name,
    required String acronym,
    required int countryId,
  }) async {
    try {
      final state = State(
        name: name,
        acronym: acronym,
        countryId: countryId,
      );
      final id = await _stateDao.insertState(state);
      return state.copyWith(id: id);
    } catch (e) {
      print('Error adding state: $e');
      return null;
    }
  }

  Future<bool> updateState(State state) async {
    try {
      await _stateDao.updateState(state);
      return true;
    } catch (e) {
      print('Error updating state: $e');
      return false;
    }
  }

  Future<bool> deleteState(int id) async {
    try {
      await _stateDao.deleteState(id);
      return true;
    } catch (e) {
      print('Error deleting state: $e');
      return false;
    }
  }

  Future<bool> canDeleteState(int id) async {
    try {
      return !(await _stateDao.hasCities(id));
    } catch (e) {
      print('Error checking if state can be deleted: $e');
      return false;
    }
  }
}
