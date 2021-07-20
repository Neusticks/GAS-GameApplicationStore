import 'package:flutter/cupertino.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';

class GameDetails extends ChangeNotifier{
  GameList _gameList;

  GameList get gameName{
    return _gameList;
  }

  set initialGameName(GameList game){
    _gameList = game;
  }

  set gameName(GameList game){
    _gameList = game;
    notifyListeners();
  }
}