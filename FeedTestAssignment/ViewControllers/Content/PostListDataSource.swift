//
//  PostListDataSource.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

import CoreData

protocol PostListDataSourceDelegate: class {
    var collectionView: UICollectionView! { get }
    func didFinishLoading()
}

class PostListDataSource: NSObject {

    weak var delegate: PostListDataSourceDelegate?
    private var currentPage = -1
    static var pageSize = 20
    
    fileprivate var blockOperations = [BlockOperation]()
    
    fileprivate lazy var frc: NSFetchedResultsController<Post> = {
        
        let fetchedController = CoreDataManager.shared.feedFRC()
        fetchedController.delegate = self
        try? fetchedController.performFetch()
        
        return fetchedController
    }()
    
    deinit {
        for operation in blockOperations {
            operation.cancel()
        }
        self.blockOperations.removeAll(keepingCapacity: false)
    }
    
    // MARK: - Data accessors
    var posts: [Post] {
        return frc.fetchedObjects ?? []
    }
    
    func postsCount() -> Int {
        return posts.count
    }
    
    func post(at: Int) -> Post {
        return posts[at]
    }
    
    func refresh() {
        
        currentPage = -1
        loadNextPage()
    }
    
    func willDisplay(row: Int) {
        
        let pageHalf = currentPage * PostListDataSource.pageSize - PostListDataSource.pageSize / 2
        
        if row == pageHalf {
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        let model = FeedRequestModel()
        model.offset = (currentPage + 1) * PostListDataSource.pageSize
        model.limit = PostListDataSource.pageSize
        
        NetworkManager.instance.execute(requestModel: model, completion: { [weak self] (response: ArrayResponse<FeedResponseModel>?) in
            
            guard let model = response else {
                return
            }
            
            CoreDataManager.shared.saveFeed(from: model)
            
            self?.delegate?.didFinishLoading()
            
            // Hint for FRC
            if let count = self?.postsCount(),
                count == 0 {
                try? self?.frc.performFetch()
            }
            
            self?.currentPage += 1
        })
    }
}

extension PostListDataSource: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let collectionView = delegate?.collectionView,
            let indexPath = newIndexPath else {
                return
        }
        
        switch type {
        case .insert:
            let operation = BlockOperation {
                collectionView.insertItems(at: [indexPath])
            }
            blockOperations.append(operation)
        case .delete:
            let operation = BlockOperation {
                collectionView.deleteItems(at: [indexPath])
            }
            blockOperations.append(operation)
        case .move:
            let operation = BlockOperation {
                collectionView.moveItem(at: indexPath, to: newIndexPath!)
            }
            blockOperations.append(operation)
        case .update:
            let operation = BlockOperation {
                collectionView.reloadItems(at: [indexPath])
            }
            blockOperations.append(operation)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        delegate?.collectionView.performBatchUpdates({
            for operation in blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
}
