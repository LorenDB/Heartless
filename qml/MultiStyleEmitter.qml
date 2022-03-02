import QtQuick
import QtQuick.Particles

Item {
    id: emitterRoot

    required property ParticleSystem particleSystem
    readonly property alias emitter: theEmitter

    Emitter {
        id: theEmitter

        enabled: false
        anchors.horizontalCenter: emitterRoot.horizontalCenter
        y: {
            switch (settings.animation) {
            case AnimType.Balloon:
                return emitterRoot.height
            case AnimType.Fountain:
                return emitterRoot.height + 100 // this offset prevents fade-in partway up the screen
            case AnimType.None:
                return 0
            }
        }
        width: {
            switch (settings.animation) {
            case AnimType.Balloon:
                return emitterRoot.width * 5 / 6
            case AnimType.Fountain:
            case AnimType.None:
                return 0
            }
        }
        system: emitterRoot.particleSystem
        emitRate: {
            switch (settings.animation) {
            case AnimType.Balloon:
                return 10 * Math.sqrt(emitterRoot.width * emitterRoot.height) / 450
            case AnimType.Fountain:
                return 100 * Math.sqrt(emitterRoot.width * emitterRoot.height) / 450
            case AnimType.None:
                return 0
            }
        }
        lifeSpan: 3000 * Math.sqrt(emitterRoot.height) / 26.6
        lifeSpanVariation: 500
        velocityFromMovement: 8
        size: 48
        sizeVariation: 16
        velocity: PointDirection {
            x: 0
            y: {
                switch (settings.animation) {
                case AnimType.Balloon:
                    return -100
                case AnimType.Fountain:
                    return -1000
                case AnimType.None:
                    return 0
                }
            }
            xVariation: {
                switch (settings.animation) {
                case AnimType.Balloon:
                    return 50
                case AnimType.Fountain:
                    return Math.sqrt(emitterRoot.width) * 6.5
                case AnimType.None:
                    return 0
                }
            }
            yVariation: 50
        }
        acceleration: PointDirection {
            x: 0
            y: {
                switch (settings.animation) {
                case AnimType.Balloon:
                    return -100
                case AnimType.Fountain:
                case AnimType.None:
                    return 0
                }
            }
            xVariation: {
                switch (settings.animation) {
                case AnimType.Balloon:
                    return 50
                case AnimType.Fountain:
                case AnimType.None:
                    return 0
                }
            }
            yVariation: {
                switch (settings.animation) {
                case AnimType.Balloon:
                    return 50
                case AnimType.Fountain:
                case AnimType.None:
                    return 0
                }
            }
        }

        ImageParticle {
            system: emitterRoot.particleSystem
            source: Qt.resolvedUrl("logo.svg")
        }
    }

    Friction {
        enabled: settings.animation == AnimType.Fountain
        system: emitterRoot.particleSystem
        anchors.fill: parent
        factor: 5 * 1000 / emitterRoot.height
        threshold: 700
    }

    Gravity {
        enabled: settings.animation == AnimType.Fountain
        system: emitterRoot.particleSystem
        anchors.fill: parent
        magnitude: 1000 * 500 / emitterRoot.height
        angle: 90
    }

    Turbulence {
        enabled: settings.animation == AnimType.Balloon
        anchors.fill: emitterRoot
        strength: 75
        system: emitterRoot.particleSystem
    }
}
