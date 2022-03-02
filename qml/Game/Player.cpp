#include "Player.h"

Player::Player(QObject *parent)
    : QObject{parent}
{}

Player::Player(const QString &name, QObject *parent)
    : QObject{parent},
      m_name{name}
{}

Player::Player(short score, const QString &name, QObject *parent)
    : QObject{parent},
      m_name{name},
      m_scores{score}
{}

Player::Player(const Player &other)
    : QObject{other.parent()},
      m_scores{other.m_scores},
      m_name{other.m_name},
      m_winner{other.m_winner}
{}

Player &Player::operator=(const Player &other)
{
    setParent(other.parent());
    m_scores = other.m_scores;
    m_name = other.m_name;
    m_winner = other.m_winner;

    return *this;
}

void Player::resetScore()
{
    m_scores.clear();
    emit scoreChanged();
}

void Player::resetStagingScore()
{
    m_stagingScore = '0';
    emit stagingScoreChanged();
    emit stagingScoreReset();
}

void Player::setName(const QString &name)
{
    if (name == m_name)
        return;

    m_name = name;
    emit nameChanged();
}

void Player::setWinner(bool b)
{
    if (b == m_winner)
        return;

    m_winner = b;
    emit winnerChanged();
}

void Player::addToScore(short points)
{
    m_scores.push_back(points);
    emit scoreChanged();
}
