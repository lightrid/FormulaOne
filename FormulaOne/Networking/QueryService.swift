//
//  QueryService.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import Foundation
import Alamofire

enum ApiRequestRouter: URLRequestConvertible {
    
    static let baseURLPath = "https://ergast.com/api/f1"
    
    case position(searchPosition: String, year: Year)
    case round(searchRound: Int, year: Year)
    
    var path: String {
        switch self {
        case let .position(searchPosition, year):
            return "/\(year.description())/results/\(searchPosition).json"
        case let .round(searchRound, year):
            return "/\(year.description())/\(searchRound)/results.json"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try ApiRequestRouter.baseURLPath.asURL()
        let request = URLRequest(url: url.appendingPathComponent(path))
        print(request)
        return try URLEncoding.default.encode(request, with: nil)
    }
    
}

typealias RaceResponse = (_ response: [Race]?, _ error: Error?) -> Void

struct QueryService {
    
    public static func makeRequest(route: ApiRequestRouter, completion: @escaping RaceResponse) {
        AF.request(route).validate().responseDecodable(of: FormulaData.self) { response in
            print(response.value as Any)
            completion(response.value?.mrData.raceTable?.races, response.error)
        }
    }
}
