//
//  ComposeViewController.m
//  twitter
//
//  Created by constanceh on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeTweet;
@property (weak, nonatomic) IBOutlet UILabel *charCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.composeTweet.delegate = self;
    
    // Customize compose tweet view UI
    self.composeTweet.layer.borderWidth = 1.6f;
    self.composeTweet.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.composeTweet.clipsToBounds = YES;
    self.composeTweet.layer.cornerRadius = 8.0f;
    
    // Set placeholder text for the compose tweet box
    self.composeTweet.text = @"What's happening?";
    self.composeTweet.textColor = [UIColor lightGrayColor];
    
    // Set initial character count of 0
    self.charCount.text = @"0";
}

// Cancel button in navigation bar
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

// Tweet button in navigation bar
- (IBAction)tweetButton:(id)sender {
//    [[APIManager shared] postStatusWithText:self.composeTweet.text completion:^(Tweet *tweet, NSError *error) {
//        if (tweet) {
//            NSLog(@"Success! Tweeted message");
//            [self dismissViewControllerAnimated:true completion:nil];
//        } else {
//            NSLog(@"😫😫😫 Error composing tweet: %@", error.localizedDescription);
//        }
//    }];
    
    [[APIManager shared]postStatusWithText:self.composeTweet.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else{
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
            NSLog(@"Compose Tweet Success!");
        }
    }];
}

// When user begins editing the compose tweet box
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"What's happening?"]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

// Set placeholder text if compose tweet box is empty
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"What's happening?";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

// For character count feature
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeTweet.text stringByReplacingCharactersInRange:range withString:text];
    
    // Update character count label
    NSString* characters = [NSString stringWithFormat:@"%i", newText.length];
    self.charCount.text = characters;
    
    // Allow or disallow the new text
    return newText.length < characterLimit;
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
