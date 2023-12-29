//
//  BookCell.swift
//  Capstone Project - Group 3
//
//  Created by user934517 on 11/25/23.
//

import UIKit
import Nuke

class BookCell: UICollectionViewCell {
    
    @IBOutlet weak var bookCellAuthor: UILabel!
    @IBOutlet weak var bookCellName: UILabel!
    @IBOutlet weak var bookCellImage: UIImageView!
    
    func configure(with book: Book) {
        
        bookCellName.text = book.name
        bookCellAuthor.text = book.author
        
        guard let imageURL = URL(string: book.cover!) else { return print("error getting cover") }
        
        Nuke.loadImage(with: imageURL, into: bookCellImage)
        }

}
