cmake_minimum_required(VERSION 3.16)

project(Heartless VERSION 1.0.1 LANGUAGES CXX)

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
        qml/trophy.svg
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
    QT_ANDROID_TARGET_SDK_VERSION 31
)

if(ANDROID)
    # From https://16bpp.net/blog/post/making-a-cross-platform-mobile-desktop-app-with-qt-62/
    # Figure out the platform & architecture code we need
    set(ANDROID_PLATFORM_ARCHITECTURE_CODE "xxx")
    if (${ANDROID_ABI} STREQUAL "armeabi-v7a")
      set(ANDROID_PLATFORM_ARCHITECTURE_CODE "032")
    elseif (${ANDROID_ABI} STREQUAL "arm64-v8a")
      set(ANDROID_PLATFORM_ARCHITECTURE_CODE "064")
    elseif (${ANDROID_ABI} STREQUAL "x86")
      set(ANDROID_PLATFORM_ARCHITECTURE_CODE "132")
    elseif (${ANDROID_ABI} STREQUAL "x86_64")
      set(ANDROID_PLATFORM_ARCHITECTURE_CODE "164")
    endif()

    # Slap the above together with a version code (major and minor only)
    set(ANDROID_VERSION_CODE "${ANDROID_PLATFORM_ARCHITECTURE_CODE}${PROJECT_VERSION_MAJOR}${PROJECT_VERSION_MINOR}")
    set_property(TARGET appHeartless APPEND PROPERTY QT_ANDROID_VERSION_CODE ${ANDROID_VERSION_CODE})
endif()

target_compile_definitions(appHeartless
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appHeartless PRIVATE
    Qt6::Quick
    Qt6::Svg
    Gameplugin
)
