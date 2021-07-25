//
//  ViewController.swift
//  SXMBooks
//
//  Created by Laxman Penmetsa on 7/24/21.
//

import UIKit

protocol ListViewProtocol {
    var books: [Item] { get set }
    var bookService : BookService { get set }
    var queryString: String { get set }
    
    /// Called after debounce timer for search bar is fired.
    func fetchBooks()
    
    /// Called after getting the response for the search query.
    ///
    /// - Parameters:
    ///   - books: The books array model.
    func populateBooks(_ books: Books)
}

class ListViewController: UITableViewController, ListViewProtocol {
    /// Reference  to Detail View Controller
    var detailViewController: DetailViewController? = nil
    
    /// Initiating the SearchController
    let searchController = UISearchController(searchResultsController: nil)

    /// Initiating the Data source for table view
    var books = [Item]()
    
    /// Initiating the service for making the api calls
    var bookService = BookService()
    
    /// Debounce timer needed for making the API calls at a specified interval.
    /// Rather than for every charater enterd by user
    weak var debounceTimer: Timer?
    
    /// Need this global var as we cannot pass the arguments to the @obj c selectors
    var queryString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = StringLiterals.searchBooks
        
        // Hiding empty cells in table view
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: "BookTableViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc func fetchBooks() {
        guard queryString != "" else { return }
        print("fetchbbooks for \(queryString)")
        bookService.getBooksForSearch(text: queryString) {[weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let books):
                self.books = books.items
                self.populateBooks(books)
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(error.localizedDescription)
            }
        }
    }
    
    func populateBooks(_ books: Books){
       reloadTableView()
    }
    
    fileprivate func reloadTableView() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }

    fileprivate func showAlert(_ errorString: String){
        
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StringLiterals.showDetail {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! DetailViewController
                controller.book = books[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell") as! BookTableViewCell
        cell.bookModel = books[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:  StringLiterals.showDetail, sender: nil)
    }
}

extension ListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        debounceTimer?.invalidate()
        queryString = searchController.searchBar.text ?? ""
        let nextTimer = Timer.scheduledTimer(timeInterval: 0.6,
                                             target: self,
                                             selector: #selector(fetchBooks),
                                             userInfo: nil,
                                             repeats: false)
        debounceTimer = nextTimer
    }
    
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Clear all table contents if x button is pressed
        if searchText.isEmpty {
            books.removeAll()
            reloadTableView()
        }
    }
}
