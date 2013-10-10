//
//  JWViewController.m
//  Country Hunt iPad
//
//  Created by Weisblat Jakob 2014 on 10/10/13.
//  Copyright (c) 2013 University School. All rights reserved.
//

#import "JWViewController.h"
#import "JWViewController1.h"
@interface JWViewController ()

@end
 
@implementation JWViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self addChildViewController:[[JWViewController1 alloc] initWithNibName:@"JWViewController1" bundle:nil]];
    return self;
    
}
-(id)init
{
    self=[super init];
    [self addChildViewController:[[JWViewController1 alloc] initWithNibName:@"JWViewController1" bundle:nil]];
    return self;
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    [self addChildViewController:[[JWViewController1 alloc] initWithNibName:@"JWViewController1" bundle:nil]];
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
