//
//  ViewController.swift
//  MovieFlix
//
//  Created by Revathi on 01/04/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    //MARK: - Internal Parameters
    private let searchController = UISearchController()
    private let networker = NetworkManager.shared
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    
    //MARK: - SearchBar Setup
    private func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchController.searchBar.tintColor = .white
        definesPresentationContext = true
        
        if let searchTextfield = self.searchController.searchBar.value(forKey: "searchField") as? UITextField  {
            searchTextfield.layer.borderColor = UIColor.lightGray.cgColor
            searchTextfield.layer.borderWidth = 1
            searchTextfield.layer.cornerRadius = 10
        }
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
 
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()
        
        title = "Latest movies"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        movieCollectionView.register(UINib(nibName: "UnpopularCell", bundle: nil), forCellWithReuseIdentifier: "Unpopular")
        movieCollectionView.register(UINib(nibName: "PopularCell", bundle: nil), forCellWithReuseIdentifier: "Popular")
        
        networker.getNowPlayingMovies { [weak self] movies, error in
            if let error = error {
                print(error)
            }
            guard let movies = movies else { return }
            self?.movies = movies
            DispatchQueue.main.async {
                self?.movieCollectionView.reloadData()
            }
        }
        
    }
    
}

//MARK: - Collection view

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  searchController.isActive ? filteredMovies.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = searchController.isActive ? filteredMovies[indexPath.row] : movies[indexPath.row]
        let representedIdentifier = movie.id
        if movie.rating > 7 {
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "Popular", for: indexPath) as! PopularCell
            cell.representedIdentifier = representedIdentifier
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.isHidden = searchController.isActive
            cell.delegate = self
            cell.image = nil
            networker.backdropImage(for: movie) { [weak self] data, error in
                let img = self?.image(data: data)
                    DispatchQueue.main.async {
                        if cell.representedIdentifier == representedIdentifier {
                            cell.image = img
                        }
                    }
            }
            return cell
        } else {
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "Unpopular", for: indexPath) as! UnpopularCell
            cell.title = movie.title
            cell.overview = movie.overview
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.isHidden = searchController.isActive
            cell.representedIdentifier = representedIdentifier
            cell.image = nil
            cell.delegate = self
            networker.posterImage(for: movie) { [weak self] data, error in
                let img = self?.image(data: data)
                    DispatchQueue.main.async {
                        if cell.representedIdentifier == representedIdentifier {
                            cell.image = img
                        }
                    }
            }
            return cell
        }
        
        
    }
    
    func image(data: Data?) -> UIImage? {
        if let data = data {
            let image = UIImage(data: data)
            return image
        }
        return UIImage(named: "nssl0033")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.movieCollectionView.frame.width, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DETAIL") as? DetailVC {
            detailVC.selectedMovie = searchController.isActive ? filteredMovies[indexPath.row] : movies[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

//MARK: - Movie Cell Delegate

extension ViewController: MovieCellDelegate {
    func movieCellDidTapDelete(for cell: PopularCell) {
        if let indexPath = movieCollectionView.indexPath(for: cell) {
            deleteCell(at: indexPath)
        }
    }
    
    func movieCellDidTapDelete(for cell: UnpopularCell) {
        if let indexPath = movieCollectionView.indexPath(for: cell) {
            deleteCell(at: indexPath)
        }
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        movieCollectionView.performBatchUpdates {
            movies.remove(at: indexPath.row)
            movieCollectionView.deleteItems(at: [indexPath])
        }
    }
}

//MARK: - Search Bar Delegate
extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filterforSearchText(searchText)
    }
    
    func filterforSearchText(_ text: String) {
        filteredMovies = movies.filter({ movie in
            if searchController.searchBar.text != "" {
                let movieTitleMatch = movie.title.lowercased().contains(text.lowercased())
                return movieTitleMatch
            }
            return false
        })
        movieCollectionView.reloadData()
    }
}
