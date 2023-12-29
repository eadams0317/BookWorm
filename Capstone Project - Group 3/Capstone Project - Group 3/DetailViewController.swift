//
//  DetailViewController.swift
//  Capstone Project - Group 3
//
//  Created by user934517 on 11/27/23.
//

import UIKit
import Nuke
import ParseSwift



class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var book: Book!
    
    
    var onDismiss: (() -> Void)?
    
    
    var senderVC: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Load the image located at the `artworkUrl100` URL and set it on the image view.
        Nuke.loadImage(with: URL(string:book.cover!)!, into: image)

        // Set labels with the associated track values.
        name.text = book.name
        author.text = book.author
        
        print(senderVC)
        
        switch senderVC {
        case "profile":
            actionButton.isHidden = true
            deleteButton.isHidden = false
        case "stream":
            actionButton.isHidden = false
            actionButton.titleLabel?.text = "Add to Library"
            deleteButton.isHidden = true
        case "library":
            actionButton.isHidden = false
            
            if book.status == "reading"
            {
                actionButton.titleLabel?.text = "Assign to Completed"
            }
            else
            {
                actionButton.titleLabel?.text = "Assign to Reading Now"
            }
            
            deleteButton.isHidden = false
        default:
            print("Error with sender.")
        }
        
        
        
        


    }
    

    
    @IBAction func actionButtonPressed(_ sender: Any) {
        
        if senderVC == "stream"
        {
            //Add book to library
            
            // Create Book object
            var newBook = Book()

            // Set properties
            newBook.name = book.name
            newBook.author = book.author
            newBook.cover = book.cover
            newBook.status = "Reading"

            // Set the user as the current user
            newBook.User = User.current
                        
            // Save object in background (async)
            newBook.save { [weak self] result in

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
        else if senderVC == "library"
        {
            if book.status == "reading"
            {
                //Delete book from database and resinsert with status of "read"
            }
            else
            {
                //Delete book from database and resinsert with status of "reading"
            }
        }
        
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        

        book.delete { [self] result in
            switch result {
            case .success:
                print("Object deleted successfully")
                
                onDismiss?()
                
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print("Error deleting object: \(error)")
            }
        }
        
                
    }
    
    
}

