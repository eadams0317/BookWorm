//
//  ProfileViewController.swift
//  Capstone Project - Group 3
//
//  Created by user934517 on 11/11/23.
//

import UIKit
import Nuke

class ProfileViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    

    var books = [Book]() {
        didSet {
            // Reload table view data any time the books variable gets updated.
            collectionView.reloadData()
            setNums()
        }
    }
    
    @IBOutlet weak var lblBooksNum: UILabel!
    @IBOutlet weak var lblReadingNum: UILabel!
    @IBOutlet weak var lblCompletedNum: UILabel!
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
            collectionView.delegate = self // Set the delegate to self

        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryBooks()
        setNums()
    }
    
    func queryBooks(){
        
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
        
        

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        layout.minimumInteritemSpacing = 0

        layout.minimumLineSpacing = 0

        layout.itemSize = CGSize(width: ((collectionView.bounds.width/2)), height: (((collectionView.bounds.width/2)*1.5)))
        
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Pt 1 - Pass the selected track to the detail view controller
        if let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell),
            let detailViewController = segue.destination as? DetailViewController {

            let book = books[indexPath.row]

            detailViewController.book = book
            detailViewController.senderVC = "profile"

            // Set the closure to be called when the second view controller is dismissed
            detailViewController.onDismiss = { [weak self] in
                // Update UI or perform other actions after the second view controller is closed
                self?.queryBooks()
                self?.collectionView.reloadData()
                // Add more actions if needed...
            }
        }
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        showConfirmLogoutAlert()

    }

    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func setNums()
    {
        var total = Int()
        var reading = Int()
        var completed = Int()
        
        total = books.count
        lblBooksNum.text = total.description
        
        //Determine reading and completed
        for book in books{
            if book.status == "Reading"
            {
                reading += 1
            }
            else
            {
                completed += 1
            }
        }
        
        lblReadingNum.text = reading.description
        lblCompletedNum.text = completed.description
        
    }
    
    
    

    }


