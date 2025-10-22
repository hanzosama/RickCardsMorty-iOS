//
//  BaseSnapshotTestCase.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 22/10/25.
//
import Foundation

import Testing
import UIKit

open class BaseSnapshotTestCase {
    private enum Constants {
        static let simulatorName = "iPhone 16"
        static let simulatorVersion = "18.2"
    }
    
    private enum BaseSnapshotTestCaseError: Error {
        case invalidSimulator(device: String, version: String)
    }
    
    init() throws {
       try setUpSimulator()
    }
    
    private func setUpSimulator() throws {
        let device = UIDevice.current
        
        guard device.name.hasSuffix(Constants.simulatorName),
              device.systemVersion.starts(with: Constants.simulatorVersion) else {
            throw BaseSnapshotTestCaseError.invalidSimulator(device: Constants.simulatorName, version: Constants.simulatorVersion)
        }
    }
    
}
