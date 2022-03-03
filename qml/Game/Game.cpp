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
                    player->addToScore(0);
                else
                    otherPlayer->addToScore(26);
            }
        });
        connect(player, &Player::stagingScoreChanged, this, [this] {
            QVector<short> stagingScores;
            for (auto player : m_players)
                stagingScores.push_back(player->stagingScore());
            std::sort(stagingScores.begin(), stagingScores.end(), std::less<>());
            m_stagingScoresReady = (std::accumulate(stagingScores.begin(), stagingScores.end(), 0, std::plus<short>()) == 26) && (stagingScores.last() >= 13);
            emit stagingScoresReadyChanged();
        });
        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);
    }
}

void Game::checkForWinner()
{
    QVector<short> scores;
    for (auto player : m_players)
        scores.push_back(player->score());
    std::sort(scores.begin(), scores.end(), [](const auto &a, const auto&b) { return a < b; });
    if (scores.last() < 100)
    {
        for (auto player: m_players)
            player->setWinner(false);
        return;
    }

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
        player->reset();
        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);
    }

    m_gameOver = false;
    emit gameOverChanged();
}

void Game::undoLastMove()
{
    for (auto &player : m_players)
    {
        disconnect(player, &Player::scoreChanged, this, &Game::checkForWinner);
        player->undoLastMove();
        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);
    }
    checkForWinner();
}

void Game::redo()
{
    for (auto &player : m_players)
        player->redo();
}

void Game::commitStagingScores()
{
    for (auto &player : m_players)
    {
        player->addToScore(player->stagingScore());
        player->resetStagingScore();
    }
}
