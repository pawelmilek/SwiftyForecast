//
//  TemperatureVolumeFactory.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol TemperatureVolumeFactoryProtocol {

    func make(
        by notation: TemperatureNotation,
        valueInKelvin current: Double
    ) -> TemperatureVolume

    func make(
        by notation: TemperatureNotation,
        valueInKelvin: TemperatureValue
    ) -> TemperatureVolume
}

struct TemperatureVolumeFactory: TemperatureVolumeFactoryProtocol {

    func make(
        by notation: TemperatureNotation,
        valueInKelvin current: Double
    ) -> TemperatureVolume {
        make(by: notation, valueInKelvin: TemperatureValue(current: current, max: .signalingNaN, min: .signalingNaN))
    }

    func make(
        by notation: TemperatureNotation,
        valueInKelvin: TemperatureValue
    ) -> TemperatureVolume {
        switch notation {
        case .celsius:
            return TemperatureVolumeCelsius(
                currentInKelvin: valueInKelvin.current,
                maxInKelvin: valueInKelvin.max,
                minInKelvin: valueInKelvin.min
            )

        case .fahrenheit:
            return TemperatureVolumeFahrenheit(
                currentInKelvin: valueInKelvin.current,
                maxInKelvin: valueInKelvin.max,
                minInKelvin: valueInKelvin.min
            )
        }
    }
}
