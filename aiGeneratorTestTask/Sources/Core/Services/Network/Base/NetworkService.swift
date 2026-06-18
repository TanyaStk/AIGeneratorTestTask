import Foundation

protocol NetworkServiceType {
    func get<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T
    
    func post<Body: Encodable, Response: Decodable>(path: String, queryItems: [URLQueryItem], body: Body) async throws -> Response
}

extension NetworkServiceType {
    func get<T: Decodable>(path: String) async throws -> T {
        try await get(path: path, queryItems: [])
    }

    func post<Body: Encodable, Response: Decodable>(
        path: String,
        body: Body
    ) async throws -> Response {
        try await post(path: path, queryItems: [], body: body)
    }
}

final class NetworkService: NetworkServiceType {
    
    private let session = URLSession.shared
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    func get<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T {
        let request = try buildRequest(path: path, method: "GET", queryItems: queryItems, body: Optional<String>.none)
        
        request.printRequestLog()
        
        return try await perform(request)
    }

    func post<Body: Encodable, Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem],
        body: Body
    ) async throws -> Response {
        let request = try buildRequest(path: path, method: "POST", queryItems: queryItems, body: body)
        
        return try await perform(request)
    }

    // MARK: - Private

    private func buildRequest<Body: Encodable>(
        path: String,
        method: String,
        queryItems: [URLQueryItem],
        body: Body?
    ) throws -> URLRequest {
        guard var components = URLComponents(string: APIConstants.baseURL + path) else {
            throw APIError.invalidURL
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(APIConstants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(body)
        }
        
        request.printRequestLog()
        
        return request
    }

    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse(statusCode: -1)
            }
            
            guard (200...299).contains(http.statusCode) else {
                if let validation = try? decoder.decode(ValidationErrorResponse.self, from: data) {
                    throw APIError.validationError(details: validation.detail)
                }
                throw APIError.invalidResponse(statusCode: http.statusCode)
            }
            
            response.printLog(data: data)
            
            return try decoder.decode(T.self, from: data)
            
        } catch let error as APIError {
            error.printLog(from: request)
            
            throw error
        }
        catch let error as DecodingError {
            error.printLog(from: request)
            
            throw APIError.decodingFailed(underlying: error)
        } catch {
            error.printLog(from: request)
            
            throw APIError.unknown(underlying: error)
        }
    }
}

private struct ValidationErrorResponse: Decodable {
    let detail: [ValidationDetail]
}
