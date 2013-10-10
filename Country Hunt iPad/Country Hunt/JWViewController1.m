//
//  JWViewController1.m
//  Country Hunt
//
//  Created by Weisblat Jakob 2014 on 9/4/13.
//  Copyright (c) 2013 University School. All rights reserved.
//

#import "JWViewController1.h"
#import "JWGeoGame.h"
#import "ActionSheetPicker.h"
#import "iToast.h"

NSArray *continents;
int selection;
@implementation JWViewController1
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *guess=[textField text];
    [textField setText:@""];
    JWCountry *country=[JWGeoGame getGuess:guess];
    if(country==nil)
    {
        [self noSuchCountry: guess];
        return false;
    }
    int a=[game makeGuess:country];
    [guesses insertObject:country atIndex:0];
    switch (a) {
        case FOUND:
        {
            [results insertObject:@"Found!" atIndex:0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Win!"
                                                            message:[NSString stringWithFormat:@"The country was %@!",[[game hidden] name]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        case REFERENCE:
            [results insertObject:@"Reference" atIndex:0];
            break;
        case CLOSER:
            [results insertObject:@"Closer" atIndex:0];
            break;
        case FARTHER:
            [results insertObject:@"Farther" atIndex:0];
            break;
        case EQUAL:
            [results insertObject:@"Equal" atIndex:0];
            break;
        default:
            return false;
            break;
    }
    [table reloadData];
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return true;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
-(IBAction)giveUp:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Gave Up"
                                                    message:[NSString stringWithFormat:@"The country was %@",[[game hidden] name]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [game newGame];
    guesses=[[NSMutableArray alloc] init];
    results=[[NSMutableArray alloc] init];
    [table reloadData];
    [hint setEnabled:YES];
    [text1 setEnabled:YES];
}
-(IBAction)newGame:(id)sender{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Game"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:nil];
    [message addButtonWithTitle:@"Choose Continent"];
    [message addButtonWithTitle:@"Enter Country"];
    [message addButtonWithTitle:@"Random Country"];
    [message show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[alertView title] isEqual:@"New Game"])
    {
        if(buttonIndex==3){
            [game newGame];
            guesses=[[NSMutableArray alloc] init];
            results=[[NSMutableArray alloc] init];
            [table reloadData];
            [hint setEnabled:YES];
            [text1 setEnabled:YES];
            
        }
        else if(buttonIndex==1)
        {
            [ActionSheetStringPicker showPickerWithTitle:@"Choose a Continent" rows:continents initialSelection:0 target:self successAction:@selector(newGameWithContinent:element:) cancelAction:nil origin:alertView];
        }
        else if(buttonIndex==2)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Country" message:@"Enter a country for a friend to guess:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alert show];
        }
    }
    else if([[alertView title] isEqual:@"Enter Country"])
    {
        if(buttonIndex==0) return;
        JWCountry *country=[JWGeoGame getGuess:[[alertView textFieldAtIndex:0] text]];
        if(country==nil)
        {
            [self noSuchCountry: [[alertView textFieldAtIndex:0] text]];
            return;
        }
        [game newGameWithCountry:country];
        guesses=[[NSMutableArray alloc] init];
        results=[[NSMutableArray alloc] init];
        [table reloadData];
        [hint setEnabled:YES];
        [text1 setEnabled:YES];
        
        
    }
    else if([[alertView title] isEqual:@"You Win!"])
    {
        [text1 setEnabled:NO];
    }
}
-(void)newGameWithContinent:(NSNumber *)selectedIndex element:(id)element{
    
    [game newGameWithContinent:[continents objectAtIndex:[selectedIndex unsignedIntValue]]];
    guesses=[[NSMutableArray alloc] init];
    results=[[NSMutableArray alloc] init];
    [table reloadData];
    [hint setEnabled:YES];
    [text1 setEnabled:YES];
    
}
-(IBAction)hint:(id)sender{
    if([game hinted]){
        NSArray *words=[NSArray arrayWithObjects:@"1",@"Ten",@"100",@"1000",@"10,000",@"100,000",@"1M",@"10M",@"100M",@"1B",@"10B", nil];
        double logpop = log10([[game hidden] population]);
        NSString *lowerBound = [words objectAtIndex:(int) floor(logpop)];
        NSString *upperBound = [words objectAtIndex:(int) ceil(logpop)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                        message:	[NSString stringWithFormat:
                                                                     @"%@ < Population < %@",lowerBound,upperBound]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [hint setEnabled:NO];
        
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Hint" message:[NSString stringWithFormat:@"The country is in %@",[[game hidden] continent]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [game setHinted: YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [guesses count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    
    cell.textLabel.text = ((JWCountry*)[guesses objectAtIndex:[indexPath row]]).name;
    cell.detailTextLabel.text = [results objectAtIndex:[indexPath row]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:.8 alpha:1]];
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryNone;
    
    return cell;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[self view] setTintColor:[UIColor colorWithRed:76/255.0 green:219/255.0 blue:100/255.0 alpha:1]];
    
    NSString *instructions=@"This is a geography guessing game in which you look for a country by repeatedly guessing countries and being told whether you are getting closer or farther from the hidden destination.\n\nFor example, if the hidden country were Denmark, and you guess South Africa followed by Finland, you will find out Finland is closer. If you follow up with China, you will find out China is farther  than Finland [from Denmark]. You continue guessing, until you get the right country.";
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"]) {
        [[[UIAlertView alloc] initWithTitle:@"Instructions" message:instructions delegate:nil cancelButtonTitle:@"OK, got it." otherButtonTitles:nil] show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
    }
    if(!game){
        [JWGeoGame parseJson];
        game=[[JWGeoGame alloc] init];
        [game newGame];
        [hint setEnabled:YES];
        [text1 setEnabled:YES];
    }
    if(!guesses)
    {
        guesses=[[NSMutableArray alloc] init];
        results=[[NSMutableArray alloc] init];
        
    }
    if(!continents)
        continents=[NSArray arrayWithObjects:@"Africa",@"Asia",@"Europe",@"North America",@"South America",@"Oceania", nil];
    [table setScrollsToTop:YES];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)noSuchCountry:(NSString *)country
{
    if(![country isEqualToString:@""])
        [[[iToast makeText:[NSString stringWithFormat:@"%@ doesn't exist.",country]] setGravity:iToastGravityCenter] show];
}
@end
