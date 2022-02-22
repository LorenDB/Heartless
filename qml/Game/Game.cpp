#include "Game.h"

Game::Game(QObject *parent)
    : QObject{parent},
      m_players{Player{QStringLiteral("North"), this},
                Player{QStringLiteral("East"), this},
                Player{QStringLiteral("South"), this},
                Player{QStringLiteral("West"), this}}
{
    for (auto &player : m_players)
    {
        connect(&player, &Player::shootTheMoon, this, [this, &player] {
            for (auto &otherPlayer : m_players)
            {
                if (&player == &otherPlayer)
                    continue;
                otherPlayer.moonWasShot();
            }
        });
        connect(&player, &Player::scoreChanged, this, [this, &player] {
            player.setWinner(true);
            emit gameOver();
        });
    }
}
