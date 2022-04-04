//
//  DetailVC.swift
//  MovieFlix
//
//  Created by Revathi on 01/04/22.
//

import UIKit

class DetailVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    //MARK: - External Parameters
    var selectedMovie: Movie?
 
    //MARK: - Internal Parameters
    private let networker = NetworkManager.shared
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedMovie?.title
        overviewLabel.text = selectedMovie?.overview
        releaseDateLabel.text = "Release Date: " + (selectedMovie?.releaseDate ?? "_")
        
        guard let movie = selectedMovie else { return }
        getPosterImage(for: movie)
    }
    
    //Get Poster Image
    private func getPosterImage(for movie: Movie) {
        networker.posterImage(for: movie) { [weak self] data, error in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }
        }
    }
}
