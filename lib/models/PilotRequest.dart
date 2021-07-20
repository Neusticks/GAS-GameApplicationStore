import 'package:enum_to_string/enum_to_string.dart';

import 'Base.dart';

enum GameList {
  MobileLegend,
  PUBGMobile,
  ArenaOfValor,
}

class PilotRequest extends Model {

  static const String PILOT_REQUEST_GAME_ID_KEY = "gameId";
  static const String PILOT_REQUEST_USER_NAME_KEY = "userName";
  static const String PILOT_REQUEST_USER_PHONE_KEY = "userPhone";
  static const String PILOT_REQUEST_GAME_NAME_KEY = "gameName";
  static const String PILOT_REQUEST_STATUS_KEY = "requestStatus";

  String gameId;
  String userName;
  String userPhone;
  String requestStatus;
  GameList gameName;

  PilotRequest(
    String id, {
    this.gameId,
    this.userName,
    this.userPhone,
    this.gameName,
    this.requestStatus = "Not Finished",
  }) : super(id);

  factory PilotRequest.fromMap(Map<String, dynamic> map, {String id}) {
    return PilotRequest(
      id,
      gameId: map[PILOT_REQUEST_GAME_ID_KEY],
      userName: map[PILOT_REQUEST_USER_NAME_KEY],
      userPhone: map[PILOT_REQUEST_USER_PHONE_KEY],
      requestStatus: map[PILOT_REQUEST_STATUS_KEY],
      gameName:
          EnumToString.fromString(GameList.values, map[PILOT_REQUEST_GAME_NAME_KEY]),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PILOT_REQUEST_GAME_ID_KEY: gameId,
      PILOT_REQUEST_USER_NAME_KEY: userName,
      PILOT_REQUEST_USER_PHONE_KEY: userPhone,
      PILOT_REQUEST_STATUS_KEY: requestStatus,
      PILOT_REQUEST_GAME_NAME_KEY: EnumToString.convertToString(gameName),
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (gameId != null) map[PILOT_REQUEST_GAME_ID_KEY] = gameId;
    if (userName != null) map[PILOT_REQUEST_USER_NAME_KEY] = userName;
    if (userPhone != null) map[PILOT_REQUEST_USER_PHONE_KEY] = userPhone;
    if (requestStatus != null) map[PILOT_REQUEST_STATUS_KEY] = requestStatus;
    if (gameName != null)
      map[PILOT_REQUEST_GAME_NAME_KEY] = EnumToString.convertToString(gameName);

    return map;
  }
}