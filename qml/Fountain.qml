import QtQuick
import QtQuick.Particles

Item {
    id: fountainRoot

    required property ParticleSystem particleSystem
    readonly property alias emitter: fountainEmitter

    Emitter {
        id: fountainEmitter

        enabled: false
        anchors.horizontalCenter: fountainRoot.horizontalCenter
        y: fountainRoot.height + 100 // this offset prevents fade-in partway up the screen
        system: fountainRoot.particleSystem
        emitRate: 100 * Math.sqrt(fountainRoot.width * fountainRoot.height) / 450
        lifeSpan: 3000 * Math.sqrt(fountainRoot.height) / 30
        lifeSpanVariation: 500
        velocity: PointDirection { x: 0; y: -1000; xVariation: Math.sqrt(fountainRoot.width) * 6.5; yVariation: 50 }
        velocityFromMovement: 8
        size: 48
        sizeVariation: 16

        ImageParticle {
            system: fountainRoot.particleSystem
            source: Qt.resolvedUrl("logo.svg")
        }
    }

    Friction {
        system: fountainRoot.particleSystem
        anchors.fill: parent
        factor: 5 * 1000 / fountainRoot.height
        threshold: 700
    }

    Gravity {
        system: fountainRoot.particleSystem
        anchors.fill: parent
        magnitude: 1000 * 500 / fountainRoot.height
        angle: 90
    }
}
