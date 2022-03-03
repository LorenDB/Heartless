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

    Q_PROPERTY(QVector<Player *> players READ players CONSTANT)
    Q_PROPERTY(Player * player1 READ player1 CONSTANT)
    Q_PROPERTY(Player * player2 READ player2 CONSTANT)
    Q_PROPERTY(Player * player3 READ player3 CONSTANT)
    Q_PROPERTY(Player * player4 READ player4 CONSTANT)
    Q_PROPERTY(bool gameOver READ gameOver NOTIFY gameOverChanged)
    Q_PROPERTY(bool stagingScoresReady READ stagingScoresReady NOTIFY stagingScoresReadyChanged)

public:
    explicit Game(QObject *parent = nullptr);

    Player *player1() { return m_players[0]; }
    Player *player2() { return m_players[1]; }
    Player *player3() { return m_players[2]; }
    Player *player4() { return m_players[3]; }

    QVector<Player *> players() { return m_players; }

    bool gameOver() const { return m_gameOver; }
    bool stagingScoresReady() const { return m_stagingScoresReady; }

signals:
    void gameOverChanged();
    void stagingScoresReadyChanged();

public slots:
    void checkForWinner();
    void reset();
    void undoLastMove();
    void redo();

    void commitStagingScores();

private:
    QVector<Player *> m_players;

    bool m_gameOver{false};
    bool m_stagingScoresReady{false};
};

#endif // GAME_H
