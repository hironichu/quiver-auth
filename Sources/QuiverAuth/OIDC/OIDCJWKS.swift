import Foundation

actor OIDCJWKSCache {
    static let shared = OIDCJWKSCache()

    private struct CacheEntry {
        let expiresAt: Date
        let jwks: OIDCJWKS
    }

    private var entries: [String: CacheEntry] = [:]

    func getJWKS(url: URL, ttlSeconds: Int) async throws -> OIDCJWKS {
        let cacheKey = url.absoluteString
        if let cached = entries[cacheKey], cached.expiresAt > Date() {
            return cached.jwks
        }

        let response = try await QuiverAuthHTTPClient.get(url: url)
        let decoded = try JSONDecoder().decode(OIDCJWKS.self, from: response.body)
        let expiry = Date().addingTimeInterval(TimeInterval(max(1, ttlSeconds)))
        entries[cacheKey] = CacheEntry(expiresAt: expiry, jwks: decoded)
        return decoded
    }
}
