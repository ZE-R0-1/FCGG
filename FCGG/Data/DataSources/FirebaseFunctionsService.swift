//
//  UserLocalDataSource.swift
//  FCGG
//
//  Created by USER on 8/2/24.
//

import Foundation
import RxSwift
import FirebaseFunctions

protocol FirebaseFunctionsService {
    func getPlayerData(name: String) -> Observable<User>
}

class FirebaseFunctionsServiceImpl: FirebaseFunctionsService {
    func getPlayerData(name: String) -> Observable<User> {
        return Observable.create { observer in
            Functions.functions().httpsCallable("getPlayerData").call(["nickname": name]) { result, error in
                if let error = error as NSError? {
                    print("오류 발생: \(error.localizedDescription)")
                    print("오류 세부사항: \(error.userInfo)")
                    observer.onError(error)
                } else if let data = result?.data as? [String: Any] {
                    print("받은 데이터: \(data)")
                    if let ouid = data["ouid"] as? String,
                       let nickname = data["nickname"] as? String,
                       let level = data["level"] as? Int {
                        let user = User(ouid: ouid, nickname: nickname, level: level)
                        observer.onNext(user)
                        observer.onCompleted()
                    } else {
                        let error = NSError(domain: "ParsingError", code: -1, userInfo: ["errorDescription": "사용자 데이터 파싱 실패"])
                        observer.onError(error)
                    }
                } else {
                    let error = NSError(domain: "DataError", code: -1, userInfo: ["errorDescription": "데이터 수신 실패"])
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
