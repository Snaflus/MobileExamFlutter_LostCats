import 'package:intl/intl.dart' as intl;

class Cat {
  final int id;
  final String name;
  final String description;
  final String place;
  final int reward;
  final String userId;
  final int date;
  final String? pictureUrl;

  Cat.json(
      this.id,
      this.name,
      this.description,
      this.place,
      this.reward,
      this.userId,
      this.date,
      this.pictureUrl);

  Cat.create(
      this.name,
      this.description,
      this.place,
      this.reward,
      this.userId,
      this.pictureUrl):
        id = -1,
        date = (DateTime.now().millisecondsSinceEpoch/1000).floor(); //API stores time in unix seconds

  Cat.createWithoutPicture(
      this.name,
      this.description,
      this.place,
      this.reward,
      this.userId):
        id = -1,
        date = (DateTime.now().millisecondsSinceEpoch/1000).floor(), //API stores time in unix seconds
        pictureUrl = null;

  // Map toJson() =>{
  //
  // };

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat.json(json['id'],json['name'],json['description'],json['place'],json['reward'],json['userId'],json['date'],json['pictureUrl']
    );
  }

  @override
  String toString() {
    return "ID:$id, Title:$name, Description:$description, Place:$place, Reward:$reward, UserID:$userId, Date:$date";
  }

  String humanDate() {
    int unix = date * 1000; //convert back to proper unix from API-unix
    DateTime time = DateTime.fromMillisecondsSinceEpoch(unix, isUtc: true);
    return intl.DateFormat.yMMMMEEEEd('da_DK').format(time);
  }
}
