import Foundation

protocol NetworkServiceType {
    func get<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T
    
    func post<Body: Encodable, Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem],
        body: Body
    ) async throws -> Response
    
    func postMultipart<Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem],
        textFields: [String: String],
        file: MultipartFile
    ) async throws -> Response
    
    func download(from url: URL) async throws -> URL
}

extension NetworkServiceType {
    func get<T: Decodable>(path: String) async throws -> T {
        try await get(path: path, queryItems: [])
    }
    func post<Body: Encodable, Response: Decodable>(path: String, body: Body) async throws -> Response {
        try await post(path: path, queryItems: [], body: body)
    }
}

final class NetworkService: NetworkServiceType {
    private let session = URLSession.shared
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .flexibleISO8601
        return d
    }()

    func get<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T {
        let request = try buildJSONRequest(path: path, method: "GET", queryItems: queryItems, body: Optional<String>.none)
        return try await perform(request)
    }

    func post<Body: Encodable, Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem],
        body: Body
    ) async throws -> Response {
        let request = try buildJSONRequest(path: path, method: "POST", queryItems: queryItems, body: body)
        return try await perform(request)
    }
    
    func download(from url: URL) async throws -> URL {
        let (location, response) = try await URLSession.shared.download(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidURL
        }
        
        return location
    }

    // MARK: - Multipart

    func postMultipart<Response: Decodable>(
        path: String,
        queryItems: [URLQueryItem],
        textFields: [String: String],
        file: MultipartFile
    ) async throws -> Response {
        let request = try buildMultipartRequest(
            path: path,
            queryItems: queryItems,
            textFields: textFields,
            file: file
        )
        return try await perform(request)
    }

    private func buildMultipartRequest(
        path: String,
        queryItems: [URLQueryItem],
        textFields: [String: String],
        file: MultipartFile
    ) throws -> URLRequest {
        guard var components = URLComponents(string: APIConstants.baseURL + path) else {
            throw APIError.invalidURL
        }
        if !queryItems.isEmpty { components.queryItems = queryItems }
        guard let url = components.url else { throw APIError.invalidURL }

        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIConstants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let crlf = "\r\n"

        for (key, value) in textFields {
            body.append("--\(boundary)\(crlf)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(crlf)\(crlf)")
            body.append("\(value)\(crlf)")
        }

        body.append("--\(boundary)\(crlf)")
        body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\(crlf)")
        body.append("Content-Type: \(file.mimeType)\(crlf)\(crlf)")
        body.append(file.data)
        body.append(crlf)
        body.append("--\(boundary)--\(crlf)")

        request.httpBody = body
        return request
    }

    // MARK: - JSON

    private func buildJSONRequest<Body: Encodable>(
        path: String,
        method: String,
        queryItems: [URLQueryItem],
        body: Body?
    ) throws -> URLRequest {
        guard var components = URLComponents(string: APIConstants.baseURL + path) else {
            throw APIError.invalidURL
        }
        if !queryItems.isEmpty { components.queryItems = queryItems }
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
        return request
    }

    // MARK: - Perform

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
            return try decoder.decode(T.self, from: data)
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.decodingFailed(underlying: error)
        } catch {
            throw APIError.unknown(underlying: error)
        }
    }
}

private struct ValidationErrorResponse: Decodable {
    let detail: [ValidationDetail]
}

private extension JSONDecoder.DateDecodingStrategy {
    static let flexibleISO8601: JSONDecoder.DateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        let withFractional = ISO8601DateFormatter()
        withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = withFractional.date(from: raw) { return date }

        let plain = ISO8601DateFormatter()
        plain.formatOptions = [.withInternetDateTime]
        if let date = plain.date(from: raw) { return date }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unrecognized date format: \(raw)"
        )
    }
}
