//
//  JWViewController.h
//  Country Hunt
//
//  Created by Weisblat Jakob 2014 on 9/4/13.
//  Copyright (c) 2013 University School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWGeoGame.h"
@interface JWViewController1 : UIViewController <UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    JWGeoGame *game;
    NSMutableArray *guesses;
    NSMutableArray *results;
    IBOutlet UITableView *table;
    IBOutlet UITextField *text1;
    IBOutlet UIBarButtonItem *hint;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(IBAction)giveUp:(id)sender;
-(IBAction)newGame:(id)sender;
-(IBAction)hint:(id)sender;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)noSuchCountry:(NSString*)country;

@end
