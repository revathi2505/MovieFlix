//
//  UnpopularCell.swift
//  MovieFlix
//
//  Created by Revathi on 01/04/22.
//

import UIKit

class UnpopularCell: UICollectionViewCell {
    //MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    
    //MARK: - Internal Parameters
    weak var delegate: MovieCellDelegate?
    
    //MARK: - External Paramters
    
    var representedIdentifier = 0
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var overview: String? {
        didSet {
            overviewLabel.text = overview
        }
    }
    
    var image: UIImage? {
        didSet {
            posterImageView.image = image
        }
    }
    
    //MARK: - Delete Button Action
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        delegate?.movieCellDidTapDelete(for: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
}
