//
//  ProfileViewController.h
//  
//
//  Created by Daniel Flores Garcia on 6/30/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) PFUser *author;

@end

NS_ASSUME_NONNULL_END
