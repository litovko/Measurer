QT += qml quick serialport

CONFIG += c++11

SOURCES += main.cpp \
    c_com.cpp \
    c_mstat.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    c_com.h \
    c_mstat.h
