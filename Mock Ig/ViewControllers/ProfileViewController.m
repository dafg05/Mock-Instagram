//
//  ProfileViewController.m
//  
//
//  Created by Daniel Flores Garcia on 6/30/22.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.author == nil){
        self.author = [PFUser currentUser];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
