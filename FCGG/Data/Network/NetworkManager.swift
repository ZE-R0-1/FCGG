//
//  NetworkManager.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import Foundation
import RxSwift

// 네트워크 요청을 관리하는 클래스 정의
class NetworkManager {
    // 기본 API URL
    private let baseURL = "https://open.api.nexon.com/fconline/v1"
    // 메타 데이터 API URL
    private let metaBaseURL = "https://open.api.nexon.com/static/fconline/meta"
    // API 키
    private let apiKey: String

    // 초기화 메서드
    init() {
        // Info.plist에서 API 키를 가져옴
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "FC4_API_KEY") as? String else {
            fatalError("API Key not found in Info.plist")
        }
        self.apiKey = apiKey
    }

    // 네트워크 요청을 수행하는 메서드
    private func performRequest<T: Decodable>(_ url: URL) -> Observable<T> {
        return Observable.create { observer in
            // URLRequest 생성
            var request = URLRequest(url: url)
            request.addValue(self.apiKey, forHTTPHeaderField: "x-nxopen-api-key")

            // URLSession 데이터 작업 수행
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let data = data else {
                    observer.onError(NetworkError.noData)
                    return
                }

                // JSON 디코딩
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

    // 플레이어 닉네임을 가져오는 메서드
    func getPlayerNickName(name: String) -> Observable<String> {
        // 이름을 URL에 적합하게 인코딩
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        // URL 생성
        guard let url = URL(string: baseURL + APIEndpoints.getPlayerNickName(nickName: encodedName)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        // 네트워크 요청 수행
        return performRequest(url).map { (response: PlayerIDResponse) in response.ouid }
    }

    // 최대 디비전을 가져오는 메서드
    func getMaxDivision(ouid: String) -> Observable<[MaxDivision]> {
        // URL 생성
        guard let url = URL(string: baseURL + APIEndpoints.getMaxDivision(ouid: ouid)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        // 네트워크 요청 수행
        return performRequest(url)
    }

    // 사용자 기본 정보를 가져오는 메서드
    func getUserBasicInfo(ouid: String) -> Observable<UserBasicInfo> {
        // URL 생성
        guard let url = URL(string: baseURL + APIEndpoints.getUserBasicInfo(ouid: ouid)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        // 네트워크 요청 수행
        return performRequest(url)
    }

    // 매치 타입들을 가져오는 메서드
    func getMatchTypes() -> Observable<[MatchType]> {
        // URL 생성
        guard let url = URL(string: metaBaseURL + "/matchtype.json") else {
            return Observable.error(NetworkError.invalidURL)
        }
        // 네트워크 요청 수행
        return performRequest(url)
    }

    // 디비전 메타 데이터를 가져오는 메서드
    func getDivisions() -> Observable<[DivisionMeta]> {
        // URL 생성
        guard let url = URL(string: metaBaseURL + "/division.json") else {
            return Observable.error(NetworkError.invalidURL)
        }
        // 네트워크 요청 수행
        return performRequest(url)
    }
    
    // 사용자 매치들을 가져오는 메서드
    func getUserMatches(ouid: String, matchtype: Int, offset: Int, limit: Int) -> Observable<[String]> {
        // URL 생성
        guard let url = URL(string: baseURL + APIEndpoints.getUserMatches(ouid: ouid, matchtype: matchtype, offset: offset, limit: limit)) else {
            return Observable.error(NetworkError.invalidURL)
        }
        // 네트워크 요청 수행
        return performRequest(url)
    }
}

// 네트워크 오류를 정의하는 열거형
enum NetworkError: Error {
    case invalidURL
    case noData
}

// 플레이어 ID 응답 구조체 정의
struct PlayerIDResponse: Codable {
    let ouid: String
}

// 사용자 기본 정보 구조체 정의
struct UserBasicInfo: Codable {
    let ouid: String
    let nickname: String
    let level: Int
}
