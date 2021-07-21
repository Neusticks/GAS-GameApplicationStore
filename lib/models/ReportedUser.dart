
import 'Base.dart';

class ReportedUser extends Model {

  static const String REPORTED_USER_NAME_KEY = "userName";
  static const String USER_REPORTED_KEY = "reportedUser";
  static const String REPORTED_USER_PROBLEM_DESCRIPTION_KEY = "problemDescription";
  static const String REPORTED_USER_DATE_KEY = "reportedDate";

  String reportedUser;
  String problemDescription;
  String userName;
  String reportedDate;

  ReportedUser(
      {String id,
        this.userName,
        this.reportedUser,
        this.reportedDate,
        this.problemDescription,
      }) : super(id);

  factory ReportedUser.fromMap(Map<String, dynamic> map, {String id}) {
    return ReportedUser(
      id: id,
      userName: map[REPORTED_USER_NAME_KEY],
      reportedUser: map[USER_REPORTED_KEY],
      reportedDate: map[REPORTED_USER_DATE_KEY],
      problemDescription: map[REPORTED_USER_PROBLEM_DESCRIPTION_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      REPORTED_USER_NAME_KEY: userName,
      USER_REPORTED_KEY: reportedUser,
      REPORTED_USER_DATE_KEY: reportedDate,
      REPORTED_USER_PROBLEM_DESCRIPTION_KEY: problemDescription,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (userName != null) map[REPORTED_USER_NAME_KEY] = userName;
    if (reportedUser != null) map[USER_REPORTED_KEY] = reportedUser;
    if (reportedDate != null) map[REPORTED_USER_DATE_KEY] = reportedDate;
    if (problemDescription != null) map[REPORTED_USER_PROBLEM_DESCRIPTION_KEY] = problemDescription;

    return map;
  }
}