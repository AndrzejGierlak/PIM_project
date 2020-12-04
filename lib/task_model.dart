class Task {
  int id;
  String name;
  int color;
  String salary;
  String description;

  Task({this.id, this.name, this.color, this.salary, this.description}) {
    id = DateTime.now().millisecondsSinceEpoch;
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    salary = json['salary'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['salary'] = this.salary;
    data['description'] = this.description;
    return data;
  }

  String toString() {
    return '"Task" : { "id": $id, '
        '"name": $name, '
        '"color": $color,'
        '"salary": $salary,'
        '"description": $description,'
        '}';
  }
}