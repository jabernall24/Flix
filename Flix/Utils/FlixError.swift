//
//  FlixError.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 2/13/20.
//  Copyright © 2020 Jesus Bernal Lopez. All rights reserved.
//

import Foundation

enum FlixError: String, Error {
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case invalidUrl         = "Something went wrong in our end."
}
