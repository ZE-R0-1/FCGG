//
//  NetworkManager.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import Foundation
import RxSwift

class NetworkManager {
    private let baseURL = "https://open.api.nexon.com/fconline/v1"
    private let apiKey: String

    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "FC4_API_KEY") as? String else {
            fatalError("API Key not found in Info.plist")
        }
        self.apiKey = apiKey
    }

    private func performRequest<T: Decodable>(_ endpoint: String) -> Observable<T> {
        return Observable.create { observer in
            guard let url = URL(string: self.baseURL + endpoint) else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.addValue(self.apiKey, forHTTPHeaderField: "x-nxopen-api-key")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let data = data else {
                    observer.onError(NetworkError.noData)
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedData)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }

    func getPlayerID(name: String) -> Observable<String> {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        return performRequest(APIEndpoints.getPlayerID(name: encodedName))
            .map { (response: PlayerIDResponse) in response.ouid }
    }

    func getMaxDivision(ouid: String) -> Observable<[Division]> {
        return performRequest(APIEndpoints.getMaxDivision(ouid: ouid))
    }

    func getMatchIDs(matchType: Int, offset: Int, limit: Int, orderBy: String) -> Observable<[String]> {
        return performRequest(APIEndpoints.getMatchIDs(matchType: matchType, offset: offset, limit: limit, orderBy: orderBy))
    }

    func getUserBasicInfo(ouid: String) -> Observable<UserBasicInfo> {
        return performRequest(APIEndpoints.getUserBasicInfo(ouid: ouid))
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}

struct PlayerIDResponse: Codable {
    let ouid: String
}

struct UserBasicInfo: Codable {
    let ouid: String
    let nickname: String
    let level: Int
}
