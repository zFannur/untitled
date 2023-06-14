import 'package:easy_localization/easy_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:untitled/domain/use_case/operation_use_case.dart';

import '../entity/operation.dart';
import '../repository/local_repository.dart';
import '../repository/remote_repository.dart';

class OperationUseCaseImpl extends OperationUseCase {
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;

  OperationUseCaseImpl({
    required this.localRepository,
    required this.remoteRepository,
  });

  int getNewId() {
    return localRepository.getNewId();
  }

  @override
  Future<List<Operation>> addOperation({
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) async {
    final operation = Operation(
      action: 'put',
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: getNewId(),
    );

    localRepository.addOperation(operation);
    localRepository.addCache(operation);

    return await onSortOperation(localRepository.getOperation());
  }

  @override
  void deleteOperation(int index, int id) {
    final operation = Operation(
      action: 'del',
      date: '',
      type: '',
      form: '',
      sum: 0,
      note: '',
      id: id,
    );

    localRepository.deleteOperation(index);
    localRepository.addCache(operation);
  }

  @override
  List<Operation> editOperation({
    required int index,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) {
    final operation = Operation(
      action: 'edit',
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: id,
    );

    localRepository.editOperation(index, operation);
    localRepository.addCache(operation);
    return localRepository.getOperation();
  }

  @override
  Future<List<Operation>> getOperation() async {
    List<Operation> local = [];
    List<Operation> remote = [];

    try {
      local = await onSortOperation(localRepository.getOperation());

      final isConnect = await InternetConnectionChecker().hasConnection;

      if (isConnect) {
        remote = await onSortOperation(await remoteRepository.getOperation());
      }

      if (remote.isEmpty) {
        return local;
      } else if (local.length == remote.length) {
        return local;
      } else {
        await localRepository.deleteAllOperation();
        await localRepository.addOperationList(remote);
        return remote;
      }
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> sendOperation({
    required String action,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) async {
    String response;

    final operation = Operation(
      action: action,
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: id,
    );
    response = await remoteRepository.postOperation(operation);
    if (response == 'SUCCESS') {
      localRepository.deleteCache();
    }
  }

  @override
  List<Operation> getCache() {
    List<Operation> cache = localRepository.getCache();
    return cache;
  }

  Future<List<Operation>> onSortOperation(List<Operation> filter) async {
    if (filter.isNotEmpty) {
      int high = filter.length - 1;
      int low = 0;

      filter = _quickSort(filter, low, high);
    }
    return filter;
  }
}

List<Operation> _quickSort(List<Operation> list, int low, int high) {
  if (low < high) {
    int pi = _partition(list, low, high);
    _quickSort(list, low, pi - 1);
    _quickSort(list, pi + 1, high);
  }
  return list;
}

int _partition(List<Operation> list, low, high) {
  if (list.isEmpty) {
    return 0;
  }

  DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
  int pivot = dateFormat.parse(list[high].date).millisecondsSinceEpoch;
  int i = low - 1;
  for (int j = low; j < high; j++) {
    if (dateFormat.parse(list[j].date).millisecondsSinceEpoch > pivot) {
      i++;
      _swap(list, i, j);
    }
  }
  _swap(list, i + 1, high);
  return i + 1;
}

void _swap(List list, int i, int j) {
  Operation temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}
