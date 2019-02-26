//
//  CoreDataManager.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

import CoreData

class CoreDataManager {

    private static var _shared: CoreDataManager!
    static var shared: CoreDataManager {
        return _shared
    }
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer
    
    lazy var backgroundContext: NSManagedObjectContext = {
        
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private var viewContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("Context save error: \(error)")
            }
        }
    }
    
    // MARK: - Initializer
    private init(inMemory:Bool = false) {
        persistentContainer = NSPersistentContainer(name: "FeedTestAssignment")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    class func initStack(inMemory: Bool = false) {
        _shared = CoreDataManager()
    }
    
    // MARK: - FRC
    func feedFRC() -> NSFetchedResultsController<Post> {
        
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        let dateSort = NSSortDescriptor(key: "publishedAt", ascending: false)
        request.sortDescriptors = [dateSort]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func clear() {
        // Quick implementation for data wipe on logout
        let postsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Post.entityName())
        let deleteAllPostsRequest = NSBatchDeleteRequest(fetchRequest: postsRequest)
        let _ = try? persistentContainer.persistentStoreCoordinator.execute(deleteAllPostsRequest, with: backgroundContext)
        
        let usersRequest = NSFetchRequest<NSFetchRequestResult>(entityName: User.entityName())
        let deleteAllUsersRequest = NSBatchDeleteRequest(fetchRequest: usersRequest)
        let _ = try? persistentContainer.persistentStoreCoordinator.execute(deleteAllUsersRequest, with: backgroundContext)
    }
    
    
    // MARK: - Data storing
    func saveOwn(post: PostResponseModel) {
        
        let context = backgroundContext
        context.perform {
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: Post.entityName(), into: context) as? Post
            entity?.postID = post.postID
            entity?.content = post.content
            entity?.publishedAt = post.publishedAt
            entity?.user = self.user(from: post.user, in: context)
            entity?.cachedHeight = FeedCollectionViewCell.calculatedHeight(for: post.content)
            
            try? context.save()
        }
    }
    
    func saveFeed(from model: ArrayResponse<FeedResponseModel>) {
        guard let models = model.array else {
            return
        }
        
        let context = backgroundContext
        context.perform {
            
            for item in models {
                self.feedItem(from: item, in: context)
            }
            
            try? context.save()
        }
    }
    
    @discardableResult func feedItem(from model: FeedResponseModel,
                  in context: NSManagedObjectContext) -> Post? {
        
        var post: Post?
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postID == %@", model.postID)
        let posts = try? context.fetch(fetchRequest)
        if let item = posts?.first {
            
            post = item
        } else {
            post = NSEntityDescription.insertNewObject(forEntityName: Post.entityName(), into: context) as? Post
        }
        
        post?.postID = model.postID
        post?.content = model.content
        post?.publishedAt = model.publishedAt
        post?.cachedHeight = FeedCollectionViewCell.calculatedHeight(for: model.content)
        
        post?.user = user(from: model.user, in: context)
        
        return post
    }
    
    @discardableResult func user(from model: UserResponseModel, in context: NSManagedObjectContext) -> User? {
        
        var user: User?
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", model.userID)
        let users = try? context.fetch(fetchRequest)
        
        if let item = users?.first {
            
            user = item
        } else {
            user = NSEntityDescription.insertNewObject(forEntityName: User.entityName(), into: context) as? User
        }
        
        user?.userID = model.userID
        user?.name = model.userName
        
        return user
    }
}
