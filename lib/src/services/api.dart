
class BaseURLConfig {

  static const String ipAddress = "34.100.163.77";
  
  // login 3002
  static const String loginApiURL = "http://$ipAddress:3002/api/users/login";

  // users 3002
  static const String usersApiURL = "http://$ipAddress:3002/api/users";

  // Chargers 3003
  static const String chargersApiURL = "http://$ipAddress:3003/api/charging-points";

  // transactions 3004
  static const String billingsApiURL = "http://$ipAddress:3004/api/transactions";

  // communities 3005
  static const String communitiesApiURL = "http://$ipAddress:3005/api/organizations";

  // revenue
  static const String revenueApiURL = "http://$ipAddress:3004/api/transactions/users/cost";

  //power consumption
  static const String powerConsumeApiURL = "http://$ipAddress:3004/api/transactions/users/energyconsumed";

}