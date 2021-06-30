//
//  DetailsViewController.m
//  twitter
//
//  Created by constanceh on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // Set User object attributes for labels
    self.authorLabel.text = self.tweet.user.name;
    NSString* username = self.tweet.user.screenName;
    // Append '@' to the beginning of the retrieved username
    if (username) {
        self.usernameLabel.text = [@"@" stringByAppendingString:username];
    }
    
    // Set Tweet object attributes for labels
    self.tweetLabel.text = self.tweet.text;
    self.timeLabel.text = self.tweet.time;
    self.dateLabel.text = self.tweet.date;
    
    // Set Tweet object attributes for buttons
    NSString* retweet = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    NSString* favorite = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.retweetCount.text = retweet;
    self.favoriteCount.text = favorite;
    
    // Set the user's profile image
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profileImage.image = [[UIImage alloc] initWithData:urlData];
    
    // Set display of buttons
    if (self.tweet.favorited) {
        [self.favoriteButton setSelected:YES];
    } else {
        [self.favoriteButton setSelected:NO];
    }
    
    if (self.tweet.retweeted) {
        [self.retweetButton setSelected:YES];
    } else {
        [self.retweetButton setSelected:NO];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // Unretweet
    if (self.tweet.retweeted) {
        // Update the local tweet model
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        // Update cell UI
        NSString *retweetCount = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
        self.retweetCount.text = retweetCount;
        [self.retweetButton setSelected:NO];
        
        
        // Send a POST request to the POST retweets/create endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
    
    // Retweet
    } else {
        // Update the local tweet model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        // Update cell UI
        NSString *retweetCount = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
        self.retweetCount.text = retweetCount;
        [self.retweetButton setSelected:YES];
        
        
        // Send a POST request to the POST retweets/create endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    // Unfavorite
    if (self.tweet.favorited) {
        // Update the local tweet model
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // Update view UI
        NSString *favCount = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
        self.favoriteCount.text = favCount;
        [self.favoriteButton setSelected:NO];
        
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    
    // Favorite
    } else {
        // Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // Update cell UI
        NSString *favCount = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
        self.favoriteCount.text = favCount;
        [self.favoriteButton setSelected:YES];
        
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
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
