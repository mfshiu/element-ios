//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Combine
import Foundation

class MockTemplateRoomChatService: TemplateRoomChatServiceProtocol {
    let roomName: String? = "New Vector"
    
    static let amadine = TemplateRoomChatMember(id: "@amadine:tprai.org", avatarUrl: "!aaabaa:tprai.org", displayName: "Amadine")
    static let mathew = TemplateRoomChatMember(id: "@mathew:tprai.org", avatarUrl: "!bbabb:tprai.org", displayName: "Mathew")
    static let mockMessages = [
        TemplateRoomChatMessage(id: "!0:tprai.org", content: .text(TemplateRoomChatMessageTextContent(body: "Shall I put it live?")), sender: amadine, timestamp: Date(timeIntervalSinceNow: 60 * -3)),
        TemplateRoomChatMessage(id: "!1:tprai.org", content: .text(TemplateRoomChatMessageTextContent(body: "Yea go for it! ...and then let's head to the pub")), sender: mathew, timestamp: Date(timeIntervalSinceNow: 60)),
        TemplateRoomChatMessage(id: "!2:tprai.org", content: .text(TemplateRoomChatMessageTextContent(body: "Deal.")), sender: amadine, timestamp: Date(timeIntervalSinceNow: 60 * -2)),
        TemplateRoomChatMessage(id: "!3:tprai.org", content: .text(TemplateRoomChatMessageTextContent(body: "Ok, Done. 🍻")), sender: amadine, timestamp: Date(timeIntervalSinceNow: 60 * -1))
    ]
    var roomInitializationStatus: CurrentValueSubject<TemplateRoomChatRoomInitializationStatus, Never>
    var chatMessagesSubject: CurrentValueSubject<[TemplateRoomChatMessage], Never>

    init(messages: [TemplateRoomChatMessage] = mockMessages) {
        roomInitializationStatus = CurrentValueSubject(.notInitialized)
        chatMessagesSubject = CurrentValueSubject(messages)
    }
    
    func send(textMessage: String) {
        let newMessage = TemplateRoomChatMessage(id: "!\(chatMessagesSubject.value.count):tprai.org", content: .text(TemplateRoomChatMessageTextContent(body: textMessage)), sender: Self.amadine, timestamp: Date())
        chatMessagesSubject.value += [newMessage]
    }
    
    func simulateUpdate(initializationStatus: TemplateRoomChatRoomInitializationStatus) {
        roomInitializationStatus.value = initializationStatus
    }
    
    func simulateUpdate(messages: [TemplateRoomChatMessage]) {
        chatMessagesSubject.value = messages
    }
}
