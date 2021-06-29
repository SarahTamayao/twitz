//
//  TweetCell.m
//  twitter
//
//  Created by constanceh on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    // Update the local tweet model
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    
    // Update cell UI
    self.likeButton.titleLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    [self.likeButton setSelected:YES];
    
    
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

- (IBAction)didTapRetweet:(id)sender {
    // Update the local tweet model
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    
    // Update cell UI
    self.retweetButton.titleLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
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

@end
