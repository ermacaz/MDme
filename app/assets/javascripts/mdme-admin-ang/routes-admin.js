angular.module('mdme-admin')
  .config(['$stateProvider', '$urlRouterProvider', 'AccessLevels', function($stateProvider, $urlRouterProvider, AccessLevels) {

    $stateProvider
      .state('anon', {
        abstract: true,
        templateUrl: "admins/anon.html",
        data: {
          access: AccessLevels.anon
        }
      })
      .state('anon.signin', {
        url: '/',
        templateUrl: 'admins/signin.html',
        controller: 'AdminSessionsController'
      });

    $stateProvider
      .state('admin', {
        abstract: true,
        templateUrl: 'admins/_menu.html',
        data: {
          access: AccessLevels.admin
        }
      })
      .state('admin.home', {
        url: '/admins',
        templateUrl: 'admins/index.html',
        controller: 'AdminsController'
      })
      .state('admin.appointmentDelays', {
        url: '/admins/:adminId/appointments/delays',
        templateUrl: 'admins/appointments/delays.html',
        controller: 'AdminsAppointmentDelaysController'
      })
      .state('admin.appointmentRequests', {
        url: '/admins/:adminId/appointments/requests',
        templateUrl: 'admins/appointments/requests.html',
        controller: 'AdminsAppointmentRequestsController'
      })
      .state('admin.appointmentRequestsOthers', {
        url: '/ondate/:date?doctor_id',
        templateUrl: 'admins/appointments/_show_on_date.html',
        controller: 'AdminsAppointmentRequestsOthersController',
        parent: 'admin.appointmentRequests'
      })
      .state('admin.appointmentsBrowse', {
        url: '/admins/:adminId/appointments/browse',
        templateUrl: 'admins/appointments/browse.html',
        controller: 'AdminsAppointmentsController'
      })
      .state('admin.appointmentNew', {
        url: '/admins/:adminId/appointments/new',
        templateUrl: 'admins/appointments/new.html',
        controller: 'AdminsAppointmentCreateController'
      })
      .state('admin.appointment', {
        url: '/admins/:adminId/appointments/:appointmentId',
        templateUrl: 'admins/appointments/show.html',
        controller: 'AdminsAppointmentController'
      })
      .state('admin.appointmentEdit', {
        url: '/admins/:adminId/appointments/:appointmentId/edit',
        templateUrl: 'admins/appointments/edit.html',
        controller: 'AdminsAppointmentController'
      })
      .state('admin.appointments', {
        url: '/admins/:adminId/appointments',
        templateUrl: 'admins/appointments/index.html',
        controller: 'AdminsAppointmentsController'
      })
      .state('admin.doctors', {
        url: '/admins/:adminId/doctors',
        templateUrl: 'admins/doctors/index.html',
        controller: 'AdminsDoctorsController'
      });
    $urlRouterProvider.otherwise('/');
  }]);