angular.module('mdme-admin').controller('AdminsAppointmentRequestsOthersController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AdminAuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AdminAuthInterceptor, flare) {
  var dateReq = {
    method: 'GET',
    url: '/admins/' + $stateParams.adminId + '/appointments/requests/ondate/' + $stateParams.date + '.json?doctor_id=' + $stateParams.doctor_id,
    headers: $http.defaults.headers.common
  };
  dateReq = AdminAuthInterceptor.request(dateReq);
  $http(dateReq)
    .success(function(data) {
      $scope.otherDateAppts = data.appointments;
      $scope.date = data.date;
      $scope.doctor = data.doctor;
      var oneFourth = Math.ceil($(window).width() / 4);
      angular.element('div.popup-window').css({
        left: oneFourth,
        width: 2 * oneFourth,
        top: 20,
        position: 'fixed'
      }).show();
    });

  $scope.closePopup = function() {
      angular.element('div.popup-window').hide();
  }
}]);