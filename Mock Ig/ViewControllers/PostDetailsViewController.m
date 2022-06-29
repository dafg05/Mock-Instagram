//
//  PostDetailsViewController.m
//  Mock Ig
//
//  Created by Daniel Flores Garcia on 6/29/22.
//

#import "PostDetailsViewController.h"
#import "Parse/Parse.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    NSData *imageData = [self.post.image getData];
    self.postImageView.image = [UIImage imageWithData:imageData];
    self.captionLabel.text = self.post.caption;
//    PFUser *user = self.post.author;
//    NSLog(@"author: %@", user.username);
    self.usernameLabel.text = self.post.author.username;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd 'at' HH:mm";
    NSString *dateString = [dateFormatter stringFromDate:self.post.createdAt];
    self.timestampLabel.text = dateString;
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
