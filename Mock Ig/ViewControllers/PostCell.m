//
//  PostCell.m
//  Mock Ig
//
//  Created by Daniel Flores Garcia on 6/29/22.
//

#import "PostCell.h"
#import "Post.h"


@implementation PostCell


- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.posterProfileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.posterProfileImageView setUserInteractionEnabled:YES];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self didTap:self.post.author];
}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
