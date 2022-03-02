#include "Game.h"

Game::Game(QObject *parent)
    : QObject{parent},
      m_players{new Player{QStringLiteral("North"), this},
                new Player{QStringLiteral("East"), this},
                new Player{QStringLiteral("South"), this},
                new Player{QStringLiteral("West"), this}}
{
    for (auto player : m_players)
    {
        connect(player, &Player::shootTheMoon, this, [this, player] {
            for (auto otherPlayer : m_players)
            {
                if (player == otherPlayer)
                    continue;
                otherPlayer->addToScore(26);
            }
        });
        connect(player, &Player::stagingScoreChanged, this, [this] {
            QVector<short> stagingScores;
        //    std::transform(m_players.cbegin(), m_players.cend(), scores.begin(), [](auto p) { return p->score(); });
//            std::transform(m_players.begin(), m_players.end(), stagingScores.begin(), [](auto p) { return p->stagingScore(); });
            for (auto player : m_players)
                stagingScores.push_back(player->stagingScore());
            m_stagingScoresReady = (std::accumulate(stagingScores.begin(), stagingScores.end(), 0, std::plus<short>()) == 26);
            emit stagingScoresReadyChanged();
        });
        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);
    }
}

void Game::checkForWinner()
{
    QVector<short> scores;
//    std::transform(m_players.cbegin(), m_players.cend(), scores.begin(), [](auto p) { return p->score(); });
    for (auto player : m_players)
        scores.push_back(player->score());
    std::sort(scores.begin(), scores.end(), [](const auto &a, const auto&b) { return a < b; });
    if (scores.last() < 100)
        return;

    for (auto player : m_players)
        if (player->score() == scores.front())
            player->setWinner(true);
        else
            player->setWinner(false);

    m_gameOver = true;
    emit gameOverChanged();
}

void Game::reset()
{
    for (auto &player : m_players)
    {
        disconnect(player, &Player::scoreChanged, this, &Game::checkForWinner);
        player->setWinner(false);
        player->resetScore();
        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);
    }

    m_gameOver = false;
    emit gameOverChanged();
}

void Game::commitStagingScores()
{
    for (auto &player : m_players)
    {
        player->addToScore(player->stagingScore());
        player->resetStagingScore();
    }
}
