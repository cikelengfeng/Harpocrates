//
//  DXMasterViewController.h
//  Harpocrates
//
//  Created by 徐 东 on 13-11-6.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface DXMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
