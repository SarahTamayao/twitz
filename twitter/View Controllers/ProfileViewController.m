//
//  ProfileViewController.m
//  twitter
//
//  Created by constanceh on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *tagline;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set labels: name, username, basic stats (tweet count, follower count, following count)
    self.name.text = self.user.name;
    NSString* username = self.user.screenName;
    // Append '@' to the beginning of the retrieved username
    if (username) {
        self.username.text = [@"@" stringByAppendingString:username];
    }
    
    NSString *tweets = [self.user.tweetCount stringValue];
    NSString *followers = [self.user.followerCount stringValue];
    NSString *following = [self.user.followingCount stringValue];
    self.tweetCount.text = tweets; // convert from NSNumber to NSString
    self.followerCount.text = followers;
    self.followingCount.text = following;
    self.tagline.text = self.user.tagline;
    
    // Set profile image
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profileImage.image = [[UIImage alloc] initWithData:urlData];
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
