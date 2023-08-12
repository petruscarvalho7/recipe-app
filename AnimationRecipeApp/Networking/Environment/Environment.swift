//
//  ENV.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 12/08/23.
//

import Foundation

protocol APIKeyables {
    var SERVICE_API_KEY: String { get }
    var SERVICE_API_TOKEN: String { get }
}

class BaseENV {
    let dict: NSDictionary
    
    init(resourceName: String) {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist") else {
            fatalError("Couldn't find file \(resourceName).plist.")
        }
                       
        guard let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Plist problems")
        }
        
        self.dict = plist
    }
}


class DebugENV: BaseENV, APIKeyables {
    init() {
        super.init(resourceName: "DEBUG-Keys")
    }
    
    var SERVICE_API_KEY: String {
        return dict.object(forKey: "SERVICE_API_KEY") as? String ?? ""
    }
    
    var SERVICE_API_TOKEN: String {
        return dict.object(forKey: "SERVICE_API_TOKEN") as? String ?? ""
    }
}

class ProdENV: BaseENV, APIKeyables {
    init() {
        super.init(resourceName: "PROD-Keys")
    }
    
    var SERVICE_API_KEY: String {
        return dict.object(forKey: "SERVICE_API_KEY") as? String ?? ""
    }
    
    var SERVICE_API_TOKEN: String {
        return dict.object(forKey: "SERVICE_API_TOKEN") as? String ?? ""
    }
}

var ENV: APIKeyables {
    #if DEBUG
    return DebugENV()
    #else
    return ProdENV()
    #endif
}
