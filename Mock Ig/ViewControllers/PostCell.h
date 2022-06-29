//
//  PostCell.h
//  Mock Ig
//
//  Created by Daniel Flores Garcia on 6/29/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end

NS_ASSUME_NONNULL_END
