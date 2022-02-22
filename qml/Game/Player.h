#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <qqmlregistration.h>

class Player : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(short score READ score WRITE setScore NOTIFY scoreChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(bool winner READ winner NOTIFY winnerChanged)

public:
    explicit Player(QObject *parent = nullptr);
    explicit Player(const QString &name, QObject *parent = nullptr);
    explicit Player(short score, const QString &name, QObject *parent = nullptr);
    explicit Player(const Player &other);

    Player &operator=(const Player &other);

    short score() const { return m_score; }
    QString name() const { return m_name; }
    bool winner() const { return m_winner; }

    void setScore(short score);
    void setName(const QString &name);
    void setWinner(bool b);

public slots:
    void moonWasShot();

signals:
    void scoreChanged();
    void nameChanged();
    void winnerChanged();

    void shootTheMoon();

private:
    short m_score{};
    QString m_name;
    bool m_winner{false};
};

#endif // PLAYER_H
