#include "Game.h"

#include <QSettings>

Game::Game(QObject *parent)
    : QObject{parent},
      m_players{new Player{tr("North"), this},
                new Player{tr("East"), this},
                new Player{tr("South"), this},
                new Player{tr("West"), this}}
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
                otherPlayer->clearRedoScores();
            }
            emit currentRoundChanged();
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
        connect(player, &Player::scoreChanged, this, [this, player] {
            QSettings settings;
            settings.beginGroup(QStringLiteral("saved_game"));
            settings.beginGroup(QStringLiteral("player%1").arg(m_players.indexOf(player)));
            QVariantList variants;
            for (const auto score : player->m_scores)
                variants.push_back(score);
            settings.setValue(QStringLiteral("scores"), variants);
        });
        connect(player, &Player::redoScoresChanged, this, [this, player] {
            QSettings settings;
            settings.beginGroup(QStringLiteral("saved_game"));
            settings.beginGroup(QStringLiteral("player%1").arg(m_players.indexOf(player)));
            QVariantList variants;
            for (const auto score : player->m_redoScores)
                variants.push_back(score);
            settings.setValue(QStringLiteral("redoScores"), variants);
        });
        connect(player, &Player::nameChanged, this, [this, player] {
            QSettings settings;
            settings.beginGroup(QStringLiteral("saved_game"));
            settings.beginGroup(QStringLiteral("player%1").arg(m_players.indexOf(player)));
            settings.setValue(QStringLiteral("name"), player->name());
        });
    }
    connect(this, &Game::currentRoundChanged, this, [this] {
        QSettings settings;
        settings.beginGroup(QStringLiteral("saved_game"));
        settings.setValue(QStringLiteral("current_round"), currentRound());
    });
}

Game::~Game()
{
    bool shouldDeleteSave{true};
    for (auto player : m_players)
        shouldDeleteSave &= ((player->scores().length() == 0) | m_gameOver);

    if (shouldDeleteSave)
        deleteSavedGame();
}

void Game::setTargetScore(int target)
{
    // 13 is the lowest possible high score for a game of one round, so don't use anything smaller than that
    if (target < 13 || target == m_targetScore)
        return;

    m_targetScore = target;
    emit targetScoreChanged();
}

bool Game::savedGameAvailable() const
{
    QSettings settings;
    settings.beginGroup(QStringLiteral("saved_game"));
    if (settings.allKeys().size() > 0)
        for (const auto &key: settings.allKeys())
            qDebug() << "key the nth: " << key << "with value: " << settings.value(key);
    return settings.allKeys().length() > 0;
}

void Game::checkForWinner()
{
    QVector<short> scores;
    for (auto player : m_players)
        scores.push_back(player->score());
    std::sort(scores.begin(), scores.end(), std::less<>());
    if (scores.last() < m_targetScore)
    {
        for (auto player: m_players)
            player->setWinner(false);

        if (m_gameOver)
        {
            m_gameOver = false;
            emit gameOverChanged();
        }
        return;
    }

    for (auto player : m_players)
        if (player->score() == scores.front())
            player->setWinner(true);
        else
            player->setWinner(false);

    if (!m_gameOver)
    {
        m_gameOver = true;
        emit gameOverChanged();
    }

    // if the game is over, no point in saving it
    deleteSavedGame();
}

void Game::reset()
{
    for (auto player : m_players)
    {
        disconnect(player, &Player::scoreChanged, this, &Game::checkForWinner);
        player->reset();
        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);
    }

    m_gameOver = false;
    emit gameOverChanged();
    emit currentRoundChanged();
    deleteSavedGame();
}

void Game::undoLastMove()
{
    for (auto player : m_players)
    {
        disconnect(player, &Player::scoreChanged, this, &Game::checkForWinner);
        player->undoLastMove();
        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);
    }
    emit currentRoundChanged();
    checkForWinner();
}

void Game::redo()
{
    for (auto player : m_players)
        player->redo();
    emit currentRoundChanged();
}

void Game::restoreSavedGame()
{
    if (!savedGameAvailable())
        return;

    QSettings settings;
    settings.beginGroup(QStringLiteral("saved_game"));
    for (auto player : m_players)
    {
        settings.beginGroup(QStringLiteral("player%1").arg(m_players.indexOf(player)));

        disconnect(player, &Player::scoreChanged, this, &Game::checkForWinner);
        player->m_name = settings.value(QStringLiteral("name"), player->m_name).toString();
        auto scores = settings.value(QStringLiteral("scores")).toList();
        if (!scores.isEmpty())
            for (const auto &score : scores)
                player->m_scores.push_back(score.toInt());
        auto redoScores = settings.value(QStringLiteral("redoScores")).toList();
        if (!redoScores.isEmpty())
            for (const auto &score : redoScores)
                player->m_redoScores.push_back(score.toInt());

        emit player->nameChanged();
        emit player->scoreChanged();
        emit player->redoScoresChanged();

        connect(player, &Player::scoreChanged, this, &Game::checkForWinner);

        settings.endGroup();
    }

    checkForWinner();
}

void Game::deleteSavedGame()
{
    QSettings settings;
    settings.beginGroup(QStringLiteral("saved_game"));
    settings.remove({});
    settings.endGroup();
    settings.remove(QStringLiteral("current_round"));
    for (auto player : m_players)
    {
        settings.beginGroup(QStringLiteral("player%1").arg(m_players.indexOf(player)));
        settings.remove("scores");
        settings.remove("redoScores");
        settings.endGroup();
    }
}

void Game::commitStagingScores()
{
    for (auto player : m_players)
    {
        player->addToScore(player->stagingScore());
        player->resetStagingScore();
        player->clearRedoScores();
    }
}
