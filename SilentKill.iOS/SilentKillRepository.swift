//
//  SilentKillRepository.swift
//  SilentKill.iOS
//

import Foundation
import SwiftyJSON

class SilentKillRepository: NSObject {
    private let baseUrl = URL(string: "https://silentkill-staging.herokuapp.com/")

    private func perform(with request:URLRequest, success: @escaping (JSON) -> ()) {
        let config = NetworkConfigurationManager.sharedInstance.configuration
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                return
            }
            guard let data = data else {
                return
            }
            success(JSON(data: data))
        })
        task.resume()
    }

    func login(parameters: [String:String], success: @escaping (Bool)->()){
        let url = URL(string: SilentKillRepository.toUrlParameters(params: parameters), relativeTo: baseUrl?.appendingPathComponent(Endpoints.signIn.rawValue))!

        let dataTask = URLSession.shared.dataTask(with: SilentKillRepository.postRequest(with: url)) { (data, urlResponse, error) in
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                success(false)
                return
            }
            if error != nil || httpUrlResponse.statusCode != 200 {
                success(false)
                return
            }

            guard let accessToken = httpUrlResponse.allHeaderFields["Access-Token"] as? String else {
                success(false)
                return
            }
            guard let uid = httpUrlResponse.allHeaderFields["Uid"] as? String else {
                success(false)
                return
            }
            guard let client = httpUrlResponse.allHeaderFields["Client"] as? String else {
                success(false)
                return
            }
            guard let expiry = httpUrlResponse.allHeaderFields["Expiry"] as? String else {
                success(false)
                return
            }
            NetworkConfigurationManager.sharedInstance.setAdditionalHeaders(headers:  ["access-token":accessToken, "client":client, "expiry":expiry, "uid":uid])
            success(true)
        }
        dataTask.resume()
    }

    func getUserGames(success: @escaping ([GameRound]) -> ()){
        let url = baseUrl?.appendingPathComponent(Endpoints.games.rawValue)
        self.perform(with: SilentKillRepository.getRequest(with: url!)) { (json) in
            guard let rounds = GameRound.Create(json: json.arrayValue) else { return }
            success(rounds)
        }
    }

    private static func postRequest(with url:URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = httpTypes.POST.rawValue
        return request
    }

    private static func getRequest(with url:URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = httpTypes.GET.rawValue
        return request
    }

    private static func toUrlParameters(params:[String:String]) -> String{
        let urlParams = params.map { (key, value) -> String in
            return String(format: "%@=%@&", key, value.addingPercentEncodingForQueryParameter())
            }.joined(separator: "")

        return "?" + urlParams.substring(to: urlParams.index(before: urlParams.endIndex))
    }

}

class NetworkConfigurationManager: NSObject {
    static let sharedInstance = NetworkConfigurationManager()

    let configuration = URLSessionConfiguration.default

    func setAdditionalHeaders(headers:[String:String]){
        configuration.httpAdditionalHeaders = headers
    }
}

extension String {
    public func addingPercentEncodingForQueryParameter() -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}

enum httpTypes: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

enum Endpoints: String {
    case signup = "auth"
    case signIn = "auth/sign_in"
    case games = "/game/rounds"
}



