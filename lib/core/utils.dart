import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanizer/humanizer.dart';

String formatDateOfLastMessage(Timestamp timestamp) {
  var dateTime = timestamp.toDate();
  var dateNow = DateTime.now();
  var timeDiff = dateTime.difference(dateNow);
  return timeDiff.toApproximateTime();
}
