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
      m_score{score}
{}

Player::Player(const Player &other)
    : QObject{other.parent()},
      m_score{other.score()},
      m_name{other.name()},
      m_winner{other.winner()}
{}

Player &Player::operator=(const Player &other)
{
    setParent(other.parent());
    m_score = other.score();
    m_name = other.name();
    m_winner = other.winner();

    return *this;
}

void Player::setScore(short score)
{
    if (score == m_score)
        return;

    m_score = score;
    emit scoreChanged();
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

void Player::moonWasShot()
{
    m_score += 26;
    emit scoreChanged();
}
