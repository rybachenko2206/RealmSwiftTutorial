//
//  PersonsViewController.swift
//  RealmSwiftApp
//
//  Created by Roman Rybachenko on 3/27/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import UIKit
import RealmSwift

class PersonsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    let rlmManager = RealmDbManager.shared
    
    var elements: Results<Person>?
     var notificationTokenPersons: NotificationToken? = nil

    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(PersonCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = PersonCell.height()

        elements = rlmManager.getAll(ofType: Person.self)
        
        notificationTokenPersons = elements?.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(let obj, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                print("first value -> \(obj)")
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                let toReload = modifications.map({
                    return IndexPath(row: $0, section: 0)
                })
                tableView.reloadRows(at: toReload, with: .automatic)
                
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
        if elements?.count == 0 {
            createPersons()
        }
        
        let allBooks = rlmManager.getAll(ofType: Book.self)
        if allBooks?.count == 0 {
            createBooksAndAuthors()
        }
        
        
        let genderKey = "rlmGender"
        guard let aMan = rlmManager.realm.objects(Person.self).filter("%K = %@", genderKey, Gender.male.rawValue).last else { return }
        
        guard let aWoman = rlmManager.realm.objects(Person.self).filter("%K = %@", genderKey, Gender.female.rawValue).last else { return }
        
        aMan.addInRelationshipWith(nil)
        aWoman.addInRelationshipWith(nil)
        
        
//        let authors = rlmManager.getAll(ofType: Author.self)
//        print(authors)
//        print(elements)
//        print("\n~~ followers -> \n\(authors?.first?.followers)")
//        print("\n~~writtenBooks -> \n\(authors?.first?.writtenBooks)")
    }
    
    deinit {
        notificationTokenPersons?.stop()
    }

    private func createPersons() {
        let p1 = Person.init(firstName: "Ольга",
                             lastName: "Іваненко",
                             gender: .female,
                             birthday: Date.init(timeIntervalSince1970: 580521600))
        RealmDbManager.shared.saveObject(p1)
        
        let p2 = Person.init(firstName: "Максим",
                             lastName: "Ковальчук",
                             gender: .male,
                             birthday: Date.init(timeIntervalSince1970: 393552000))
        rlmManager.saveObject(p2)
        
        let p3 = Person.init(firstName: "Дарина",
                             lastName: "Петренко",
                             gender: .female,
                             birthday: Date.init(timeIntervalSince1970: 640656000))
        rlmManager.saveObject(p3)
        
        let p4 = Person.init(firstName: "Семен",
                             lastName: "Палій",
                             gender: .male,
                             birthday: Date.init(timeIntervalSince1970: 488160000))
        let p5 = Person.init(firstName: "Іван",
                             lastName: "Чучупака",
                             gender: .male,
                             birthday: Date.init(timeIntervalSince1970: 460339200))
        rlmManager.saveObjects([p4, p5])
    }
    
    private func createBooksAndAuthors() {
        let person1 = Person(firstName: "Артем",
                             lastName: "Каменістий",
                             gender: .male,
                             birthday: Date.init(timeIntervalSince1970: 187401600))
        let author1 = Author(person: person1)
        
        let p2 = Person(firstName: "Мария",
                        lastName: "Семенова",
                        gender: .female,
                        birthday: Date.init(timeIntervalSince1970: 0))
        let author2 = Author(person: p2)
        
        guard let allPerson = rlmManager.getAll(ofType: Person.self) else { return }
        for p in allPerson {
            if p.id != person1.id {
                try! rlmManager.realm.write {
                    p.favoriteAuthors.append(author1)
                }
            }
        }
     
        
        let book1 = Book()
        book1.genre = "fantasy"
        book1.bookId = UUID().uuidString
        book1.pages = 655
        book1.price = 200
        book1.title = "Волкодав"
        book1.author = author2
        
        let book2 = Book()
        book2.bookId = UUID().uuidString
        book2.pages = 320
        book2.price = 100
        book2.title = "С викингами на Свальбард"
        book2.genre = "historical novel"
        book2.author = author2
        
        let book3 = Book()
        book3.bookId = UUID().uuidString
        book3.pages = 310
        book3.price = 55
        book3.title = "Горечь пепла"
        book3.genre = "fantasy"
        book3.author = author1
        
        let book4 = Book()
        book4.bookId = UUID().uuidString
        book4.pages = 250
        book4.price = 55
        book4.title = "Чужих гор пленники"
        book4.genre = "adventures"
        book4.author = author1
        
        rlmManager.saveObjects([book1, book2, book3, book4])
        rlmManager.saveObjects([author1, author2])
        
        
        //////////////////////////////////
        
        for p in allPerson {
            p.addReadBook(book1)
        }
        allPerson.first?.addReadBook(book4)
        allPerson[1].addReadBook(book3)
        
        allPerson.last?.addReadBook(book1)
        
    }

}

extension PersonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let els = self.elements else {
            return 0
        }
        return els.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeReusableCell(forIndexPath: indexPath) as PersonCell
        cell.person = elements?[indexPath.row]
        
        return cell
    }
}

extension PersonsViewController: UITableViewDelegate {
    
}


