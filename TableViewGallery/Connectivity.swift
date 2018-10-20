//
//  Connectivity.swift
//  TableViewGallery
//
//  Created by mrbesford on 10/20/18.
//  Copyright © 2018 mrbesford. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

