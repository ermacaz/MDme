angular.module('mdme-admin').controller('AdminsAppointmentsController',
  ['$scope', '$state', 'AdminAuthInterceptor', '$http', 'flare',
  function($scope, $state, AdminAuthInterceptor, $http, flare) {

  if ($state.current.name == 'admin.appointments') {
    var todaysApptsReq = {
      method: 'GET',
      url: '/admins.json',
      headers: $http.defaults.headers.common
    };
    todaysApptsReq = AdminAuthInterceptor.request(todaysApptsReq);
    $http(todaysApptsReq)
      .success(function(data) {
        $scope.appointments = data.appointments;
      })
      .error(function(err) {
        console.log(err);
      });
  }

}]);