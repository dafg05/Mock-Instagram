//
//  PostCell.h
//  Mock Ig
//
//  Created by Daniel Flores Garcia on 6/29/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
//#import "PFUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell

@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterProfileImageView;
@property (nonatomic, weak) id<PostCellDelegate> delegate;

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender;

@end

@protocol PostCellDelegate
- (void)postCell:(PostCell *) postCell didTap: (PFUser *)author;
@end

NS_ASSUME_NONNULL_END
