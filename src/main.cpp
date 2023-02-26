#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlExtensionPlugin>

Q_IMPORT_QML_PLUGIN(GamePlugin)

#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Heartless");
    QGuiApplication::setOrganizationName("Loren Burkholder");
    QGuiApplication::setOrganizationDomain("io.github.LorenDB");

    QGuiApplication app{argc, argv};

    QTranslator translator;
    if (translator.load(QLocale{}, QStringLiteral("Heartless"), QStringLiteral("_"), QStringLiteral(":/i18n")))
        QGuiApplication::installTranslator(&translator);

    QQmlApplicationEngine engine;
    const QUrl url{u"qrc:/Heartless/qml/main.qml"_qs};
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](const QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
