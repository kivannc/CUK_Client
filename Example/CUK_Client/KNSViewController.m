//
//  KNSViewController.m
//  CUK_Client
//
//  Created by Kivanc ERTURK on 06/17/2015.
//  Copyright (c) 2014 Kivanc ERTURK. All rights reserved.
//

#import "KNSViewController.h"
#import "CUK_Client.h"

@interface KNSViewController ()

@end

@implementation KNSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[CUK_Client sharedClient] getMallsCallback:^(NSError *error, id responseObject) {
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
