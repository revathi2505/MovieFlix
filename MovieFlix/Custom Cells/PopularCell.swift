//
//  PopularCell.swift
//  MovieFlix
//
//  Created by Revathi on 01/04/22.
//

import UIKit

protocol MovieCellDelegate : class {
    func movieCellDidTapDelete(for cell: PopularCell)
    func movieCellDidTapDelete(for cell: UnpopularCell)
}

class PopularCell: UICollectionViewCell {
 
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func didTapDeleteButton(_ sender: Any) {
        delegate?.movieCellDidTapDelete(for: self)
    }
    
    var representedIdentifier = 0
    
    weak var delegate: MovieCellDelegate?
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var image: UIImage? {
        didSet {
            backdropImageView.image = image
        }
    }

}
