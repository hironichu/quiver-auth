import AsyncHTTPClient
import Foundation

struct QuiverAuthHTTPResponse: Sendable {
    let statusCode: Int
    let body: Data
}

enum QuiverAuthHTTPClient {
    private static let maxResponseBytes = 10 * 1024 * 1024

    static func get(
        url: URL,
        headers: [(String, String)] = []
    ) async throws -> QuiverAuthHTTPResponse {
        var request = HTTPClientRequest(url: url.absoluteString)
        request.method = .GET
        for (name, value) in headers {
            request.headers.add(name: name, value: value)
        }
        return try await execute(request)
    }

    static func post(
        url: URL,
        headers: [(String, String)] = [],
        body: Data
    ) async throws -> QuiverAuthHTTPResponse {
        var request = HTTPClientRequest(url: url.absoluteString)
        request.method = .POST
        for (name, value) in headers {
            request.headers.add(name: name, value: value)
        }
        request.body = .bytes(body)
        return try await execute(request)
    }

    private static func execute(_ request: HTTPClientRequest) async throws -> QuiverAuthHTTPResponse {
        let response = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        let body = try await response.body.collect(upTo: maxResponseBytes)
        return QuiverAuthHTTPResponse(
            statusCode: Int(response.status.code),
            body: Data(body.readableBytesView)
        )
    }
}