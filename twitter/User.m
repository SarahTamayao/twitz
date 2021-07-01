//
//  User.m
//  twitter
//
//  Created by constanceh on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.tagline = dictionary[@"description"];
        self.tweetCount = dictionary[@"statuses_count"];
        self.followerCount = dictionary[@"followers_count"];
        self.followingCount = dictionary[@"friends_count"];
    }
    return self;
}

@end
