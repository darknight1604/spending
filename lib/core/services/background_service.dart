abstract class BackgroundService {
  Future perform();
}

class DaniBackgroundService {
  late List<BackgroundService> listService = [];

  Future perform() async {
    listService.forEach((element) async {
      await element.perform();
    });
  }

  void register(BackgroundService service) => listService.add(service);
}
