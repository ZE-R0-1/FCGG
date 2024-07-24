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
    private let metaBaseURL = "https://open.api.nexon.com/static/fconline/meta"
    private let apiKey: String

    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "FC4_API_KEY") as? String else {
            fatalError("API Key not found in Info.plist")
        }
        self.apiKey = apiKey
    }

    private func performRequest<T: Decodable>(_ url: URL) -> Observable<T> {
        return Observable.create { observer in
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
        guard let url = URL(string: baseURL + APIEndpoints.getPlayerID(name: encodedName)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        return performRequest(url).map { (response: PlayerIDResponse) in response.ouid }
    }

    func getMaxDivision(ouid: String) -> Observable<[Division]> {
        guard let url = URL(string: baseURL + APIEndpoints.getMaxDivision(ouid: ouid)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        return performRequest(url)
    }

    func getUserBasicInfo(ouid: String) -> Observable<UserBasicInfo> {
        guard let url = URL(string: baseURL + APIEndpoints.getUserBasicInfo(ouid: ouid)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        return performRequest(url)
    }

    func getMatchTypes() -> Observable<[MatchType]> {
        guard let url = URL(string: metaBaseURL + "/matchtype.json") else {
            return Observable.error(NetworkError.invalidURL)
        }
        return performRequest(url)
    }

    func getDivisions() -> Observable<[DivisionMeta]> {
        guard let url = URL(string: metaBaseURL + "/division.json") else {
            return Observable.error(NetworkError.invalidURL)
        }
        return performRequest(url)
    }
    
    func getMatchIDs(matchType: Int, offset: Int, limit: Int, orderBy: String) -> Observable<[String]> {
        guard let url = URL(string: baseURL + APIEndpoints.getMatchIDs(matchType: matchType, offset: offset, limit: limit, orderBy: orderBy)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        return performRequest(url)
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
