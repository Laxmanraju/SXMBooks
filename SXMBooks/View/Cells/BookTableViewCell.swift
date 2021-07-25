//
//  BookTableViewCell.swift
//  SXMBooks
//
//  Created by Laxman Penmetsa on 7/25/21.
//

import UIKit
import Kingfisher

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
        
    var bookModel: Item? {
        didSet{
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        titleLabel.text = bookModel?.volumeInfo?.title
        authorsLabel.text = bookModel?.volumeInfo?.authors?.joined(separator: " & ")
        if let urlString = bookModel?.volumeInfo?.imageLinks?.smallThumbnail,
           let imageURL = URL(string: urlString){
            KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil, completionHandler: { [weak self] result in
                switch result {
                case .success(let value):
                    self?.logoView.image = value.image
                case .failure(_):
                    self?.logoView.image = UIImage(named: "book.png")
                }
            })
        } else {
            self.logoView.image = UIImage(named: "book.png")
        }
       
    }
    
}
