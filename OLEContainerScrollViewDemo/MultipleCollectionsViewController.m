/*
 OLEContainerScrollView
 
 Copyright (c) 2014 Ole Begemann.
 https://github.com/ole/OLEContainerScrollView
 */

#import "MultipleCollectionsViewController.h"
#import "OLEContainerScrollView.h"
#import "UIColor+RandomColor.h"

@interface MultipleCollectionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet OLEContainerScrollView *containerScrollView;
@property (nonatomic) NSMutableArray *collectionViews;
@property (nonatomic) NSMutableArray *tableViews;
@property (nonatomic) NSMutableArray *numberOfItemsPerCollectionView;
@property (nonatomic) NSMutableArray *cellColorPerCollectionView;
@property (nonatomic) NSMutableArray *numberOfRowsPerTableView;
@property (nonatomic) NSMutableArray *cellColorsPerTableView;

@end

@implementation MultipleCollectionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger numberOfTableViews = 1;
    self.tableViews = [NSMutableArray new];
    self.numberOfRowsPerTableView = [NSMutableArray new];
    self.cellColorsPerTableView = [NSMutableArray new];
    
    for (NSInteger collectionViewIndex = 0; collectionViewIndex < numberOfTableViews; collectionViewIndex++) {
        UIView *tableView = [self preconfiguredTableView];
        NSInteger randomNumberOfRows = 5 + arc4random_uniform(10);
        [self.tableViews addObject:tableView];
        [self.numberOfRowsPerTableView addObject:@(randomNumberOfRows)];
        [self.cellColorsPerTableView addObject:[UIColor randomColor]];
        [self.containerScrollView.contentView addSubview:tableView];
    }
    
    NSInteger numberOfCollectionViews = 1;
    self.collectionViews = [NSMutableArray new];
    self.numberOfItemsPerCollectionView = [NSMutableArray new];
    self.cellColorPerCollectionView = [NSMutableArray new];
    
    for (NSInteger collectionViewIndex = 0; collectionViewIndex < numberOfCollectionViews; collectionViewIndex++) {
        UIView *collectionView = [self preconfiguredCollectionView];
        NSInteger randomNumberOfItemsInCollectionView = arc4random_uniform(50) + 10;
        [self.collectionViews addObject:collectionView];
        [self.numberOfItemsPerCollectionView addObject:@(randomNumberOfItemsInCollectionView)];
        [self.cellColorPerCollectionView addObject:[UIColor randomColor]];
        [self.containerScrollView.contentView addSubview:collectionView];
    }
}

- (UICollectionView *)preconfiguredCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MyCell"];
    collectionView.backgroundColor = [UIColor whiteColor];
    return collectionView;
}

- (IBAction)addCollectionViewCell:(id)sender
{
    NSInteger collectionViewIndex = 0;
    UICollectionView *collectionView = self.collectionViews[collectionViewIndex];
    NSInteger previousNumberOfItemsInCollectionView = [self.numberOfItemsPerCollectionView[collectionViewIndex] integerValue];
    NSInteger newNumberOfItemsInCollectionView = previousNumberOfItemsInCollectionView + 1;
    self.numberOfItemsPerCollectionView[collectionViewIndex] = @(newNumberOfItemsInCollectionView);
    [collectionView performBatchUpdates:^{
        NSIndexPath *indexPathOfAddedCell = [NSIndexPath indexPathForItem:previousNumberOfItemsInCollectionView inSection:0];
        [collectionView insertItemsAtIndexPaths:@[ indexPathOfAddedCell ]];
    } completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger collectionViewIndex = [self.collectionViews indexOfObject:collectionView];
    NSInteger numberOfItemsInCollectionView = [self.numberOfItemsPerCollectionView[collectionViewIndex] integerValue];
    return numberOfItemsInCollectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    NSUInteger collectionViewIndex = [self.collectionViews indexOfObject:collectionView];
    UIColor *cellColor = self.cellColorPerCollectionView[collectionViewIndex];
    cell.backgroundColor = cellColor;
    return cell;
}

- (UITableView *)preconfiguredTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
    tableView.backgroundColor = [UIColor whiteColor];
    return tableView;
}

- (IBAction)addTableViewCell:(id)sender
{
    NSInteger tableViewIndex = 0;
    UITableView *tableView = self.tableViews[tableViewIndex];
    NSInteger previousNumberOfRows = [self.numberOfRowsPerTableView[tableViewIndex] integerValue];
    NSInteger newNumberOfRows = previousNumberOfRows + 1;
    self.numberOfRowsPerTableView[tableViewIndex] = @(newNumberOfRows);
    
    [tableView beginUpdates];
    NSIndexPath *indexPathOfAddedCell = [NSIndexPath indexPathForItem:previousNumberOfRows inSection:0];
    [tableView insertRowsAtIndexPaths:@[ indexPathOfAddedCell ] withRowAnimation:UITableViewRowAnimationTop];
    [tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
    NSInteger numberOfRowsInTableView = [self.numberOfRowsPerTableView[tableViewIndex] integerValue];
    return numberOfRowsInTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    NSUInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
    UIColor *cellColor = self.cellColorsPerTableView[tableViewIndex];
    cell.backgroundColor = cellColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will display: %ld", indexPath.row);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did selected: %ld", indexPath.row);
}

@end
