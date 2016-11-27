//
//  MasterViewController.swift
//  QuestionDemo
//
//  Created by NSWhoohoo on 28/11/2016.
//  Copyright © 2016 nswhoohoo. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import RxCocoa

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    private var questions = Variable(Array<Question>())
    
    lazy var stubData = {
        return [
            ["id": 0],
            ["id": 1]
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions
            .asObservable()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .addDisposableTo(rx_disposeBag)
        
        allListingRequest()
            .bindTo(questions)
            .addDisposableTo(rx_disposeBag)
    }
    
    func allListingRequest() -> Observable<[Question]> {
        return Observable.just(stubData)
            .map { $0.map { Question.fromJSON($0) } }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let question = questions.value[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.question = question
            }
        }
    }

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = "Question: \(indexPath.item)"
        return cell
    }

}
