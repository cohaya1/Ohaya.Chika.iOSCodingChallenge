//
//  ViewController.swift
//  Ohaya.Chika.iOSCodingChallenge
//
//  Created by Makaveli Ohaya on 8/15/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//

import UIKit

class BookListsVC: UIViewController {

    var tableView = UITableView()

        var booklistdata: [BookLists] = []
        
        
        struct BookListCell{
            static let booklistscells = "BookListsCell"
            
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            configureTableView()
            getBookInfo()
            setTableViewDelegate()
           
        }
        
       
        func configureTableView() {
            view.addSubview(tableView)
            setTableViewDelegate()
            tableView.estimatedRowHeight = 130
            // create cells
            // set the contraints too
            tableView.contraint(to: view)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(BookListsCell.self, forCellReuseIdentifier: BookListCell.booklistscells)
          
            //tableView.separatorStyle = .none
            view.backgroundColor = .systemBackground
        }
       
        
    func getBookInfo() {
            BookListClient.shared.getBookListInfo() { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success( let bookList):
                    DispatchQueue.main.async {
                        self.booklistdata = bookList
                        self.tableView.reloadData()
                        
                    }
                case .failure(let error):
                    self.presentTheAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
        
        func setTableViewDelegate() {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    extension BookListsVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return booklistdata.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: BookListCell.booklistscells)as! BookListsCell
            let bookdirectory = booklistdata[indexPath.row]
            cell.configureUIElements(bookinformation: bookdirectory)
            
            return cell
            // us as to give it access to the employee cell list
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        
        
        
    }
