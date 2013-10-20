//
//  RemindViewController.m
//  IWords
//
//  Created by yaonphy on 12-11-15.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "RemindViewController.h"

@interface RemindViewController ()

@end

@implementation RemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
      self.navigationItem.title = @"Remind";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
