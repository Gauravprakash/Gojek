//
//  API.swift
//  Delivery
//
//  Created by Hemant Singh on 25/07/19.
//  Copyright © 2019 Hemant Singh. All rights reserved.
//

import Foundation
import Moya
import Alamofire

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}
let configuration = { () -> URLSessionConfiguration in
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    config.timeoutIntervalForRequest = 200 // as seconds, you can set your request timeout
    config.timeoutIntervalForResource = 400 // as seconds, you can set your resource timeout
    config.requestCachePolicy = .useProtocolCachePolicy
    return config
}()
let plugins = { () -> [PluginType] in
    var plugin: [PluginType] = []
    #if DEBUG
    plugin.append(NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter))
    #endif
    return plugin
}
let manager = Manager(
    configuration: configuration
)

let APIProvider = MoyaProvider<API>(manager: manager, plugins: plugins())

// MARK: - Provider support

public enum API {
    case GETCONTACTS
    case NEWCONTACT(Data)
    case CONTACTDETAILS(Int)
    case UPDATECONTACT((Int, Data))
    case DELETECONTACT(Int)
}

extension API: TargetType {
    public var task: Task {
        switch self {
        case .GETCONTACTS:
            return .requestPlain
        case .NEWCONTACT(let params):
            return .requestData(params)
        case .CONTACTDETAILS:
            return .requestPlain
        case .UPDATECONTACT(let params):
             return .requestData(params.1)
        case .DELETECONTACT:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .NEWCONTACT,.UPDATECONTACT:
            return ["Content-Type":"application/json"]
        default:
            return [:]
        }
        
    }
    public var baseURL: URL { return URL(string: "https://gojek-contacts-app.herokuapp.com/")! }

    public var path: String {
        switch self {
        case .GETCONTACTS,.NEWCONTACT:
            return "contacts.json"
        case .CONTACTDETAILS(let id):
            return "contacts/\(id).json"
        case .UPDATECONTACT(let params):
            return "contacts/\(params.0).json"
        case .DELETECONTACT(let id):
            return "contacts/\(id).json"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .GETCONTACTS,.CONTACTDETAILS:
            return .get
        case .NEWCONTACT:
            return .post
        case .UPDATECONTACT:
            return .put
        case .DELETECONTACT:
            return .delete
        }
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    public var sampleData: Data {
        switch self {
        case .NEWCONTACT:
                return "{\"GrouperId\":\"1\",\"Role\":\"C\",\"Email\":\"sharma@gmail.com\"}".data(using: String.Encoding.utf8)!
        default :
        return "{}".data(using: String.Encoding.utf8)!
            
    }
}
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
