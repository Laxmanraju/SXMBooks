//
//  DetailsViewController.swift
//  SXMBooks
//
//  Created by Laxman Penmetsa on 7/24/21.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var book: Item?
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var publishDateLabel: UILabel!
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        if let info = book?.volumeInfo{
            if let urlString = info.imageLinks?.thumbnail,
               let imageURL = URL(string: urlString){
                KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil, completionHandler: { [weak self] result in
                    switch result {
                    case .success(let value):
                        self?.logoImageView.image = value.image
                    case .failure(_):
                        self?.logoImageView.image = UIImage(named: "book.png")
                    }
                })
            } else {
                self.logoImageView.image = UIImage(named: "book.png")
            }
            
            if let title = info.title{
                titleLabel.text = title
            }else{
                titleLabel.isHidden = true
            }
            
            if let subtitle = info.subtitle {
                subtitleLabel.text = subtitle
            } else {
                subtitleLabel.isHidden = true
            }
            
            if let description = info.volumeInfoDescription{
                descriptionLabel.text = description
            }
            
            if let rating = info.averageRating {
                ratingLabel.text = "Ratings: \(rating)/5"
            }else{
                ratingLabel.isHidden = true
            }
            
            if let publishDate = info.publishedDate{
                publishDateLabel.text = publishDate
            }
        }
    }    
}
