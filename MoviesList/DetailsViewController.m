//
//  DetailsViewController.m
//  MoviesList
//
//  Created by Doaa Tantawy on 8/9/1440 AH.
//  Copyright © 1440 AH Doaa Tantawy. All rights reserved.
//

#import "DetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DBManager.h"
#import "ReviewsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "HCSStarRatingView.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *originalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (nonatomic, strong) DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UITableView *trailersTable;

@end

@implementation DetailsViewController

NSArray *results;
NSString *trailersUrl;
NSMutableArray *trailers;
NSString *idMovie;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"themoviedb.sql"];
    [_trailersTable setDataSource:self];
    [_trailersTable setDelegate:self];
    
}
- (IBAction)addToFavourites:(id)sender {
    NSString *query2 = [NSString stringWithFormat:@"insert into movieFav(movieInfoID,mid ,title, poster_path ,backdrop_path,original_title ,overview,release_date, vote_average) values(null, \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",
                        [[results objectAtIndex:0] objectAtIndex:1],
                        [[results objectAtIndex:0] objectAtIndex:2],
                        [[results objectAtIndex:0] objectAtIndex:3],
                        [[results objectAtIndex:0] objectAtIndex:4],
                        [[results objectAtIndex:0] objectAtIndex:5],
                        [[results objectAtIndex:0] objectAtIndex:6],
                        [[results objectAtIndex:0] objectAtIndex:7],
                        [[results objectAtIndex:0] objectAtIndex:8]];
    [self.dbManager executeQuery:query2];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    printf("view will appear\n");
    
    
    NSString *query;
    if(_favouriteOrNot==1 && _topRated==0){
        query= [NSString stringWithFormat:@"select * from movieInfo where movieInfoID=%d", self.recordIDToEdit];
    }
    else{
        if(_topRated==1){
            query= [NSString stringWithFormat:@"select * from movieTopRated where movieInfoID=%d", self.recordIDToEdit];
        }
        else{
            query= [NSString stringWithFormat:@"select * from movieFav where movieInfoID=%d", self.recordIDToEdit];
            
        }
    }
    
    // Load the relevant data.
    results= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
     [self getTrailers];
    
    NSString *imgUrl=@"http://image.tmdb.org/t/p/w185/";
    
    
    imgUrl = [imgUrl stringByAppendingString:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] objectAtIndex:3]]];
    
    _originalNameLabel.text= [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"original_title"]];
    _releaseLabel.text=[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"release_date"]];
    _voteLabel.text= [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"vote_average"]];
    _overviewLabel.text= [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"overview"]];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl]]
                placeholderImage:[UIImage imageNamed:@"holderImg.png"]];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(200, 262, 140, 45)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.allowsHalfStars = YES;
    float starsValue=[[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"vote_average"]] floatValue]/2.0;
    starRatingView.value = starsValue;
    starRatingView.tintColor = [UIColor redColor];
    starRatingView.enabled=NO;
    [self.view addSubview:starRatingView];
}
- (IBAction)viewReviews:(id)sender {
    ReviewsTableViewController *reviews=[self.storyboard instantiateViewControllerWithIdentifier:@"reviewVC"];
    reviews.movieID=[[results objectAtIndex:0] objectAtIndex:1];
    
    [self.navigationController pushViewController:reviews animated:YES];
}


-(void)getTrailers{
    idMovie=[[results objectAtIndex:0] objectAtIndex:1];
    trailersUrl=@"https://api.themoviedb.org/3/movie/";
    trailersUrl=[trailersUrl stringByAppendingString:idMovie];
    trailersUrl=[trailersUrl stringByAppendingString:@"/videos?api_key=8b1cad7914e5aefb8190b0493bfae7a0"];
    NSURL *URL = [NSURL URLWithString: trailersUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            // NSLog(@"%@",responseObject);
            trailers=(NSMutableArray *) responseObject[@"results"];
            [self->_trailersTable reloadData];
            
            
        }
    }];
    [dataTask resume];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [trailers count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NSDictionary *dict=(NSDictionary *) trailers[indexPath.row];
    cell.textLabel.text=[dict objectForKey:@"name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dict=(NSDictionary *) trailers[indexPath.row];
    NSString *trailerUrl=@"https://www.youtube.com/watch?v=";
    trailerUrl=[trailerUrl stringByAppendingString:[dict objectForKey:@"key"]];
    NSLog(@"%@", trailerUrl);
    NSURL* url = [[NSURL alloc] initWithString:trailerUrl];
    [[UIApplication sharedApplication] openURL: url];
   
}


@end
