qt_add_library(Game STATIC)
qt_add_qml_module(Game
    URI Game
    VERSION 1.0
    SOURCES
        Game.cpp
        Game.h
        Player.cpp
        Player.h
)
