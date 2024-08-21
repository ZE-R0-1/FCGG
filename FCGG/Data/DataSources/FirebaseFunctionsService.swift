//
//  UserLocalDataSource.swift
//  FCGG
//
//  Created by USER on 8/2/24.
//

import Foundation
import FirebaseFunctions
import RxSwift

protocol FirebaseFunctionsService {
    func getPlayerBasicInfo(nickname: String) -> Observable<User>
    func getPlayerMaxDivision(nickname: String) -> Observable<[MaxDivision]>
    func getPlayerMatchHistory(nickname: String) -> Observable<[Match]>
    func processRemainingMatches(playerId: String) -> Completable
}

class FirebaseFunctionsServiceImpl: FirebaseFunctionsService {
    private let functions = Functions.functions()
    
    func getPlayerBasicInfo(nickname: String) -> Observable<User> {
        return Observable.create { observer in
            self.functions.httpsCallable("getPlayerBasicInfo").call(["nickname": nickname]) { result, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = result?.data as? [String: Any],
                      let ouid = data["ouid"] as? String,
                      let nickname = data["nickname"] as? String,
                      let level = data["level"] as? Int else {
                    observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse user data"]))
                    return
                }
                
                let user = User(ouid: ouid, nickname: nickname, level: level, maxDivisions: [])
                observer.onNext(user)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getPlayerMaxDivision(nickname: String) -> Observable<[MaxDivision]> {
        return Observable.create { observer in
            self.functions.httpsCallable("getPlayerMaxDivision").call(["nickname": nickname]) { result, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = result?.data as? [[String: Any]] else {
                    observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse max division data"]))
                    return
                }
                
                let maxDivisions = data.compactMap { item -> MaxDivision? in
                    guard let matchType = item["matchType"] as? Int,
                          let matchTypeDesc = item["matchTypeDesc"] as? String,
                          let division = item["division"] as? Int,
                          let divisionName = item["divisionName"] as? String,
                          let achievementDate = item["achievementDate"] as? String,
                          let imageUrl = item["imageUrl"] as? String else {
                        return nil
                    }
                    return MaxDivision(matchType: matchType, matchTypeDesc: matchTypeDesc, division: division, divisionName: divisionName, achievementDate: achievementDate, imageUrl: imageUrl)
                }
                
                observer.onNext(maxDivisions)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getPlayerMatchHistory(nickname: String) -> Observable<[Match]> {
        return Observable.create { observer in
            self.functions.httpsCallable("getPlayerMatchHistory").call(["nickname": nickname]) { result, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = result?.data as? [[String: Any]] else {
                    observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse match history data"]))
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let matches = try JSONDecoder().decode([Match].self, from: jsonData)
                    observer.onNext(matches)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func processRemainingMatches(playerId: String) -> Completable {
        return Completable.create { completable in
            self.functions.httpsCallable("processRemainingMatches").call(["playerId": playerId]) { result, error in
                if let error = error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
}
