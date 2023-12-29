//
//  PosterViewController.swift
//  Unit 2 Flixster Pt 1
//
//  Created by user934517 on 9/19/23.
//

import UIKit
import Nuke

class StreamViewController: UIViewController, UICollectionViewDataSource {
    
    var books: [Book] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // the number of items shown should be the number of albums we have.
        books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Get a collection view cell (based in the identifier you set in storyboard) and cast it to our custom AlbumCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell

        // Use the indexPath.item to index into the albums array to get the corresponding album
        let book = books[indexPath.item]

        // Get the artwork image url
        let imageUrl = URL(string: book.cover!)!
        
        // Set the image on the image view of the cell
        Nuke.loadImage(with: imageUrl, into: cell.bookCellImage)

        return cell
    }
    


    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self

        let headers = [
            "X-RapidAPI-Key": "8a9928d11emshb3e934d8a817504p12d073jsnab6d8a6b041f",
            "X-RapidAPI-Host": "hapi-books.p.rapidapi.com"
        ]

        let url = URL(string: "https://hapi-books.p.rapidapi.com/nominees/fiction/2020")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared

        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if there is response data
            guard let data = data else {
                print("No data in response")
                return
            }

            do {
                let decoder = JSONDecoder()
                    let books = try decoder.decode([Book].self, from: data)

                    DispatchQueue.main.async {
                        self.books = books
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("JSON decoding error: \(error)")
                    let responseString = String(data: data, encoding: .utf8)
                    print("Raw Response Data:")
                    print(responseString ?? "Unable to convert data to string")
                
            }
        }

        dataTask.resume()

        // Get a reference to the collection view's layout
        // We want to dynamically size the cells for the available space and desired number of columns.
        // NOTE: This collection view scrolls vertically, but collection views can alternatively scroll horizontally.
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        // The minimum spacing between adjacent cells (left / right, in vertical scrolling collection)
        // Set this to taste.
        layout.minimumInteritemSpacing = 0

        // The minimum spacing between adjacent cells (top / bottom, in vertical scrolling collection)
        // Set this to taste.
        layout.minimumLineSpacing = 0

        // Calculate the width each cell need to be to fit the number of columns, taking into account the spacing between cells.
        //let width = (collectionView.bounds.width) / 3
        
        // Set the size that each tem/cell should display at
        //layout.itemSize = CGSize(width: ((collectionView.bounds.width/2) - 15), height: ((collectionView.bounds.width/2) - 14)*1.5)
        layout.itemSize = CGSize(width: ((collectionView.bounds.width/2)), height: (((collectionView.bounds.width/2)*1.5)))
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Pt 1 - Pass the selected track to the detail view controller
        if let cell = sender as? UICollectionViewCell,
           // Get the index path of the cell from the table view
           let indexPath = collectionView.indexPath(for: cell),
           // Get the detail view controller
           let detailViewController = segue.destination as? DetailViewController {

            // Use the index path to get the associated track
            let book = books[indexPath.row]

            // Set the track on the detail view controller
            detailViewController.book = book
            
            detailViewController.senderVC = "stream"

        }

    }
    
    
    
}
