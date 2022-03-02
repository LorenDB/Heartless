#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <qqmlregistration.h>

class Player : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(short score READ score NOTIFY scoreChanged)
    Q_PROPERTY(QVector<short> scores READ scores NOTIFY scoreChanged)
    Q_PROPERTY(QString stagingScore MEMBER m_stagingScore NOTIFY stagingScoreChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(bool winner READ winner NOTIFY winnerChanged)

public:
    explicit Player(QObject *parent = nullptr);
    explicit Player(const QString &name, QObject *parent = nullptr);
    explicit Player(short score, const QString &name, QObject *parent = nullptr);
    explicit Player(const Player &other);

    Player &operator=(const Player &other);

    short score() const { return std::accumulate(m_scores.begin(), m_scores.end(), 0, [](auto a, auto b) { return a + b; }); }
    auto &scores() const { return m_scores; }
    short stagingScore() const { return m_stagingScore.toShort(); }
    QString name() const { return m_name; }
    bool winner() const { return m_winner; }

    void resetScore();
    void resetStagingScore();
    void setName(const QString &name);
    void setWinner(bool b);

public slots:
    void addToScore(short points);

signals:
    void scoreChanged();
    void stagingScoreChanged();
    void stagingScoreReset();
    void nameChanged();
    void winnerChanged();

    void shootTheMoon();

private:
    QVector<short> m_scores{};
    QString m_stagingScore;
    QString m_name;
    bool m_winner{false};
};

#endif // PLAYER_H
