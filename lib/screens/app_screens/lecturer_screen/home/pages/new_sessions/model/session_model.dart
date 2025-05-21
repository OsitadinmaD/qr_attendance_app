
class SessionModel {
  const SessionModel({
    required this.sessionName,
    required this.dateTime,
    required this.joinEndDateTime,
    required this.joinStartDateTime,
    required this.joindateTime,
    required this.qrID
  });

  final String sessionName, dateTime;
  final String joindateTime, joinStartDateTime,joinEndDateTime,qrID;

  factory SessionModel.fromMap(Map<String, dynamic> session, String sessionID){
    return SessionModel(
      sessionName: session['sessionName'] ?? '', 
      dateTime: session['dateTime'] ?? '', 
      joinEndDateTime: session['joinEndDateTime'] ?? '', 
      joinStartDateTime: session['joinStartDateTime'] ?? '', 
      joindateTime: session['joindateTime'] ?? '', 
      qrID: session['qrID'] ?? ''
    );
  }

}