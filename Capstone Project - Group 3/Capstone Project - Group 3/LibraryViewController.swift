//
//  PosterViewController.swift
//  Unit 2 Flixster Pt 1
//
//  Created by user934517 on 9/19/23.
//

import UIKit
import Nuke

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var books = [Book]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            readingCollection.reloadData()
        }
    }
    
    var selectedBook = Book()
    
    @IBOutlet weak var statusSlider: UISegmentedControl!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var readingCollection: UICollectionView!
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // Handle the selection of the cell at indexPath
        let book = books[indexPath.row]
        
        selectedBook = book
        
        lblName.text = book.name
        lblAuthor.text = book.author
        
        print(book.status?.description)
                
        if book.status == "Reading" {
            statusSlider.selectedSegmentIndex = 0
        }
        else {
            statusSlider.selectedSegmentIndex = 1
        }
           // Add any other actions you want to perform when a cell is selected
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readingCollection.dataSource = self
        readingCollection.delegate = self // Set the delegate to self

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        queryBooks()
        readingCollection.reloadData()
        
        statusSlider.selectedSegmentIndex = 0
    }
    


    
    private func queryBooks() {
        let query = Book.query().include("objectID")

        // Fetch objects (posts) defined in query (async)
        query.find { [weak self] result in
            switch result {
            case .success(let books):
                // Update local posts property with fetched posts
                self?.books = books
                
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
        
        
 
        //Set layouts for collections
        let layout = readingCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: ((readingCollection.bounds.height/4)), height: (readingCollection.bounds.height))
        
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
    @IBAction func statusChanged(_ sender: Any) {
        
        //Change status of selected book in database
        
        var status = "Completed"
        
        if statusSlider.selectedSegmentIndex == 0 {
            status = "Reading"
        }
        
        selectedBook.status = status
    
            
        selectedBook.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Book Saved! \(post)")

                    // Return to previous view controller
                    self!.dismiss(animated: true, completion: nil)

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
        
        
    }
    
    }
        
    

