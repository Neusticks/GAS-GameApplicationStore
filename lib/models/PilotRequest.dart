import 'package:enum_to_string/enum_to_string.dart';

import 'Base.dart';

enum GameList {
  MobileLegend,
  PUBGMobile,
  ArenaOfValor,
}

class PilotRequest extends Model {

  static const String PILOT_REQUEST_GAME_ID_KEY = "gameId";
  static const String PILOT_REQUEST_GAME_PASSWORD_KEY = "gamePassword";
  static const String PILOT_REQUEST_OWNER_ID_KEY = "ownerId";
  static const String PILOT_REQUEST_USER_NAME_KEY = "userName";
  static const String PILOT_REQUEST_USER_PHONE_KEY = "userPhone";
  static const String PILOT_REQUEST_GAME_NAME_KEY = "gameName";
  static const String PILOT_ASSIGN_PILOT_ID_KEY = "assignPilot";
  static const String PILOT_REQUEST_STATUS_KEY = "requestStatus";

  String gameId;
  String ownerId;
  String gamePassword;
  String userName;
  String userPhone;
  String requestStatus;
  String assignPilot;
  GameList gameName;

  PilotRequest(
    String id, {
    this.gameId,
    this.ownerId,
    this.gamePassword,
    this.userName,
    this.userPhone,
    this.gameName,
    this.requestStatus = "Not Finished",
    this.assignPilot = "Not Assign",
  }) : super(id);

  factory PilotRequest.fromMap(Map<String, dynamic> map, {String id}) {
    return PilotRequest(
      id,
      gameId: map[PILOT_REQUEST_GAME_ID_KEY],
      ownerId: map[PILOT_REQUEST_OWNER_ID_KEY],
      gamePassword: map[PILOT_REQUEST_GAME_PASSWORD_KEY],
      userName: map[PILOT_REQUEST_USER_NAME_KEY],
      userPhone: map[PILOT_REQUEST_USER_PHONE_KEY],
      requestStatus: map[PILOT_REQUEST_STATUS_KEY],
      assignPilot: map[PILOT_ASSIGN_PILOT_ID_KEY],
      gameName:
          EnumToString.fromString(GameList.values, map[PILOT_REQUEST_GAME_NAME_KEY]),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PILOT_REQUEST_GAME_ID_KEY: gameId,
      PILOT_REQUEST_OWNER_ID_KEY:ownerId,
      PILOT_REQUEST_GAME_PASSWORD_KEY: gamePassword,
      PILOT_REQUEST_USER_NAME_KEY: userName,
      PILOT_REQUEST_USER_PHONE_KEY: userPhone,
      PILOT_REQUEST_STATUS_KEY: requestStatus,
      PILOT_ASSIGN_PILOT_ID_KEY: assignPilot,
      PILOT_REQUEST_GAME_NAME_KEY: EnumToString.convertToString(gameName),
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (gameId != null) map[PILOT_REQUEST_GAME_ID_KEY] = gameId;
    if (ownerId != null) map[PILOT_REQUEST_OWNER_ID_KEY] = ownerId;
    if (userName != null) map[PILOT_REQUEST_USER_NAME_KEY] = userName;
    if (userPhone != null) map[PILOT_REQUEST_USER_PHONE_KEY] = userPhone;
    if (requestStatus != null) map[PILOT_REQUEST_STATUS_KEY] = requestStatus;
    if (assignPilot != null) map[PILOT_ASSIGN_PILOT_ID_KEY] = assignPilot;
    if (gameName != null)
      map[PILOT_REQUEST_GAME_NAME_KEY] = EnumToString.convertToString(gameName);

    return map;
  }
}