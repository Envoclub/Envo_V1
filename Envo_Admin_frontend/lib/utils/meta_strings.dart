class MetaStrings {
  // static const String baseUrl = 'https://envo-d9c588a9830e.herokuapp.com';
  // static const String baseUrl = 'https://lfvuhgh1sa.execute-api.eu-west-1.amazonaws.com/dev';
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String loginEndPoint = '/accounts/login/';
  static const String getUserEndPoint = '/accounts/dj_rest_auth/user/';
  static const String activationEndPoint = '/auth/users/activation/';
  static const String resetPasswordConfirm ='/auth/users/reset_password_confirm/';
  static const String resetPasswordMail = '/auth/users/reset_password/';
  static const String co2ChartEndPoint = '/co2-saved/';
  static const String piechartEndPoint = '/activities/api/pie-chart/';
  static const String barchartEndPoint = '/activities/api/bar-chart/';
  static const String getAllEmployees = '/accounts/companies/1/employees/';
  static const String tileData = '/activities/api/tiles/';
  static const String addEmployee = '/dj-rest-auth/registration/';
  static const String deleteEmployee = '/accounts/delete-user/';

  static const String getPosts = '/activities/';
  static const String getMyPosts = '/activities/users/2/posts';
  static const String getLeaderBoard = '/accounts/leaders/';
  static const String likePost = '/activities/like/';
  static const String verifyPost = '/activities/verify/';
  static const String unLikePost = '/activities/unlike/';
  static const String getPostActions = '/game/sustainable-actions/';
  static const String getRewardsList = '/game/rewards/';
  static const String addReward='/accounts/add-rewards/';
  


}
