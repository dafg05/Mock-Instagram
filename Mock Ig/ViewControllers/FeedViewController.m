//
//  FeedViewController.m
//  Mock Ig
//
//  Created by Daniel Flores Garcia on 6/27/22.
//

#import "SceneDelegate.h"
#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "PostDetailsViewController.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, PostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) NSArray *postsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postTableView.dataSource = self;
    self.postTableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.postTableView insertSubview:refreshControl atIndex:0];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query includeKey:@"author"];
//    [query orderByDescending:@"createdAt"];
//    query.limit = 20;

    [self queryPosts];
}

- (void)queryPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.postsArray = posts;

            [self.postTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.postsArray = posts;
            [self.postTableView reloadData];
            [refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error != nil){
            NSLog(@"Logout Error: %@", error.localizedDescription);
        }
        else{
            SceneDelegate *sceneDelegate = (SceneDelegate *) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginViewController;
            NSLog(@"Logout success!!!");
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Post Cell"  forIndexPath:indexPath];
    Post *post = self.postsArray[indexPath.row];
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error){
        if (error != nil){
            NSLog(@"Error while fetching image data: %@", error.localizedDescription);
        }
        else{
            cell.delegate = self;
            cell.post = post;
            cell.postImageView.image = [UIImage imageWithData:imageData];
            cell.usernameLabel.text = post.author.username;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd 'at' HH:mm";
            NSString *dateString = [dateFormatter stringFromDate:post.createdAt];
            cell.timestampLabel.text = dateString;
            PFFileObject *pImageFile = post.author[@"profilePic"];
            if (pImageFile){
                cell.posterProfileImageView.image = [UIImage imageWithData:[pImageFile getData]];
            }
            else{
                cell.posterProfileImageView.image = [UIImage imageNamed:@"image_placeholder"];
            }
            cell.posterProfileImageView.layer.cornerRadius = 10;
        }
    }];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {;
    NSLog(@"%lu", self.postsArray.count);
    return self.postsArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navigationController = self.navigationController;
    PostDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailsViewController"];
    viewController.post = self.postsArray[indexPath.row];
    [navigationController pushViewController: viewController animated:YES];
}

- (void)didPost{
    [self queryPosts];
    [self.postTableView reloadData];
}

-(void) postCell:(PostCell *)postCell didTap:(PFUser *)user{
    [self performSegueWithIdentifier:@"ProfileSegue" sender:user];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileSegue"]){
        ProfileViewController *vc = [segue destinationViewController];
        vc.author = sender;
    }
    if([segue.identifier isEqualToString:@"ComposeSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }

}

@end
