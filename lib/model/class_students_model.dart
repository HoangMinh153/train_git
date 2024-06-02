class ClassStudent {
  int id;
  String studentid;
  String classid;
  String teacherid;

  ClassStudent({
    required this.id,
    required this.studentid,
    required this.classid,
    required this.teacherid,
  });

  factory ClassStudent.fromJson(List<dynamic> json) {
    return ClassStudent(
      id: json[0],
      classid: json[1],
      studentid: json[2],
      teacherid: json[3],
    );
  }
}

List<ClassStudent> globalClassStudentList = [];
