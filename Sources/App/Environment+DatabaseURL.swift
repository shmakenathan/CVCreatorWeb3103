//
//  File.swift
//  
//
//  Created by Nathan on 31/03/2022.
//

import Foundation

import Vapor

extension Environment {
    
    static var databaseURL: URL? {
        guard let urlString = Environment.get("DATABASE_URL"), let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
