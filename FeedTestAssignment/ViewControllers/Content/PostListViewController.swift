//
//  PostListViewController.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "FeedCollectionViewCellReuseIdentifier"

class PostListViewController: UIViewController, PostListDataSourceDelegate {

    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate lazy var dataSource: PostListDataSource = {
        let ds = PostListDataSource()
        ds.delegate = self
        return ds
    }()
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(PostListViewController.refreshData), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FeedCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView.refreshControl = refreshControl
        
        dataSource.refresh()
    }
    
    // MARK: - Actions
    @IBAction func logout() {
        CurrentUser.clear()
        CoreDataManager.shared.clear()
        UIManager.showStartScreen()
    }
    
    @objc func refreshData() {
        dataSource.refresh()
    }
    
    func didFinishLoading() {
        refreshControl.endRefreshing()
    }
}

extension PostListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.postsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        
        let post = dataSource.post(at: indexPath.row)
        cell.setup(with: post)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource.willDisplay(row: indexPath.row)
    }
}

extension PostListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cachedHeight = dataSource.post(at: indexPath.row).cachedHeight
        
        return CGSize(width: collectionView.frame.width, height: CGFloat(cachedHeight))
    }
}
