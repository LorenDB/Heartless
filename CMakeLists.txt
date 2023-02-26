cmake_minimum_required(VERSION 3.16)

project(Heartless VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 COMPONENTS Core Quick Svg LinguistTools REQUIRED)

set(TRANSLATIONS
    Heartless_en_US.ts
)

qt_add_executable(appHeartless
    src/main.cpp

    ${TRANSLATIONS}
    ${LANG_FILES}
)

qt_add_qml_module(appHeartless
    URI Heartless
    VERSION 1.0
    QML_FILES
        qml/AboutPage.qml
        qml/AnimType.qml
        qml/HistoryPage.qml
        qml/main.qml
        qml/MainPage.qml
        qml/MultiStyleEmitter.qml
        qml/SettingsPage.qml

    RESOURCES
        qml/logo.svg

        qml/across.svg
        qml/back.svg
        qml/dismiss.svg
        qml/edit.svg
        qml/hamburger-menu.svg
        qml/history.svg
        qml/info.svg
        qml/keep.svg
        qml/left.svg
        qml/license.svg
        qml/moon.svg
        qml/plus.svg
        qml/redo.svg
        qml/reset.svg
        qml/right.svg
        qml/settings.svg
        qml/undo.svg
)
qt_add_translations(appHeartless TS_FILES ${TRANSLATIONS} SOURCES ${CMAKE_SOURCE_DIR}/src ${CMAKE_SOURCE_DIR}/qml)

add_subdirectory(qml)

set_target_properties(appHeartless PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER io.github.LorenDB
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android/
)

target_compile_definitions(appHeartless
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appHeartless PRIVATE
    Qt6::Quick
    Qt6::Svg
    Gameplugin
)
