//
//  ComposeViewController.h
//  Mock Ig
//
//  Created by Daniel Flores Garcia on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void) didPost;

@end

@interface ComposeViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
