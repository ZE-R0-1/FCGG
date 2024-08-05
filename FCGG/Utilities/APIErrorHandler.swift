//
//  APIErrorHandler.swift
//  FCGG
//
//  Created by USER on 8/5/24.
//

import Foundation

struct APIErrorHandler {
    static let errorMessages: [String: String] = [
        "OPENAPI00001": "서버 내부 오류가 발생했습니다.",
        "OPENAPI00002": "API 접근 권한이 없습니다.",
        "OPENAPI00003": "유효하지 않은 식별자입니다.",
        "OPENAPI00004": "등록되지 않은 구단주입니다.",
        "OPENAPI00005": "유효하지 않은 API KEY입니다.",
        "OPENAPI00006": "유효하지 않은 게임 또는 API PATH입니다.",
        "OPENAPI00007": "API 호출량이 초과되었습니다.",
        "OPENAPI00009": "데이터를 준비 중입니다.",
        "OPENAPI00010": "게임 점검 중입니다.",
        "OPENAPI00011": "API 점검 중입니다."
    ]
    
    static func getMessage(for errorDetails: String) -> String {
        let errorCode = extractErrorCode(from: errorDetails)
        return errorMessages[errorCode] ?? "알 수 없는 오류가 발생했습니다."
    }
    
    private static func extractErrorCode(from errorDetails: String) -> String {
        let components = errorDetails.components(separatedBy: " ")
        if components.count > 2 {
            return components[2]
        }
        return ""
    }
}
