QT += qml quick serialport charts multimedia

CONFIG += c++11 console

SOURCES += main.cpp \
    c_com.cpp \
    c_mstat.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =
DESTDIR = d:/dest
# Default rules for deployment.
#qnx: target.path = /tmp/$${TARGET}/bin
#else: unix:!android: target.path = /opt/$${TARGET}/bin
#!isEmpty(target.path): INSTALLS += target

HEADERS += \
    c_com.h \
    c_mstat.h

DISTFILES +=
