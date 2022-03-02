import QtQuick
import QtQuick.Particles

Item {
    id: balloonRoot

    required property ParticleSystem particleSystem
    readonly property alias emitter: balloonEmitter

    Emitter {
        id: balloonEmitter

        enabled: false
        anchors.horizontalCenter: balloonRoot.horizontalCenter
        anchors.bottom: balloonRoot.bottom
        width: balloonRoot.width * 5 / 6
        system: balloonRoot.particleSystem
        emitRate: 10 * Math.sqrt(balloonRoot.width * balloonRoot.height) / 450
        lifeSpan: 3000
        lifeSpanVariation: 500
        velocity: PointDirection { x: 0; y: -100; xVariation: 50; yVariation: 50 }
        acceleration: PointDirection { x: 0; y: -100; xVariation: 50; yVariation: 50 }
        velocityFromMovement: 8
        size: 48
        sizeVariation: 16

        ImageParticle {
            system: balloonRoot.particleSystem
            source: Qt.resolvedUrl("logo.svg")
        }
    }

    Turbulence {
        anchors.fill: balloonRoot
        strength: 75
        system: balloonRoot.particleSystem
    }
}
