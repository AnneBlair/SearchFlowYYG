//
//  AppError.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    
    case networkingFailed(Error)
    case planDayNumFailed(String)
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .networkingFailed(let error): return error.localizedDescription
        case .planDayNumFailed(let message): return message
        }
    }
}
