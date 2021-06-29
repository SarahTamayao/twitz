//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"

@interface TimelineViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayofTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

// Method called when user taps the Sign Out button
- (IBAction)signoutButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // check
    // Clear out the access tokens
    [[APIManager shared] logout];
}

// Get timeline
- (void) loadTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayofTweets = tweets;
            [self.tableView reloadData];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (NSArray *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    // Get timeline
    [self loadTweets];
    
    // For pull to refresh feature
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor blackColor]];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Get the number of tweets that should be in view
- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection: (NSInteger)section {
    return self.arrayofTweets.count;
}

// Set each cell's elements: author, username, tweet, date, button counts
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    for (Tweet *tweet in self.arrayofTweets) {
        NSLog(@"%@", tweet.text);
    }
    
    // Get the tweet
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.arrayofTweets[indexPath.row];
    cell.tweet = tweet;
    
    
    // Set user object attributes
    cell.authorLabel.text = tweet.user.name;
    NSString* username = tweet.user.screenName;
    // Append '@' to the beginning of the retrieved username
    if (username) {
        cell.usernameLabel.text = [@"@" stringByAppendingString:username];
    }
    
    // Set tweet object attributes for labels
    cell.tweetLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    
    // Set tweet object attributes for buttons
    NSString* reply = [NSString stringWithFormat:@"%i", tweet.repliedCount];
    NSString* retweet = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    NSString* favorite = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    
    [cell.replyButton setTitle:reply forState:UIControlStateNormal];
    [cell.retweetButton setTitle:retweet forState:UIControlStateNormal];
    [cell.likeButton setTitle:favorite forState:UIControlStateNormal];
    
    // Set the user's profile image
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profileImage.image = [[UIImage alloc] initWithData:urlData];
    
    return cell;
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
