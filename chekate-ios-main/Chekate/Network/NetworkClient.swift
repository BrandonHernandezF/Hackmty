import Foundation
import Alamofire

class NetworkClient {
    let apiURL = "https://c612-131-178-102-144.ngrok-free.app"
    
    func executeV3<Call: NetworkCall>(
        call: Call,
        skipMinimumVersion: Bool = false
    ) async -> Result<Call.Response?, NetworkError> {
        return await withCheckedContinuation { continuation in
            AF.request(
                "\(self.apiURL)\(call.path)",
                method: call.method,
                parameters: call.body,
                encoder: call.method == .get ? URLEncodedFormParameterEncoder.default : JSONParameterEncoder.default,
                headers: nil,
                interceptor: nil
            )
            .responseJSON { response in
                continuation.resume(returning: self.handleResponseV3(call: call, response: response))
            }
        }
    }

    func handleResponseV3<Call: NetworkCall>(
        call: Call,
        response: AFDataResponse<Any>
    ) -> Result<Call.Response?, NetworkError> {
        if let error = response.error {
            let message = "\(error.localizedDescription) - \(String(describing: error.responseCode))"

            return .failure(.unknown)
        }

        if response.response?.statusCode == 204 {
            return .success(nil)
        }

        if response.response?.statusCode == 502 {
            return .failure(.unknown)
        }

        if response.response?.statusCode == 504 {
            return .failure(.unknown)
        }

        if response.response?.statusCode == 401 {
            return .failure(.authentication)
        }

        if let statusCode = response.response?.statusCode, statusCode >= 400, statusCode != 422 {
            return .failure(.unknown)
        }

        guard let data = response.data else {
            return .failure(.unknown)
        }

        do {
            let parsedResponse = try JSONDecoder().decode(Call.Response.self, from: data)

            return .success(parsedResponse)
        } catch {
            return .failure(.unknown)
        }
    }
}
