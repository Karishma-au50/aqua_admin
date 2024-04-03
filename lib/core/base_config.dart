abstract class BaseConfig {
  String get baseUrl;
}

class Base extends BaseConfig {
  String apiHost = "https://api-dev.aquagenixpro.com/";
  @override
  String get baseUrl => "$apiHost/";
}
