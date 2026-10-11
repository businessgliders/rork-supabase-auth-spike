import Foundation

/// Row from the `my_items` table. `id` is decoded flexibly (int or uuid/text).
nonisolated struct MyItem: Decodable, Identifiable, Sendable {
    let id: String
    let userId: String?
    let title: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intId = try? container.decode(Int64.self, forKey: .id) {
            id = String(intId)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
}

nonisolated struct NewItem: Encodable, Sendable {
    let title: String
    let userId: UUID

    enum CodingKeys: String, CodingKey {
        case title
        case userId = "user_id"
    }
}
