angular.module('mdme').controller('SessionsController', ['$scope', '$state', 'Auth', 'flare', function($scope, $state, Auth, flare) {
  if (Auth.isAuthenticated()) {
    $state.go('user.home');
  }
  $scope.signin = function() {
    if ($scope.signinForm.$valid) {
      $scope.errors = [];
      Auth.login($scope.user).success(function(result) {
        $state.go('user.home');
      }).error(function(err) {
        $scope.user = {};
        flare.error(err.error, 10000);
      });
    }
  };
}]);
