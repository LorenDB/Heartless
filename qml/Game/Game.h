#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <qqmlregistration.h>

#include <array>

#include "Player.h"

class Game : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(Player *player1 READ player1 CONSTANT)
    Q_PROPERTY(Player *player2 READ player2 CONSTANT)
    Q_PROPERTY(Player *player3 READ player3 CONSTANT)
    Q_PROPERTY(Player *player4 READ player4 CONSTANT)

public:
    explicit Game(QObject *parent = nullptr);

    Player *player1() { return &m_players[0]; }
    Player *player2() { return &m_players[1]; }
    Player *player3() { return &m_players[2]; }
    Player *player4() { return &m_players[3]; }

signals:
    void gameOver();

private:
    QVector<Player> m_players;
};

#endif // GAME_H
