//
//  RestaurantTableCell.swift
//  Hypto
//
//  Created by Vigneshkumar G on 25/03/19.
//  Copyright © 2019 viki. All rights reserved.
//
import UIKit

class RestaurantTableCell: UITableViewCell {
    
    lazy var photoView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    @IBOutlet weak var photoHolderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    private var model: Restarunt? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoHolderView.addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: photoHolderView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: photoHolderView.trailingAnchor),
            photoView.topAnchor.constraint(equalTo: photoHolderView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: photoHolderView.bottomAnchor),
            ])
    }
    
    func set(restaurant: Restarunt)  {
        self.model = restaurant
        nameLabel.text = restaurant.name
        ratingLabel.text = restaurant.ratingText
        guard let _ = URL(string: restaurant.featured_image) else {
            //            photoView.image = UIImage(named: "template.jpg")
            return
        }
        let request = HTTPRequest(url: restaurant.featured_image, parameters: [:])
        request.execute { result in
            if let data = result.get(), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if self.model == restaurant {
                        self.photoView.image = image
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoView.image = nil
    }
}
