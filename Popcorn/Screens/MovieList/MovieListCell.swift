//
//  MovieListCell.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 20.01.2023.
//

import UIKit
import SnapKit
import SkeletonView

@MainActor
class MovieListCell: UITableViewCell {
    
    static let reuseIdentifier: String = "movieListCell"
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        
        return view
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        
        contentView.addSubview(containerView)

        containerView.addArrangedSubview(posterImageView)
        containerView.addArrangedSubview(nameLabel)

        containerView.snp.makeConstraints({
            $0.left.top.equalToSuperview().offset(16)
            $0.right.bottom.equalToSuperview().offset(-16).priority(.high)
        })

        posterImageView.snp.makeConstraints({
            $0.height.equalTo(187.5).priority(.high)
            $0.width.equalTo(127.5)
        })
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        containerView.isSkeletonable = true
        posterImageView.isSkeletonable = true
        nameLabel.isSkeletonable = true
        nameLabel.skeletonTextNumberOfLines = 3
    }
    
    
    func setImage(with image: UIImage) {
        posterImageView.image = image
    }
    
    func setName(with name: String) {
        nameLabel.text = name
    }
}
