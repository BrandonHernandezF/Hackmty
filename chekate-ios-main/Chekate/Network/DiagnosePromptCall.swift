import Alamofire
import Foundation

struct DiagnoseInput: Codable {
    let prompt: String
}

struct DiagnoseResponse: Codable {
    let prompt: String
}

final class DiagnosePromptCall: NetworkCall {
    typealias Response = DiagnoseResponse
    
    let method: HTTPMethod = .post
    let path: String = "/prompt"
    let body: DiagnoseInput
    
    init(body: DiagnoseInput) {
        self.body = body
    }
}
