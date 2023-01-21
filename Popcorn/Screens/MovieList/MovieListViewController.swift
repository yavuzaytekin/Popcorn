//
//  MovieListViewController.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import UIKit
import SnapKit
import SkeletonView

class MovieListViewController: UIViewController {
    
    let moviesTableView: UITableView = UITableView()
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    let searchController = UISearchController(searchResultsController: nil)
    let searchBtn: UIButton = UIButton()
    
    var searchBtnBottomConstraint: Constraint?

    private var movieList: [MoviePresentation] = []
    var viewModel: MovieListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        
        viewModel.load()

        addSkeletonSample()
    }
    
    private func addSkeletonSample() {
        moviesTableView.isSkeletonable = true
        moviesTableView.showAnimatedGradientSkeleton()
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await viewModel.searchMovies(with: "Batman")
            moviesTableView.stopSkeletonAnimation()
            view.hideSkeleton()
        }
    }
}

//MARK: - Configure Views
extension MovieListViewController {
    func setupViews() {
        addSubViews()
        
        configureMoviesTableView()
        configureLoadingIndicator()
        configureSearchBar()
        configureSearchBtn()
    }
    
    func addSubViews() {
        view.addSubview(moviesTableView)
        view.addSubview(loadingIndicator)
        view.addSubview(searchBtn)
    }
    
    func configureMoviesTableView() {
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 100
        
        
        moviesTableView.register(MovieListCell.self, forCellReuseIdentifier: "movieListCell")
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        moviesTableView.snp.makeConstraints({
            $0.left.right.top.bottom.equalToSuperview()
        })
    }
    
    func configureLoadingIndicator() {
        loadingIndicator.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
    
    func configureSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.enablesReturnKeyAutomatically = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func configureSearchBtn() {
        searchBtn.setTitle("Search", for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        searchBtn.backgroundColor = .green
        changeSearchBtnVisibility(isVisible: false)
        searchBtn.addTarget(self, action: #selector(handleSearchBtnTap), for: .touchDown)
        searchBtn.snp.makeConstraints({
            $0.left.right.equalToSuperview()
            self.searchBtnBottomConstraint = $0.bottom.equalToSuperview().constraint
            $0.height.equalTo(50)
        })
    }
}

//MARK: UI Changes
extension MovieListViewController {
    func changeSearchBtnVisibility(isVisible flag: Bool) {
        self.searchBtn.alpha = flag ? 1 : 0
    }
    
    func updateSearchBtnBottomConstraint(with value: Double) {
        searchBtnBottomConstraint?.update(offset: value)
    }
}

//MARK: - UITableViewDelegate UITableViewDataSource
extension MovieListViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return MovieListCell.reuseIdentifier
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movieList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.reuseIdentifier, for: indexPath) as? MovieListCell
        cell?.selectionStyle = .none
        cell?.setName(with: movie.title)
        
        Task(priority: .low) {
            if let imageData = await viewModel.fetchImage(path: movie.path) {
                cell?.setImage(with: UIImage(data: imageData)!)
            } else {
                //TODO: image error
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MovieListCell {
            if let posterData = cell.posterImageView.image?.pngData() {
                viewModel.selectMovie(at: indexPath.row, with: posterData)
            }
        }
    }
}

//MARK: - Observers
extension MovieListViewController {
    func addObservers() {
        addKeyboardObserver()
    }
    
    func addKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil, queue: .main) { (notification) in
                self.handleKeyboard(notification: notification)
            }
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil, queue: .main) { (notification) in
                self.handleKeyboard(notification: notification)
            }
    }
    
}

//MARK: Handle Observer Events
extension MovieListViewController {
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            changeSearchBtnVisibility(isVisible: false)
            updateSearchBtnBottomConstraint(with: 0)
            view.layoutIfNeeded()
            return
        }
        
        guard
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.changeSearchBtnVisibility(isVisible: true)
            self.updateSearchBtnBottomConstraint(with: -keyboardHeight)
            self.view.layoutIfNeeded()
        })
    }
}

//MARK: - Button Actions
extension MovieListViewController {
    @objc func handleSearchBtnTap() {
        searchMovie()
        searchController.searchBar.endEditing(true)
    }
}


//MARK: - UISearchBarDelegate
extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMovie()
    }
}

//MARK: - MovieListViewModelDelegate
extension MovieListViewController: MovieListViewModelDelegate {
    func handleViewModelOutput(_ output: MovieListViewModelOutput) {
        switch output {
        case .setLoading(let value):
            setLoading(with: value)
        case .updateTitle(let title):
            Task { @MainActor in
                navigationItem.largeTitleDisplayMode = .always
                navigationItem.title = title
            }
        case .showMovieList(let movies):
            self.movieList = movies
            self.reloadTableViewData()
        case .showError(let error):
            switch error {
            case .custom(let message):
                addErrorAlert(message: message)
            }
        }
    }
    
    func navigate(to route: MovieListViewRoute) {
        switch route {
        case .detail(let viewModel):
            let viewController = MovieDetailBuilder.make(with: viewModel)
            show(viewController, sender: nil)
        }
    }
}

//MARK: - Utils
extension MovieListViewController {
    private func reloadTableViewData() {
        Task { @MainActor in
            moviesTableView.reloadData()
        }
    }
    
    private func setLoading(with flag: Bool) {
        Task { @MainActor in
            flag ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    private func searchMovie() {
        if let text = searchController.searchBar.text {
            Task {
                await viewModel.searchMovies(with: text)
            }
        }
    }
}
