//
//  ProfileViewController.m
//  
//
//  Created by Daniel Flores Garcia on 6/30/22.
//

#import "ProfileViewController.h"
#import "PostGridCell.h"
#import "Post.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollectionView;
@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // if no author was set by another view controller,
    // then assume we're seguing into this vc through the tab bar
    self.postCollectionView.dataSource = self;
    if (self.author == nil){
        self.author = [PFUser currentUser];
    }
    // make sure to remove the ability to change profile pics
    // if this profile view is not from the current user.
    // question: is this method exploitable?
    else{
        [self.selectImageButton removeFromSuperview];
    }
    self.usernameLabel.text = self.author[@"username"];
    PFFileObject *imageFile = self.author[@"profilePic"];
    if (imageFile){
        self.profileImageView.image = [UIImage imageWithData:[imageFile getData]];
    }
    else{
        self.profileImageView.image = [UIImage imageNamed:@"image_placeholder"];
    }
    self.profileImageView.layer.cornerRadius = 10;
    [self queryPosts];
}

- (IBAction)didTapSelectPP:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // Do the thing to select a profile image from camera roll
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"Camera is available!!!");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];

    self.profileImageView.backgroundColor = [UIColor systemBackgroundColor];
    self.profileImageView.image = pickedImage;
    PFFileObject *imageFile = [PFFileObject fileObjectWithData:UIImagePNGRepresentation(pickedImage)];
    
    self.author[@"profilePic"] = imageFile;
    
    [self.author saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"Error posting profile pic");
        }
        else{
            NSLog(@"Successfully posted profile pic!");
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)queryPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.author];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Queried for posts!");
            self.postsArray = posts;
            [self.postCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostGridCell" forIndexPath:indexPath];
    Post *post = self.postsArray[indexPath.row];
    cell.postImageView.image = [UIImage imageWithData:[post.image getData]];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
