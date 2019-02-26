# FeedTestAssignment

Simple application which shows main principes of work.

Time spent 13h47m

Note: Don't forget to install cocoapods!

Project doesn't use any real service to fetch data. If You need work with real service - update Request class and remove FakeNetworkEngine in AppDelegate.
You can find example of Unit Tests in FeedTestAssignmentTests folder.

To check invalid login credentials just use "wrong" (without quotes) as password for any username.

Main features:
- Storyboards divided to 2 files (Auth and Main) to support different app flows.

- Extensions folder contains useful extensions in one place.

- Network manager demonstrates lightweight wrapper over Network stack. Implements model based interaction with server. Use sublass of RequestModel to query data and ResponseModel to parse request. Don't forget to configure Request class in real project (change baseURL).

- CoreDataManager demonstrates common principe of local storage. Used for data fetch and storing in background to prevent UI lock.

- UIManager - simple fabric for UI stack. Can display Authorization flow or Main app flow.

- PostListViewController demonstrates displaying of structured content. Subclassed from UICollectionView to simplify layout changes if needed.

- PostListDataSource demonstrates simple principe of pagination. Fast for implementation but bad for real environment due to possibility of race condition when network request fails and local storage used. Possible solution is to use timestamp based requests for paging.

- CurrentUser demonstrates one of possible ways to store sensitive data in keychain.

- FeedCollectionViewCell is a simple implementation of CollectionView cell. Has class func calculatedHeight(for text: String) -> Float to calculate cell height for caching.

- ProgressHUD is a lightweight implementation of custom HUD. 

- Post model has cachedHeight paramether to reduce amount of cell height calculation operations.

Supported server structure (GET method should use query params, POST - body):

/feed

Method: GET

Params example:

?offset=0&limit=10

Response example:

[{"user":{"user_name":"D3pjxn6l","user_id":"yMAerDUG"},"content":"Some text","post_id":"PCgmNuXw","published_at":"26-02-2019T16:38:39"}]

/login

Method: POST

Params example:

{"email":email, "password":password}

Response example:

{"token":"askjh"}

/feed

Method: POST

Params example:

{"text":content}

Response example:

{"user":{"user_name":"D3pjxn6l","user_id":"yMAerDUG"},"content":"Some text","post_id":"PCgmNuXw","published_at":"26-02-2019T16:38:39"}
