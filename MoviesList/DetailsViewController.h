//
//  DetailsViewController.h
//  MoviesList
//
//  Created by Doaa Tantawy on 8/9/1440 AH.
//  Copyright © 1440 AH Doaa Tantawy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property NSDictionary *movieObj;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) int favouriteOrNot;
@property (nonatomic) int topRated;

@end

