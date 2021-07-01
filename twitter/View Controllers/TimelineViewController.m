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
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <UITableViewDataSource, ComposeViewControllerDelegate, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayofTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    // For pull to refresh feature
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor blackColor]];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Get timeline
    [self loadTweets];
}

// Method called when user taps the Sign Out button
- (IBAction)signoutButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // Clear out the access tokens
    [[APIManager shared] logout];
}

// Get timeline of Tweets for the user
- (void) loadTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayofTweets = tweets;
            [self.tableView reloadData];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

// If user just tweeted something, add it to the top of the timeline. New tweet visible immediately after dismissing the compose view.
- (void)didTweet:(Tweet *)tweet {
    [self.arrayofTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Get the number of tweets that should be in view
- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection: (NSInteger)section {
    return self.arrayofTweets.count;
}

// Set each cell's elements: author, username, tweet, date, button counts, profile image, embedded image
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    // Get and set the tweet for the cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.arrayofTweets[indexPath.row];
    cell.tweet = tweet;
    cell.delegate = self;    
    
    // Set User object attributes for the author labels
    cell.authorLabel.text = tweet.user.name;
    NSString* username = tweet.user.screenName;
    // Append '@' to the beginning of the retrieved username
    if (username) {
        cell.usernameLabel.text = [@"@" stringByAppendingString:username];
    }
    
    // Set Tweet object attributes for labels
    cell.tweetLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    
    // Set Tweet object attributes for buttons
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
    
    // Set embedded media image if present
    cell.tweetImage.image = nil;
    if (tweet.mediaUrl) {
        NSURL *mediaURL = [NSURL URLWithString:tweet.mediaUrl];
        NSData *urlData = [NSData dataWithContentsOfURL:mediaURL];
        cell.tweetImage.image = [UIImage imageWithData:urlData];
    }
    
    // Set display of buttons
    if (cell.tweet.favorited) {
        [cell.likeButton setSelected:YES];
    } else {
        [cell.likeButton setSelected:NO];
    }
    
    if (cell.tweet.retweeted) {
        [cell.retweetButton setSelected:YES];
    } else {
        [cell.retweetButton setSelected:NO];
    }
    
    // Set tag of reply button to self.arrayOfTweets index (to access parent tweet after segue to compose view)
    cell.replyButton.tag = indexPath.row;
    
    return cell;
}

// Segue when user taps the profile image of a tweet. Passes the User data to the profile page
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // Perform segue to profile view controller
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//// For infinite loading tweets
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row + 1 == [self.arrayofTweets count]){
//        [self loadTweets:[self.arrayofTweets count] + 20];
//        [self.tableView reloadData];
//    }
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // For details view segue
    if ([[segue identifier] isEqualToString:@"detailViewSegue"]) {
        // Get the Tweet associated with the cell to bring to the details view
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayofTweets[indexPath.row];
        
        DetailsViewController *detailController = [segue destinationViewController];
        detailController.tweet = tweet;
    
    // For profile view segue
    } else if ([[segue identifier] isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileController = [segue destinationViewController];
        profileController.user = sender;
    
    // For compose tweet (composeSegue) and reply tweet (replySegue): same destination = compose view controller
    } else {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
        
        // Pass data to compose view controller: whether user is replying or tweeting, parent tweet for reply only
        if ([[segue identifier] isEqualToString:@"replySegue"]) {
            composeController.isReply = TRUE;
            
            // Retrieve the parent tweet to pass to compose view
            UIButton *replyButton = sender;
            Tweet *tweet = self.arrayofTweets[replyButton.tag];
            composeController.tweet = tweet;
            
        } else {
            composeController.isReply = FALSE;
        }
    }
}


@end
