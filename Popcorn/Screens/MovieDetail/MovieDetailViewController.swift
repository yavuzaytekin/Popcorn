//
//  MovieDetailViewController.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 21.01.2023.
//

import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    
    let movieTitleLabel = UILabel()
    let moviePoster = UIImageView()
    
    var viewModel: MovieDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        viewModel.load()
    }
}

//MARK: - Configure Views
extension MovieDetailViewController {
    func setupViews() {
        addSubViews()
        configureMoviePosterImageView()
        configureMovieTitleLabel()
    }
    
    func addSubViews() {
        view.addSubview(moviePoster)
        view.addSubview(movieTitleLabel)
    }
    
    func configureMoviePosterImageView() {
        moviePoster.layer.cornerRadius = 8
        moviePoster.clipsToBounds = true
        
        moviePoster.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        })
    }
    
    func configureMovieTitleLabel() {
        movieTitleLabel.text = "PlaceHolder"
        movieTitleLabel.snp.makeConstraints({
            $0.top.equalTo(moviePoster.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        })
        
    }
}

//MARK: - MovieDetailViewModelDelegate
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func showDetail(_ presentation: MovieDetailPresentation) {
        movieTitleLabel.text = presentation.title
        moviePoster.image = UIImage(data: presentation.posterData)
    }
}
