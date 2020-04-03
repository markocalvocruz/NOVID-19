//
//  ViewController.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/13/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var host = "spreadsheets.google.com"
    var id = "1GNOa-8FtKdLDesBfcoXNgquA1RxF3JZp4MzxWPTjXvw"
    var sheet: Int = 1
    var products: [Entry] = []
    //var sections: [String] { return Array(Set(filteredProducts.map {String(($0.gsx$companydistributor?.t?.first ?? Character(" ")))})).sorted()}
    var filteredProducts: [Entry] = []
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        guard let url = prepareURL() else { preconditionFailure("Failed to construct URL") }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let data = data {
                do {
                    let responseModel = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                    guard let entries = responseModel.feed?.entry else { fatalError("Could not retrieve products")}
                    self?.products = entries
                    self?.filteredProducts = []//entries
                   // print(self?.sections)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    print("decoded")
                } catch {
                    print(error)
                }
            }
            else {
                print(error?.localizedDescription)
            }
        

        }.resume()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        print("finished")
    }

    private func prepareURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/feeds/list/\(id)/\(sheet)/public/full"
        components.queryItems = [URLQueryItem(name: "alt", value: "json")]
        print(components.url)
        return components.url

    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "product_cell") as? ProductTableViewCell else { fatalError() }
        let product = filteredProducts[indexPath.row]
        cell.product = product
        return cell
    }

//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return sections
//    }
      

    
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredProducts = searchText.isEmpty ? CoreApp.products : CoreApp.products.filter({(product: Entry) -> Bool in
                return product.name?.t!.range(of: searchText, options: .caseInsensitive) != nil
            })
        }
        tableView.reloadData()
    }
    
    
}
    
