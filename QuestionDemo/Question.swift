import Foundation
import SwiftyJSON

class Question: NSObject {
    let id: Int
    
    dynamic var answers: [String]?
    dynamic var correctIndexes: [Int]?
    
    init(id: Int) {
        self.id = id
    }

    static func fromJSON(_ json: [String: Any]) -> Question {
        let json = JSON(json)
        
        let id = json["id"].intValue
        let question = Question(id: id)
        
        question.answers = json["answers"].array?.map { $0.stringValue }
        question.correctIndexes = json["correctIndexes"].array?.map { $0.intValue }
        
        return question
    }
    
    func updateWithValues(newQuestion: Question) {
        answers = newQuestion.answers
        correctIndexes = newQuestion.correctIndexes
    }
}
