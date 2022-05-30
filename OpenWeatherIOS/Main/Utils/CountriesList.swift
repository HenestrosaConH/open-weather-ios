//
//  CountriesList.swift
//  OpenWeatherIOS
//
//  Created by JC on 27/5/22.
//

import UIKit

class CountriesList {
    var countries = [[String: String]]()

    init() {
        for code in NSLocale.isoCountryCodes  {
            let code = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: code) ?? "Country not found for code: \(code)"
            let flag = String.emojiFlag(code)
            
            let country = ["code": code, "name": "\(String(describing: flag)) \(name)"]
            countries.append(country)
        }
    }
}

extension String {
    func emojiFlag(country: String) -> String {
        let base : UInt32 = 127397
        var flag = ""
        for scalarView in country.unicodeScalars {
            flag.unicodeScalars.append(UnicodeScalar(base + scalarView.value)!)
        }
        return String(flag)
    }
}
