//
//  RosterViewController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/1/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "RosterViewController.h"

#import "MainAssembly.h"
#import "LoginViewController.h"
#import "MessagesTableViewController.h"

@implementation RosterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.rosterBusinessController addObserver:self forKeyPath:@"isNewBadge" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.queriesBusinessController sendIQToGetRoster];
    [self.queriesBusinessController addObserver:self forKeyPath:@"didReceivedIQRoster" options:NSKeyValueObservingOptionNew context:nil];
    
    self.contactRoster = [NSMutableArray array];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    self.title = [[[self.connectionXMPPBusinessController xmppStream] myJID] bare];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (![self.daoUser getUser]) {
        [self presentLoginViewController];
    } else {
        [self.connectionXMPPBusinessController connectUser:[self.daoUser getUser]];
    }
}

- (void) presentLoginViewController{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * myVC = [sb instantiateViewControllerWithIdentifier:@"loginVC"];
    [self presentViewController:myVC animated:YES completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isNewBadge"]) {
        self.updatedBagesInRoster = YES;
        self.contactRoster = [NSMutableArray arrayWithArray:[self.rosterBusinessController rosterWithUpdatedBadges]];
    } else if ([keyPath isEqualToString:@"didReceivedIQRoster"]){
        self.contactRoster = [self.queriesBusinessController getRoster];
    }
    
    [self updateViewModel];
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.contactRoster enumerateObjectsUsingBlock:^(id contact, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary
                                           dictionaryWithDictionary:contact];
        
        [viewModel addObject:@{
                               @"nib" : @"ContactTableViewCell",
                               @"height" : @(70),
                               @"segue" : @"chat",
                               @"data":cellModel }];
    }];
    
    self.viewModel = [NSArray arrayWithArray:viewModel];
    
    [self registerNibs];
    
    [self.tableView beginUpdates];
    if (self.updatedBagesInRoster) {
        NSNumber *idxContact = [self.rosterBusinessController getIdxContactOfNewBadge];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:
                                                [NSIndexPath indexPathForRow:[idxContact integerValue]
                                                                   inSection:0]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else{
        [self.tableView insertRowsAtIndexPaths:[self returnArrayIndexPaths]
                              withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
}

- (NSMutableArray *) returnArrayIndexPaths{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int index = 0; index < self.viewModel.count; index++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    
    return indexPaths;
}

- (void) registerNibs{
    __weak UITableView * tableView = self.tableView;
    NSMutableSet * registeredNibs = [NSMutableSet set];
    
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![registeredNibs containsObject: nibFile]) {
            [registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"emptyContacts"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"You don't have any contacts yet.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    if ([segue.identifier isEqualToString:@"chat"]){
        MessagesTableViewController * messagesTableViewController = (MessagesTableViewController *)segue.destinationViewController;
        //[messagesTableViewController setCurrentHost: self.currentUser];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    [self performSegue: indexPath];
}

- (void) performSegue: (NSIndexPath *)indexPath{
    NSDictionary * cellModel = self.viewModel[indexPath.row];
    NSString * segueToPerform = cellModel[@"segue"];
    if(segueToPerform) {
        [self performSegueWithIdentifier: segueToPerform
                                  sender: cellModel[@"data"]];
    }
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.onlineBuddies.count;
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    //cell.textLabel.text = [self.onlineBuddies[indexPath.row] string];
    
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    return [self update:[self numberOfBadgeFor:cellViewModel] In:cell];
}

- (NSNumber *) numberOfBadgeFor: (NSDictionary *) contact{
    NSDictionary * dataContact = [contact valueForKey:@"data"];
    if ([dataContact valueForKey:@"badge"]) {
        NSNumber * numberBadge = [dataContact valueForKey:@"badge"];
        return numberBadge;
    }
    
    return 0;
}

- (UITableViewCell *) update: (NSNumber*) numberBadge In: (UITableViewCell *) cell{
    int number = [numberBadge intValue];
    if (number > 0) {
        static CGFloat size = 26;
        static CGFloat digits = 1;
        UILabel * accesoryBadge = [UILabel new];
        accesoryBadge.text = [NSString stringWithFormat:@"%i", number];
        accesoryBadge.backgroundColor = [UIColor blueColor];
        accesoryBadge.textColor = [UIColor whiteColor];
        accesoryBadge.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        accesoryBadge.textAlignment = NSTextAlignmentCenter;
        accesoryBadge.layer.cornerRadius = 13;
        accesoryBadge.layer.masksToBounds = true;
        
        accesoryBadge.frame = CGRectMake(0, 0, fmax(size, 0.7 * size * digits), size);
        cell.accessoryView = accesoryBadge;
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}

@end
