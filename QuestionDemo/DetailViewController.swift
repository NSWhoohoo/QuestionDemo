//
//  DetailViewController.swift
//  QuestionDemo
//
//  Created by NSWhoohoo on 28/11/2016.
//  Copyright © 2016 nswhoohoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

    var question: Question!
    
    var answerLabels = [UILabel]()
    
    var answers: Observable<[String]> {
        return question.rx.observe([String].self, "answers").map{ answers in
            if let answers = answers {
                return answers
            } else {
                return []
            }
        }
    }
    
    var correctIndexes: Observable<[Int]> {
        return question.rx.observe([Int].self, "correctIndexes").map { indexes in
            if let indexes = indexes {
                return indexes
            } else {
                return []
            }
        }
    }
    
    lazy var stubData = {
        return [
            "answers": ["AAAA", "BBBB", "CCCC", "DDDD"],
            "correctIndexes": [0, 2]
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionRequest(id: question.id)
            .subscribe(onNext: { newQuestion in
                if self.question.id == newQuestion.id {
                    self.question.updateWithValues(newQuestion: newQuestion)
                }
            })
            .addDisposableTo(rx_disposeBag)
        
        // correntIndexes.subscirbe 和 answer.subcribe 换顺序就没问题，RXSwift前一个版本顺序又不一样
        correctIndexes
            .subscribe(onNext: { indexes in
                
                indexes.forEach { index in
                    let answerLabel = self.answerLabels[index] // crash here
                    answerLabel.textColor = .green
                }
                
            })
            .addDisposableTo(rx_disposeBag)
        
        answers
            .subscribe(onNext: { answers in
                
                answers.enumerated().forEach{index, answer in
                    let label = UILabel()
                    label.frame = CGRect(x: 10, y: index * 40, width: 100, height: 40)
                    label.text = answer
                    self.answerLabels.append(label)
                    self.view.addSubview(label)
                }
                
            })
            .addDisposableTo(rx_disposeBag)
        
    }
    
    private func questionRequest(id: Int) -> Observable<Question> {
        return Observable.just(stubData)
            .map { Question.fromJSON($0) }
    }

}

