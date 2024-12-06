# stationeryhub_attendance
Attendance app

## Old flow
* Insert phone number
* Search in user list
    * If present, navigate to appropriate screen according to user type
    * If not, option to create organization or notify employee to ask for access from employe

## new flow
*  Ask user type
  *  If employer
     * phone number authentication
     * search organization in 'organizations' collection by collection name as employer's Firebase UID
     * if present, fetch data and redirect to AdminDashboardScreen
     * If not, create new organization inside 'organizations' collection with doc name same as employer's Firebase UID
