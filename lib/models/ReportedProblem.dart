

import 'Base.dart';

class ReportedProblem extends Model {

  static const String REPORTED_PROBLEM_USER_NAME_KEY = "userName";
  static const String REPORTED_PROBLEM_DESCRIPTION_KEY = "problemDescription";
  static const String REPORTED_PROBLEM_DATE_KEY = "reportedDate";

  String problemDescription;
  String userName;
  String reportedDate;

  ReportedProblem(
      {String id,
        this.userName,
        this.reportedDate,
        this.problemDescription,
      }) : super(id);

  factory ReportedProblem.fromMap(Map<String, dynamic> map, {String id}) {
    return ReportedProblem(
      id: id,
      userName: map[REPORTED_PROBLEM_USER_NAME_KEY],
      reportedDate: map[REPORTED_PROBLEM_DATE_KEY],
      problemDescription: map[REPORTED_PROBLEM_DESCRIPTION_KEY],
      );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      REPORTED_PROBLEM_USER_NAME_KEY: userName,
      REPORTED_PROBLEM_DATE_KEY: reportedDate,
      REPORTED_PROBLEM_DESCRIPTION_KEY: problemDescription,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (userName != null) map[REPORTED_PROBLEM_USER_NAME_KEY] = userName;
    if (reportedDate != null) map[REPORTED_PROBLEM_DATE_KEY] = reportedDate;
    if (problemDescription != null) map[REPORTED_PROBLEM_DESCRIPTION_KEY] = problemDescription;

    return map;
  }
}